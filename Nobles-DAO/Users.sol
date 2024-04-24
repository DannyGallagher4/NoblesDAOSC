pragma solidity >=0.8.2 <0.9.0;

contract Users{

    address[] public students;
    address[] public teachers;
    address[] public admins;

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

    function getStudentAddresses() public view returns (address[] memory){
        return students;
    }

    function getTeacherAddresses() public view returns (address[] memory){
        return teachers;
    }

}