contract NoblesStorage{
    struct Choice{
        string option;
        address[] votes;
    }

    struct Poll{
        uint id;
        string name;
        Choice[] choices;
    }

    address[] public students;
    address[] public teachers;
    address[] public admins;

    Poll[] activePolls;
    Poll[] inactivePolls;

    function getStudentAddresses() public view returns (address[] memory){
        return students;
    }

    function getTeacherAddresses() public view returns (address[] memory){
        return teachers;
    }

    function getAdminAddresses() public view returns (address[] memory){
        return admins;
    }
    
    function addStudentAddresses(address student) public {
        students.push(student);
    }

    function addTeacherAddresses(address teacher) public {
        students.push(teacher);
    }

    function addAdminAddresses(address admin) public {
        students.push(admin);
    }
}