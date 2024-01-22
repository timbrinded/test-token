// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {stableToken} from "../src/token.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract TokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the implementation contract
        stableToken implementation = new stableToken();

        // Prepare the initialization call data
        string memory name = "MyStableToken";
        string memory symbol = "MST";
        bytes memory initData = abi.encodeWithSelector(
            stableToken.initialize.selector,
            msg.sender, // initialOwner
            name,
            symbol
        );

        // Deploy the proxy contract
        new ERC1967Proxy(address(implementation), initData);

        // TODO: transfer ownership to multisig
        // ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        // address multisig = 0x1234...
        // proxy.transferOwnership(multisig);
        vm.stopBroadcast();
    }
}
