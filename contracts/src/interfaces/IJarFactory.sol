// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
/**
 * @title IJarFactory
 * @notice Interface for factory that deploys TipJar instances
 */

interface IJarFactory{
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
    ) external returns (address jar);

    /**
     * @notice Emitted when a new jar is created
     * @param owner Creator of the jar
     * @param jar Address of the deployed TipJar
     * @param handle Unique handle
     */
     event JarCreated(address indexed owner, address indexed jar , string indexed handle);
}