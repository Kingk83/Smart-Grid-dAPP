// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTraceability {
    struct EnergySource {
        address owner;
        string sourceType; // e.g., "Solar", "Wind", "Hydro"
        uint256 capacity;  // in kW
        string location;
        bool isActive;
    }

    struct ProductionLog {
        uint256 timestamp;
        uint256 amountProduced; // in kWh
    }

    struct EnergyTransaction {
        uint256 timestamp;
        address buyer;
        address seller;
        uint256 amount; // in kWh
        uint256 sourceId;
    }

    EnergySource[] public energySources;
    mapping(uint256 => ProductionLog[]) public productionLogs; // sourceId => ProductionLog[]
    EnergyTransaction[] public energyTransactions;

    event EnergySourceRegistered(uint256 indexed sourceId, address owner, string sourceType, uint256 capacity, string location);
    event ProductionLogged(uint256 indexed sourceId, uint256 timestamp, uint256 amountProduced);
    event EnergyTransactionRecorded(uint256 indexed transactionId, uint256 timestamp, address buyer, address seller, uint256 amount, uint256 sourceId);

    // Register a new energy source
    function registerEnergySource(string memory _sourceType, uint256 _capacity, string memory _location) public {
        uint256 sourceId = energySources.length;
        energySources.push(EnergySource(msg.sender, _sourceType, _capacity, _location, true));
        emit EnergySourceRegistered(sourceId, msg.sender, _sourceType, _capacity, _location);
    }

    // Log production for an energy source
    function logProduction(uint256 _sourceId, uint256 _amountProduced) public {
        require(energySources[_sourceId].owner == msg.sender, "Not the owner of the energy source");
        require(energySources[_sourceId].isActive, "Energy source is not active");
        productionLogs[_sourceId].push(ProductionLog(block.timestamp, _amountProduced));
        emit ProductionLogged(_sourceId, block.timestamp, _amountProduced);
    }

    // Record an energy transaction
    function recordEnergyTransaction(uint256 _sourceId, address _buyer, address _seller, uint256 _amount) public {
        require(energySources[_sourceId].isActive, "Energy source is not active");
        uint256 transactionId = energyTransactions.length;
        energyTransactions.push(EnergyTransaction(block.timestamp, _buyer, _seller, _amount, _sourceId));
        emit EnergyTransactionRecorded(transactionId, block.timestamp, _buyer, _seller, _amount, _sourceId);
    }

    // Additional functions can be implemented to enable updates to energy sources, querying specific logs, and managing access permissions.
}
