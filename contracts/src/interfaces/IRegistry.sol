//SPDX-License-Identifier:MIT
pragma solidity ^0.8.23;

/**
 * @title IRegistry
 * @notice Interface for token allowlist and fee configuration
 */

interface IRegistry {
    /**
     * @notice Check if a token is allowlisted
     * @param token Token address to check (address(0) for ETH)
     * @return true if token is allowed
     */
    function isTokenAllowed(address token) external view returns (bool);

    /**
     * @notice Get treasury address for fee collection
     * @return treasury Treasury address
     */
    function treasury() external view returns (address);

    /**
     * @notice Get fee basis points
     * @return feeBps Fee in basis points
     */

    function feeBps() external view returns (uint256);
}
