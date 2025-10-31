// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title ITipJar
 * @notice Interface for TipJar contract that handles ETH and ERC20 tips
 */
interface ITipJar {
    /**
     * @notice Receive ETH tip with optional memo
     * @param memo Optional message from tipper
     */
    function tipETH(string memory memo) external payable;

    /**
     * @notice Receive ERC20 tip with optional memo
     * @param token ERC20 token address
     * @param amount Amount to tip (in token's smallest unit)
     * @param memo Optional message from tipper
     */

    function tipERC20(address token, uint256 amount, string memory memo) external;

    /**
     * @notice Emitted when a tip is received
     * @param from Address that sent the tip
     * @param token Token address (address(0) for ETH)
     * @param amount Amount tipped
     */

    event TipReceived(address indexed from, address indexed token, uint256 amount);
}
