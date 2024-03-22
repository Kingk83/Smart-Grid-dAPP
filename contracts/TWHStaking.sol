// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TWHStaking is ReentrancyGuard {
    using SafeMath for uint256;

    IERC20 public twhToken;

    // Updated UserInfo structure to include endTime
    struct UserInfo {
        uint256 amount;    // How many TWH tokens the user has staked.
        uint256 stakeTime; // Timestamp when user deposited.
        uint256 endTime;   // Timestamp when the stake period ends.
    }

    // Info of each user that stakes tokens (user address => UserInfo).
    mapping(address => UserInfo) public userInfo;

    event Staked(address indexed user, uint256 amount, uint256 endTime);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(IERC20 _twhToken) {
        twhToken = _twhToken;
    }

    // Updated stake function to include a locking period.
    function stake(uint256 _amount, uint256 _lockTimeInSeconds) public nonReentrant {
        require(_amount > 0, "Cannot stake 0");

        UserInfo storage user = userInfo[msg.sender];
        
        // Ensure that users can only stake if they have no active stakes or their stake has ended.
        require(user.amount == 0 || block.timestamp >= user.endTime, "Existing stake not ended");

        twhToken.transferFrom(msg.sender, address(this), _amount);
        user.amount = _amount;
        user.stakeTime = block.timestamp;
        user.endTime = block.timestamp.add(_lockTimeInSeconds);

        emit Staked(msg.sender, _amount, user.endTime);
    }

    // Withdraw function updated to check against endTime.
    function withdraw() public nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount > 0, "Nothing to withdraw");
        require(block.timestamp >= user.endTime, "Stake is locked");

        uint256 amount = user.amount;
        user.amount = 0; // Reset the staked amount to 0 upon withdrawal

        twhToken.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    // Additional helper functions remain unchanged.
    function balanceOf(address _user) public view returns (uint256) {
        return userInfo[_user].amount;
    }

    function stakeTimeOf(address _user) public view returns (uint256) {
        return userInfo[_user].stakeTime;
    }

    function endTimeOf(address _user) public view returns (uint256) {
        return userInfo[_user].endTime;
    }
}

