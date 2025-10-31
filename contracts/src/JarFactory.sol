//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IJarFactory.sol";
import "./interfaces/IRegistry.sol";
import "./TipJar.sol";

/**
 * @title JarFactory
 * @notice Factory contract for deploying TipJar instances
 */

contract JarFactory is IJarFactory {
    address public immutable REGISTRY;
    /**
     * @notice Constructor
     * @param _registry Registry contract address
     */

    constructor(address _registry) {
        require(_registry != address(0), "JarFactory: zero registry");
        REGISTRY = _registry;
    }
    /**
     * @notice Create a new TipJar
     * @param handle Unique handle for the jar (e.g., "saswat")
     * @param beneficiaries Array of beneficiary addresses
     * @param bps Array of basis points for each beneficiary
     * @param feeBps Fee in basis points (100 = 1%)
     * @return jar Address of the deployed TipJar
     */

    function createJar(
        string memory handle,
        address[] memory beneficiaries,
        uint256[] memory bps,
        uint256 feeBps
    ) external override returns (address jar) {
        require(bytes(handle).length > 0, "JarFactory: empty handle");

        TipJar newJar = new TipJar(msg.sender, REGISTRY, beneficiaries, bps, feeBps);
        jar = address(newJar);
        emit JarCreated(msg.sender, jar, handle);
    }
}
