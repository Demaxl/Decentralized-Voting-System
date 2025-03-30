// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;


contract VotingSystem {
    mapping(string name => uint256 voteCount) public candidates;
    mapping(string => bool) public  hasCandidate; // Tracks existence of a candidate

    mapping(address => string) public voters;
    mapping(address => bool) public  hasVoter;

    struct Candidate {
        string name;
        uint256 voteCount;
    }
    Candidate public winner;

    address public i_owner;
    constructor() {
        i_owner = msg.sender;
    }

    function addCandidate(string calldata _name) external  onlyOwner {
        candidates[_name] = 0;
        hasCandidate[_name] = true;
    }

    function vote(string calldata _candidateName) external  {
        require(hasCandidate[_candidateName], "Candidate doesn't exist");
        require(!hasVoter[msg.sender], "Sender has already voted");

        // Increments candidates vote count
        uint256 currentVoteCount = ++candidates[_candidateName];

        // Update the current winner if the candidate has higher votes
        if (currentVoteCount > winner.voteCount) {
            winner.voteCount = currentVoteCount;
            winner.name = _candidateName;
        }

        
        // Register the caller of the transaction as a voter
        voters[msg.sender] = _candidateName;
        hasVoter[msg.sender] = true;
    }



    modifier onlyOwner {
        require(msg.sender == i_owner);
        _;
    }
}