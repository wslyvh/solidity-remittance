pragma solidity ^0.4.15;

import "./Terminable.sol";

contract Remittance is Terminable {
    
    struct Deposit { 
        address owner;
        uint value;
        uint deadline;
        bool withdrawn;
    }

    mapping(bytes32 => Deposit) deposits;

    function deposit(uint deadline, bytes32 hashedSecret) payable public returns (bool success) { 
        require(deadline > block.timestamp);
        require(hashedSecret > 0);
        require(msg.value > 0);

        deposits[hashedSecret].owner = msg.sender;
        deposits[hashedSecret].value = msg.value;
        deposits[hashedSecret].deadline = deadline;

        LogNewDeposit(msg.sender, deadline, msg.value);
        return true;
    }
    
    function withdraw(uint password) public returns (bool success) {
        require(password > 0);

        var secret = keccak256(msg.sender, password);
        require(deposits[secret].withdrawn == false);
        require(deposits[secret].deadline > block.timestamp);
        uint toWithdraw = deposits[secret].value;

        deposits[secret].value = 0;
        deposits[secret].withdrawn = true;
        msg.sender.transfer(toWithdraw);
        
        LogWithdrawal(msg.sender, toWithdraw);
        return true;
    }
    
    function returnFunds(bytes32 hashedSecret) public returns (bool success) {
        require(hashedSecret > 0);
        require(deposits[hashedSecret].owner == msg.sender);
        require(deposits[hashedSecret].deadline < block.timestamp);
        
        uint toWithdraw = deposits[hashedSecret].value;
        deposits[hashedSecret].value = 0;
        deposits[hashedSecret].withdrawn = true;
        deposits[hashedSecret].owner.transfer(toWithdraw);
        
        LogReturnFunds(msg.sender, toWithdraw);
        return true;
    }

    event LogNewDeposit(address owner, uint deadline, uint value);
    event LogWithdrawal(address beneficier, uint value);
    event LogReturnFunds(address owner, uint value);
}