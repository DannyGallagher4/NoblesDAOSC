pragma solidity >=0.8.2 <0.9.0;

contract Users{

    address[] public validAddresses;


    function addValidAddress() public {
        validAddresses.push(msg.sender);
    }

    function getValidAddresses() public view returns (address[]){
        return validAddresses;
    }

}