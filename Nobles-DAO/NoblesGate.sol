pragma solidity >=0.8.2 <0.9.0;

contract NoblesGate{

    address admin;

    constructor(){
        admin = msg.sender;
    }

}