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
        require(containsAddress(teachers, originalCaller));
        Choice[] memory myChoices = new Choice[](options.length);
        for(uint i = 0; i < options.length; i++){
            address[] memory myaddr;
            myChoices[i] = Choice(options[i], myaddr);
        }
        activePolls.push(Poll(counter, question, myChoices));
        counter++;
    }
    
    function deletePoll(address originalCaller, uint pollId) public { 
        require(containsAddress(teachers, originalCaller)); 
        for (uint p = 0; p < activePolls.length; p++) {
            if (activePolls[p].id == pollId) {
                inactivePolls.push(activePolls[p]);
                activePolls[p] = activePolls[activePolls.length - 1]; 
                activePolls.pop(); 
                return; 
            }
        }
    }

    function vote(address originalCaller, uint pollId, uint optionIndex) public{
        require(containsAddress(students, originalCaller));
        for(uint i = 0; i < activePolls.length; i++){
            if(activePolls[i].id == pollId){
                for(uint j = 0; j < activePolls[i].choices.length; j++){
                    require(!containsAddress(activePolls[i].choices[j].votes, originalCaller), "User already voted");
                }
                activePolls[i].choices[optionIndex].votes.push(originalCaller);
                break;
            }
        }
    }

    function viewPolls(address originalCaller) public view returns (Poll[] memory) {
        require(containsAddress(students, originalCaller) || containsAddress(teachers, originalCaller) || containsAddress(admins, originalCaller));
        return activePolls;
    }

}