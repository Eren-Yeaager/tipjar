// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/JarFactory.sol";
import "../src/TipJar.sol";

contract TipJarTestScript is Script {
    // Update these with your deployed addresses
    address constant JAR_FACTORY = 0xd360aF8751231b8df92238672BFe128A0fD3e87B;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Testing TipJar on Base Sepolia");
        console.log("Deployer address:", deployer);
        console.log("Account balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        JarFactory factory = JarFactory(JAR_FACTORY);

        // Step 1: Create a test jar
        console.log("\n=== Creating TipJar ===");
        
        string memory handle = "test-jar-1";
        
        // Setup beneficiaries (you can change these)
        address[] memory beneficiaries = new address[](2);
        beneficiaries[0] = deployer; // You get 47.5%
        beneficiaries[1] = address(0x2222222222222222222222222222222222222222); // Test beneficiary gets 47.5%
        
        uint256[] memory bps = new uint256[](2);
        bps[0] = 4750; // 47.5%
        bps[1] = 4750; // 47.5%
        // Total: 4750 + 4750 + 500 (fee) = 10000 ✓
        
        uint256 feeBps = 500; // 5% (from Registry)
        
        // Create the jar
        address jarAddress = factory.createJar(handle, beneficiaries, bps, feeBps);
        TipJar jar = TipJar(payable(jarAddress));
        
        console.log("TipJar created at:", jarAddress);
        console.log("Owner:", jar.OWNER());
        console.log("Number of splits:", jar.getSplitCount());

        // Step 2: Send a test tip
        console.log("\n=== Sending Test Tip ===");
        uint256 tipAmount = 0.01 ether;
        
        // Check beneficiary balances before
        uint256 beneficiary1BalanceBefore = beneficiaries[0].balance;
        uint256 beneficiary2BalanceBefore = beneficiaries[1].balance;
        
        jar.tipETH{value: tipAmount}("Test tip from deployment script!");
        
        console.log("Tip sent:", tipAmount);
        console.log("Beneficiary 1 balance before:", beneficiary1BalanceBefore);
        console.log("Beneficiary 1 balance after:", beneficiaries[0].balance);
        console.log("Beneficiary 2 balance before:", beneficiary2BalanceBefore);
        console.log("Beneficiary 2 balance after:", beneficiaries[1].balance);
        
        // Calculate expected amounts
        uint256 beneficiary1Share = (tipAmount * 4750) / 10000;
        uint256 beneficiary2Share = (tipAmount * 4750) / 10000;
        uint256 treasuryShare = (tipAmount * 500) / 10000;
        
        console.log("\n=== Split Breakdown ===");
        console.log("Beneficiary 1 should receive:", beneficiary1Share);
        console.log("Beneficiary 2 should receive:", beneficiary2Share);
        console.log("Treasury should receive:", treasuryShare);
        console.log("Total:", beneficiary1Share + beneficiary2Share + treasuryShare);

        vm.stopBroadcast();

        console.log("\n=== Test Complete ===");
        console.log("TipJar Address:", jarAddress);
        console.log("View on explorer:", 
            string.concat("https://sepolia.basescan.org/address/", vm.toString(jarAddress)));
    }
}