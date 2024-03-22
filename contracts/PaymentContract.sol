// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TWHPayment is ReentrancyGuard {
    IERC20 public twhToken;

    // Address where collected fees will be sent
    address public feeCollector;

    // Fee rate as a percentage of the transaction amount (e.g., 1% = 100, 0.5% = 50)
    uint256 public feeRate;

    event PaymentMade(address indexed from, address indexed to, uint256 amount, uint256 fee);
    event Received(address indexed from, uint256 amount);

    constructor(IERC20 _twhToken, address _feeCollector, uint256 _feeRate) {
        require(_feeRate <= 10000, "Fee rate too high"); // Max 100% fee
        twhToken = _twhToken;
        feeCollector = _feeCollector;
        feeRate = _feeRate;
    }

    // Allows a user to send TWH tokens to another address, deducting a fee
    function makePayment(address _to, uint256 _amount) external nonReentrant {
        require(_to != address(0), "Cannot pay to the zero address");
        require(_amount > 0, "Amount must be greater than 0");

        uint256 fee = _amount * feeRate / 10000;
        uint256 amountAfterFee = _amount - fee;

        require(twhToken.transferFrom(msg.sender, _to, amountAfterFee), "Payment failed");
        if (fee > 0) {
            require(twhToken.transferFrom(msg.sender, feeCollector, fee), "Fee transfer failed");
        }

        emit PaymentMade(msg.sender, _to, amountAfterFee, fee);
    }

    // Function to allow the contract to receive ETH payments (if needed)
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // Utility function to check the TWH token balance of this contract
    function checkContractTWHBalance() public view returns (uint256) {
        return twhToken.balanceOf(address(this));
    }

    // Functions to update the feeCollector and feeRate by the current feeCollector
    function setFeeCollector(address _newFeeCollector) external {
        require(msg.sender == feeCollector, "Only the fee collector can update this");
        feeCollector = _newFeeCollector;
    }

    function setFeeRate(uint256 _newFeeRate) external {
        require(msg.sender == feeCollector, "Only the fee collector can update this");
        require(_newFeeRate <= 10000, "Fee rate too high"); // Ensuring fee rate does not exceed 100%
        feeRate = _newFeeRate;
    }
}

