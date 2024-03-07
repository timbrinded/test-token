// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {stableToken} from "../src/token.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract TokenScript is Script {
    function setUp() public {}

    function run() public {
        address initialOwner = vm.envOr("INITIAL_OWNER", address(msg.sender));
        vm.startBroadcast();

        // Deploy the implementation contract
        stableToken implementation = new stableToken();

        // Prepare the initialization call data
        string memory name = "Test GBP Stablecoin";
        string memory symbol = "bGBP";
        bytes memory initData = abi.encodeWithSelector(
            stableToken.initialize.selector,
            address(initialOwner),
            name,
            symbol
        );

        // Deploy the proxy contract
        new ERC1967Proxy(address(implementation), initData);
        vm.stopBroadcast();
    }
}
