// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/TipJar.sol";
import "../src/Registry.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MOCK") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract TipJarTest is Test {
    Registry registry;
    TipJar tipJar;
    address owner = address(0x1);
    address beneficiary1 = address(0x2);
    address beneficiary2 = address(0x3);
    address treasury = address(0x4);
    MockERC20 token;
    uint256 feeBps = 500; 

    function setUp() public {
       
    token = new MockERC20();
    address[] memory allowedTokens = new address[](2);
    allowedTokens[0] = address(0); 
    allowedTokens[1] = address(token); 
    
    registry = new Registry(treasury, feeBps, allowedTokens);
    
    address[] memory beneficiaries = new address[](2);
    beneficiaries[0] = beneficiary1;
    beneficiaries[1] = beneficiary2;
    
    uint256[] memory bps = new uint256[](2);
    bps[0] = 4750; // 47.5%
    bps[1] = 4750; // 47.5%

    tipJar = new TipJar(owner, address(registry), beneficiaries, bps, feeBps);
    }

  function test_ETH_Tip_SplitsCorrectly() public {
    uint256 tipAmount = 100 ether;
    
    tipJar.tipETH{value: tipAmount}("");
    assertEq(beneficiary1.balance, 47.5 ether);
    assertEq(beneficiary2.balance, 47.5 ether);
    assertEq(treasury.balance, 5 ether);
}
function test_ERC20_Tip_SplitsCorrectly() public {
   
    uint256 tipAmount = 100 * 10**18; 
    
    
    token.approve(address(tipJar), tipAmount);
    
   
    tipJar.tipERC20(address(token), tipAmount, "");
    
    
    assertEq(token.balanceOf(beneficiary1), 47.5 * 10**18);
    assertEq(token.balanceOf(beneficiary2), 47.5 * 10**18);
    assertEq(token.balanceOf(treasury), 5 * 10**18);
    assertEq(token.balanceOf(address(tipJar)), 0);
}

function test_RevertERC20_NotAllowed() public {
    
    MockERC20 unallowedToken = new MockERC20();
    uint256 tipAmount = 100 * 10**18;
    
    unallowedToken.approve(address(tipJar), tipAmount);
    
    vm.expectRevert("TipJar: token not allowed");
    tipJar.tipERC20(address(unallowedToken), tipAmount, "");
}

function test_RevertZeroAmount() public {
    vm.expectRevert("TipJar: zero amount");
    tipJar.tipETH{value: 0}("");
}
}