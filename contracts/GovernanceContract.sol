// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Governance is Ownable {
    using SafeMath for uint256;

    IERC20 public votingToken;
    uint256 public minimumQuorum; // Minimum number of tokens that must be voted for a proposal to be valid
    uint256 public votingPeriod; // Time in seconds that voting is allowed for a proposal

    struct Proposal {
        string description;
        bytes callData; // Encoded function call to execute the proposal's action
        address recipient; // Contract to be called
        uint256 voteCount; // Number of votes in favor of the proposal
        bool executed;
        uint256 creationTime; // Timestamp when the proposal was created
        mapping(address => bool) voters;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint256 indexed proposalId, string description, address recipient);
    event Voted(uint256 indexed proposalId, address voter, uint256 votes);
    event ProposalExecuted(uint256 indexed proposalId);

    constructor(IERC20 _votingToken, uint256 _minimumQuorum, uint256 _votingPeriod) {
        votingToken = _votingToken;
        minimumQuorum = _minimumQuorum;
        votingPeriod = _votingPeriod;
    }

    // Create a new proposal
    function createProposal(string memory _description, bytes memory _callData, address _recipient) public onlyOwner {
        uint256 proposalId = proposals.length;
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
        newProposal.callData = _callData;
        newProposal.recipient = _recipient;
        newProposal.voteCount = 0;
        newProposal.executed = false;
        newProposal.creationTime = block.timestamp;

        emit ProposalCreated(proposalId, _description, _recipient);
    }

    // Vote on an active proposal
    function vote(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voters[msg.sender] == false, "Already voted");
        require(block.timestamp <= proposal.creationTime + votingPeriod, "Voting period has ended");

        uint256 votes = votingToken.balanceOf(msg.sender);
        require(votes > 0, "No votes available");

        proposal.voteCount = proposal.voteCount.add(votes);
        proposal.voters[msg.sender] = true;

        emit Voted(_proposalId, msg.sender, votes);
    }

    // Execute a proposal after voting period has ended
    function executeProposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp >= proposal.creationTime + votingPeriod, "Voting period not yet ended");
        require(proposal.voteCount >= minimumQuorum, "Quorum not reached");

        (bool success,) = proposal.recipient.call(proposal.callData);
        require(success, "Proposal execution failed");
        proposal.executed = true;

        emit ProposalExecuted(_proposalId);
    }

    // Utility function to retrieve the number of proposals
    function getProposalsCount() public view returns (uint256) {
        return proposals.length;
    }

    // Utility function to check if an address has voted on a proposal
    function hasVoted(uint256 _proposalId, address _voter) public view returns (bool) {
        return proposals[_proposalId].voters[_voter];
    }
}
