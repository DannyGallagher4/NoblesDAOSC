contract NoblesDAO{
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

}