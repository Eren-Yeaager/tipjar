// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/ITipJar.sol";
import "./interfaces/IRegistry.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title TipJar
 * @notice Receives tips and splits them among beneficiaries and treasury
 */
contract TipJar is ITipJar, ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public immutable OWNER;
    address public immutable REGISTRY;
    uint256 public immutable FEE_BPS;

    struct Split {
        address beneficiary;
        uint256 bps;
    }
    Split[] public splits;

    /**
     * @notice Constructor
     * @param _owner Owner of the jar
     * @param _registry Registry contract address
     * @param _beneficiaries Array of beneficiary addresses
     * @param _bps Array of basis points for each beneficiary
     * @param _feeBps Fee in basis points
     */

    constructor(
        address _owner,
        address _registry,
        address[] memory _beneficiaries,
        uint256[] memory _bps,
        uint256 _feeBps
    ) {
        require(_owner != address(0), "TipJar: zero owner");
        require(_registry != address(0), "TipJar: zero registry");
        require(_beneficiaries.length == _bps.length, "TipJar:length mismatch");
        require(_beneficiaries.length <= 5, "TipJar: max 5 beneficiaries");
        require(_feeBps <= 10000, "TipJar: fee > 100%");

        OWNER = _owner;
        REGISTRY = _registry;
        FEE_BPS = _feeBps;

        uint256 totalBps = _feeBps;
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            require(_beneficiaries[i] != address(0), "TipJar: zero beneficiary");
            require(_bps[i] > 0, "TipJar: zero bps");
            splits.push(Split({ beneficiary: _beneficiaries[i], bps: _bps[i] }));
            totalBps += _bps[i];
        }
        require(totalBps == 10000, "TipJar: bps != 100%");
    }

    /**
     * @notice Receive ETH tip with optional memo
     */
    function tipETH(
        string memory /* memo */
    )
        external
        payable
        override
        nonReentrant
    {
        require(msg.value > 0, "TipJar: zero amount");
        require(IRegistry(REGISTRY).isTokenAllowed(address(0)), "TipJar: ETH not allowed");

        _splitAndPayETH(msg.value);
        emit TipReceived(msg.sender, address(0), msg.value);
    }

    /**
     * @notice Receive ERC20 tip with optional memo
     * @param token ERC20 token address
     * @param amount Amount to tip
     */
    function tipERC20(
        address token,
        uint256 amount,
        string memory /* memo */
    )
        external
        override
        nonReentrant
    {
        require(token != address(0), "TipJar: zero token");
        require(amount > 0, "TipJar: zero amount");
        require(IRegistry(REGISTRY).isTokenAllowed(token), "TipJar: token not allowed");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        _splitAndPayERC20(token, amount);

        emit TipReceived(msg.sender, token, amount);
    }

    /**
     * @notice Internal function to split and pay ETH
     * @param amount Total amount to split
     */
    function _splitAndPayETH(uint256 amount) internal {
        uint256 totalDistributed = 0;

        // Pay beneficiaries
        for (uint256 i = 0; i < splits.length; i++) {
            uint256 share = (amount * splits[i].bps) / 10000;
            if (share > 0) {
                (bool success,) = splits[i].beneficiary.call{ value: share }("");
                require(success, "TipJar: ETH transfer failed");
                totalDistributed += share;
            }
        }
        // Pay treasury (including remainder from rounding)
        uint256 treasuryShare = (amount * FEE_BPS) / 10000;
        uint256 remainder = amount - totalDistributed - treasuryShare;
        uint256 treasuryTotal = treasuryShare + remainder;

        if (treasuryTotal > 0) {
            (bool success,) = IRegistry(REGISTRY).treasury().call{ value: treasuryTotal }("");
            require(success, "TipJar: treasury transfer failed");
        }
    }

    /**
     * @notice Internal function to split and pay ERC20
     * @param token ERC20 token address
     * @param amount Total amount to split
     */
    function _splitAndPayERC20(address token, uint256 amount) internal {
        uint256 totalDistributed = 0;

        // Pay beneficiaries
        for (uint256 i = 0; i < splits.length; i++) {
            uint256 share = (amount * splits[i].bps) / 10000;
            if (share > 0) {
                IERC20(token).safeTransfer(splits[i].beneficiary, share);
                totalDistributed += share;
            }
        }
        // Pay treasury (including remainder from rounding)
        uint256 treasuryShare = (amount * FEE_BPS) / 10000;
        uint256 remainder = amount - totalDistributed - treasuryShare;
        uint256 treasuryTotal = treasuryShare + remainder;

        if (treasuryTotal > 0) {
            IERC20(token).safeTransfer(IRegistry(REGISTRY).treasury(), treasuryTotal);
        }
    }

    /**
     * @notice Get number of splits
     * @return Number of beneficiary splits
     */
    function getSplitCount() external view returns (uint256) {
        return splits.length;
    }
}
