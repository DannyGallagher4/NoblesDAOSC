pragma solidity >=0.8.2 <0.9.0;

contract NoblesDAO{

    address[] public students;
    address[] public teachers;
    address[] public admins;

    uint counter = 1;

    struct Choice{
        string option;
        address[] votes;
    }

    struct Poll{
        uint id;
        string name;
        Choice[] choices;
    }

    Poll[] activePolls;
    Poll[] inactivePolls;

    constructor() {
        admins.push(msg.sender);
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
        require(containsAddress(admins, msg.sender));
        require(!containsAddress(students, newStudent));
        students.push(newStudent);
    }

    function addTeacherAddress(address newTeacher) public {
        require(containsAddress(admins, msg.sender));
        require(!containsAddress(teachers, newTeacher));
        teachers.push(newTeacher);
    }

    function addAdminAddress(address newAdmin) public {
        require(containsAddress(admins, msg.sender));
        require(!containsAddress(admins, newAdmin));
        admins.push(newAdmin);
    }

    function getStudentAddresses() public view returns (address[] memory){
        return students;
    }

    function getTeacherAddresses() public view returns (address[] memory){
        return teachers;
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
    
    function deletePoll(address originalCaller, uint pollid) public { 
        require(containsAddress(teachers, originalCaller)); 
        for (uint p = 0; p < activePolls.length; p++) {
            if (activePolls[p].id == pollid) {
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

}