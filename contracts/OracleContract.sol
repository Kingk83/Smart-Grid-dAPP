// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectricityPriceOracle {
    // Address of the contract owner or the oracle data provider
    address public owner;

    // Stores the latest electricity price (e.g., in cents per kWh)
    uint public latestElectricityPrice;

    // Event that is emitted every time the price is updated
    event PriceUpdated(uint newPrice);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict certain functions to the owner/oracle provider
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    // Function to update the electricity price
    // In a real-world scenario, this would be called by an off-chain oracle or the contract owner
    function updateElectricityPrice(uint _newPrice) public onlyOwner {
        latestElectricityPrice = _newPrice;
        emit PriceUpdated(_newPrice);
    }

    // Function to change the oracle data provider (owner)
    // This might be necessary if the responsibility for updating the oracle data is transferred
    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
