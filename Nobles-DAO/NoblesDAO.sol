pragma solidity >=0.8.2 <0.9.0;

import "./NoblesStorage.sol";

contract NoblesDAO{

    uint counter = 1;
    address admin;
    NoblesStorage public noblesStorage;

    struct Choice{
        string option;
        address[] votes;
    }

    struct Poll{
        uint id;
        string name;
        Choice[] choices;
    }

    constructor(address _noblesStorageAddress) {
        admin = msg.sender;
        noblesStorage = NoblesStorage(_noblesStorageAddress);
    }

    function containsAddress(address[] memory myArray, address _value) public pure returns (bool){
        for (uint i = 0; i < myArray.length; i++) {
            if (myArray[i] == _value) {
                return true;
            }
        }
        return false;
    }

    function addStudentAddress(address newStudent) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getStudentAddresses(), newStudent));
        noblesStorage.addStudentAddresses(newStudent);
    }

    function addTeacherAddress(address newTeacher) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getTeacherAddresses(), newTeacher));
        noblesStorage.addTeacherAddresses(newTeacher);
    }

    function addAdminAddress(address newAdmin) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getAdminAddresses(), newAdmin));
        noblesStorage.addAdminAddresses(newAdmin);
    }

    function createPoll(address originalCaller, string memory question, string[] memory options) public {
        require(containsAddress(noblesStorage.getTeacherAddresses(), originalCaller));
        NoblesStorage.Choice[] memory myChoices = new NoblesStorage.Choice[](options.length);
        for(uint i = 0; i < options.length; i++){
            address[] memory myaddr;
            myChoices[i] = NoblesStorage.Choice(options[i], myaddr);
        }
        noblesStorage.addActivePoll(NoblesStorage.Poll(counter, question, myChoices));
        counter++;
    }
    
    function deletePoll(address originalCaller, uint pollId) public { 
        require(containsAddress(noblesStorage.getTeacherAddresses(), originalCaller)); 
        for (uint p = 0; p < noblesStorage.getActivePolls().length; p++) {
            if (noblesStorage.getActivePolls()[p].id == pollId) {
                noblesStorage.addInactivePoll(noblesStorage.getActivePolls()[p]);
                noblesStorage.setActivePollIndex(p, noblesStorage.getActivePolls()[noblesStorage.getActivePolls().length - 1]);
                noblesStorage.popActivePoll();
                return;
            }
        }
    }

    function vote(address originalCaller, uint pollId, uint optionIndex) public{
        require(containsAddress(noblesStorage.getStudentAddresses(), originalCaller));
        for(uint i = 0; i < noblesStorage.getActivePolls().length; i++){
            if(noblesStorage.getActivePolls()[i].id == pollId){
                for(uint j = 0; j < noblesStorage.getActivePolls()[i].choices.length; j++){
                    require(!containsAddress(noblesStorage.getActivePolls()[i].choices[j].votes, originalCaller), "User already voted");
                }
                noblesStorage.addVote(i, optionIndex, originalCaller);
                break;
            }
        }
    }

    function viewPolls(address originalCaller) public view returns (NoblesStorage.Poll[] memory) {
        require(containsAddress(noblesStorage.getStudentAddresses(), originalCaller) || containsAddress(noblesStorage.getTeacherAddresses(), originalCaller) || containsAddress(noblesStorage.getAdminAddresses(), originalCaller));
        return noblesStorage.getActivePolls();
    }

}