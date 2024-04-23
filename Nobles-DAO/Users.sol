pragma solidity >=0.8.2 <0.9.0;

contract Users{

    address[] public validAddresses;
    address public chairperson;

    constructor() {
        chairperson = msg.sender;
    }

    function addValidAddress(address newValid) public {
        require(msg.sender == chairperson);
        for(uint i = 0; i < validAddresses.length; i++){
            require(newValid != validAddresses[i]);
        }
        validAddresses.push(newValid);
    }

    function getValidAddresses() public view returns (address[] memory){
        return validAddresses;
    }

}