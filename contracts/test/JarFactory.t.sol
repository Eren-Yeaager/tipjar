// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/JarFactory.sol";
import "../src/Registry.sol";
import "../src/TipJar.sol";

contract JarFactoryTest is Test {
    Registry registry;
    JarFactory factory;
    address treasury = address(0x1);

    function setUp() public {
        address[] memory allowedTokens = new address[](1);
        allowedTokens[0] = address(0);
        registry = new Registry(treasury, 500, allowedTokens);
        factory = new JarFactory(address(registry));
    }

    function test_CreateJar() public {
        address[] memory beneficiaries = new address[](1);
        beneficiaries[0] = address(0x2);
        
        uint256[] memory bps = new uint256[](1);
        bps[0] = 9500; // 95%
        
        address jar = factory.createJar("test-jar", beneficiaries, bps, 500);
        
        assertTrue(jar != address(0));
        TipJar tipJar = TipJar(payable(jar));
        assertEq(tipJar.OWNER(), address(this));
    }

    function test_RevertEmptyHandle() public {
        address[] memory beneficiaries = new address[](1);
        uint256[] memory bps = new uint256[](1);
        
        vm.expectRevert("JarFactory: empty handle");
        factory.createJar("", beneficiaries, bps, 500);
    }
}