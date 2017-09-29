pragma solidity ^0.4.15;

contract Owned {
    address public owner;
    address private ownerCandidate;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier onlyOwnerCandidate() {
        require(msg.sender == ownerCandidate);
        _;
    }

    function Owned() {
        owner = msg.sender;
    }

    function transferOwnership(address candidate) external onlyOwner {
        ownerCandidate = candidate;
    }

    function acceptOwnership() external onlyOwnerCandidate {
        owner = ownerCandidate;
    }
}