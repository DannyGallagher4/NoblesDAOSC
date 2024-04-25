pragma solidity >=0.8.2 <0.9.0;

contract Polls{

    address public userContractAddress;
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

    function containsAddress(address[] memory myArray, address _value) public pure returns (bool){
        for (uint i = 0; i < myArray.length; i++) {
            if (myArray[i] == _value) {
                return true;
            }
        }
        return false;
    }

    function createPoll(address[] memory teachers, address originalCaller, string memory question, string[] memory options) public {
        require(containsAddress(teachers, originalCaller));
        Choice[] memory myChoices = new Choice[](options.length);
        for(uint i = 0; i < options.length; i++){
            address[] memory myaddr;
            myChoices[i] = Choice(options[i], myaddr);
        }
        activePolls.push(Poll(counter, question, myChoices));
        counter++;
    }

    function vote(address[] memory users, address originalCaller, uint pollId, uint optionIndex) public{
        require(containsAddress(users, originalCaller));
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