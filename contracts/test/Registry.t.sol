// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/Registry.sol";

contract RegistryTest is Test {
    Registry registry;
    address treasury = address(0x1);
    uint256 feeBps = 500;
    address[] allowedTokens;

    function setUp() public {
        allowedTokens.push(address(0)); // ETH
        allowedTokens.push(address(0x2)); // Mock USDC
        registry = new Registry(treasury, feeBps, allowedTokens);
    }

    function test_Constructor() public {
        assertEq(registry.treasury(), treasury);
        assertEq(registry.feeBps(), feeBps);
        assertTrue(registry.isTokenAllowed(address(0))); // ETH allowed
        assertTrue(registry.isTokenAllowed(address(0x2))); // USDC allowed
    }

    function test_ETH_AlwaysAllowed() public {
        assertTrue(registry.isTokenAllowed(address(0)));
    }

    function test_RevertZeroTreasury() public {
        vm.expectRevert("Registry: zero treasury");
        new Registry(address(0), feeBps, allowedTokens);
    }

    function test_RevertFeeOver100() public {
        vm.expectRevert("Registry: fee > 100%");
        new Registry(treasury, 10001, allowedTokens);
    }
}
