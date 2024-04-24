pragma solidity >=0.8.2 <0.9.0;

contract Polls{

    address public userContractAddress;

    struct Poll{
        uint id;
        string name;

        //these next 2 lines are current placeholders for the better way we will store votes and choices
        string[] choices;
        mapping(string => address[]) votes;
    }

    constructor(address _userContractAddress){
        userContractAddress = _userContractAddress;
    }



}