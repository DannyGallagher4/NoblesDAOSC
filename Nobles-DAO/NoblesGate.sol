pragma solidity >=0.8.2 <0.9.0;

import "./NoblesDAO.sol";

contract NoblesGate{

    address admin;
    address NoblesDAOAddr;
    mapping(string => function(address) external) public functionMap;
    mapping(string => bool) public isFunctionRegistered;
    string[] funcNames = ["addStudentAddress", "addTeacherAddress", "addAdminAddress", "createPoll", "vote"];

    constructor(address contractAddr){
        admin = msg.sender;
        NoblesDAOAddr = contractAddr;
        for(uint i = 0; i < funcNames.length; i++){
            functionMap["addStudentAddress"] = NoblesDAO(NoblesDAOAddr).addStudentAddress;
            isFunctionRegistered["addStudentAddress"] = true;
        }

    }

    function callFunc(string memory functionName) public{
        require(msg.sender == admin);
        require(isFunctionRegistered[functionName], "Function not registered");
        functionMap[functionName](admin);
    }

    function updateAddr(address newAddr) public{
        require(msg.sender == admin);
        NoblesDAOAddr = newAddr;
    }

}