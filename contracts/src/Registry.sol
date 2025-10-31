// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IRegistry.sol";

/**
 * @title Registry
 * @notice Manages token allowlist and fee configuration for TipJar
 */

contract Registry is IRegistry {
    address internal immutable TREASURY;
    uint256 internal immutable FEE_BPS;
    mapping(address => bool) private allowedTokens;

    /**
     * @notice Constructor
     * @param _treasury Treasury address for fee collection
     * @param _feeBps Fee in basis points (e.g., 100 = 1%)
     * @param _allowedTokens Array of allowed token addresses (address(0) for ETH)
     */

    constructor(address _treasury, uint256 _feeBps, address[] memory _allowedTokens) {
        require(_treasury != address(0), "Registry: zero treasury");
        require(_feeBps <= 10000, "Registry: fee > 100%");
        TREASURY = _treasury;
        FEE_BPS = _feeBps;
        for (uint256 i = 0; i < _allowedTokens.length; i++) {
            allowedTokens[_allowedTokens[i]] = true;
        }
        allowedTokens[address(0)] = true;
    }

    /**
     * @notice Check if a token is allowlisted
     * @param token Token address (address(0) for ETH)
     * @return true if token is allowed
     */

    function isTokenAllowed(address token) external view override returns (bool) {
        return allowedTokens[token];
    }

    /**
     * @notice Get treasury address for fee collection
     * @return Treasury address
     */
    function treasury() external view override returns (address) {
        return TREASURY;
    }

    /**
     * @notice Get fee basis points
     * @return Fee in basis points
     */
    function feeBps() external view override returns (uint256) {
        return FEE_BPS;
    }
}
