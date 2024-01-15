// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {bGBP} from "../src/token.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract TokenTest is Test {
    bGBP public token;

    function setUp() public {
        // Deploy the implementation contract
        bGBP implementation = new bGBP();

         // Prepare the initialization call data
        bytes memory initData = abi.encodeWithSelector(bGBP.initialize.selector, address(this));

        // Deploy the proxy
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        // Cast the proxy to the Benoit interface
        token = bGBP(address(proxy));
    }

    function test_Name() public {
        assertEq( token.name(), "bGBP" );
    }

    function test_Symbol() public {
        assertEq( token.symbol(), "bGBP" );
    }

    function test_initialSupply() public {
        assertEq( token.totalSupply(), 1000 * 10 ** 18 );
    }

    function test_mintToken() public {
        token.mint(address(this), 1000 * 10 ** 18);
        assertEq( token.balanceOf(address(this)), 2000 * 10 ** 18 );
    }

   // test to freeze assets
}
