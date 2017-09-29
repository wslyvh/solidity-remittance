pragma solidity ^0.4.15;

import "./Owned.sol";

contract Terminable is Owned {
    
    function terminate() external onlyOwner {
        selfdestruct(owner);
    }
}