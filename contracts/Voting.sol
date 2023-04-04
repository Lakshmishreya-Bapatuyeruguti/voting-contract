//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Voting{
    address electionOrganizer;
    uint id=1;
    bool electionStarted=false;
    bool electionEnded=false;
    struct Candidate{
        uint candidateId;
        string candidateName;
        uint candidateAge;
        string partyName;
        address candiadateAddress;
        uint    votesRececieved;
    }
    address[] public allCandidateAddresses;
    mapping(address=>Candidate) public candidates;

    struct Voter{
        uint voterId;
        string voterName;
        address voterAddress;
        uint voterAge;
        uint votedTo;
        bool hasVoted;
    }
    address[] public allVoterAddresses;
    address[] public votedList;
    mapping(address=>Voter) public voters;

    constructor(){
        electionOrganizer=msg.sender;
        
    }
    modifier isElectionOrganizer(){
        _;
        require(msg.sender==electionOrganizer,"Only election organizer is allowed");
    }
    modifier electionHasStarted(){
        _;
        require(electionStarted,"Election not started yet");
    }
  
    function startVoting() public isElectionOrganizer{
        electionStarted=true;
    }
       function endVoting() public isElectionOrganizer{
        electionEnded=true;
        electionStarted=false;
    }
    function setCandidate(string memory _name, uint _age, string memory _partyName, address _address) public isElectionOrganizer{
        Candidate storage candidate=candidates[_address] ;
        id=id+1;
        candidate.candidateId=id;
        candidate.candidateName=_name;
        candidate.candidateAge=_age;
        candidate.partyName=_partyName;
        candidate.candiadateAddress=_address;
        allCandidateAddresses.push(_address);
    }
    function addVoter(string memory _name,uint _age,address _address) public isElectionOrganizer{
        id=id+1;
        Voter storage voter = voters[_address];
        voter.voterId=id;
        voter.voterName=_name;
        voter.voterAge=_age;
        voter.voterAddress=_address;
        voter.hasVoted=false;
        allVoterAddresses.push(_address);
    }   
    function voteTo(uint _candidateId, address _candidateAddress) public electionHasStarted{
        Voter storage voter=voters[msg.sender];
        voter.votedTo=_candidateId;
        require(!voter.hasVoted,"Already Voted");
        require(msg.sender!=electionOrganizer,"Organizer can't vote");
        candidates[_candidateAddress].votesRececieved+=1;
        voter.hasVoted=true;
        votedList.push(msg.sender);
    }
    function getWinner() public view  returns (Candidate memory) {
        uint256 winningVoteCount = 0;
        uint256 winningCandidateIndex = 0;
        require(electionEnded,"Election didn't end");
        for (uint256 i = 0; i < allCandidateAddresses.length; i++) {
            if (candidates[allCandidateAddresses[i]].votesRececieved > winningVoteCount) {
                winningVoteCount = candidates[allCandidateAddresses[i]].votesRececieved;
                winningCandidateIndex = i;
            }
        }  

        return candidates[allCandidateAddresses[winningCandidateIndex]];
    }
}