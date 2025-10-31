// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/Registry.sol";
import "../src/JarFactory.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying contracts to Base Sepolia Testnet");
        console.log("Deployer address:", deployer);
        console.log("Account balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

       
        address treasury = deployer; 
        uint256 feeBps = 500; // 5%
        
        address[] memory allowedTokens = new address[](1);
        allowedTokens[0] = address(0); // ETH
        
        Registry registry = new Registry(treasury, feeBps, allowedTokens);
        console.log("Registry deployed at:", address(registry));

       
        JarFactory factory = new JarFactory(address(registry));
        console.log("JarFactory deployed at:", address(factory));

        vm.stopBroadcast();

        console.log("\n=== Deployment Summary ===");
        console.log("Registry:", address(registry));
        console.log("JarFactory:", address(factory));
        console.log("Treasury:", treasury);
        console.log("Fee BPS:", feeBps);
    }
}