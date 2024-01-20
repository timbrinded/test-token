// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {stableToken} from "../src/token.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract TokenTest is Test {
    stableToken public token;
    bytes4 ERROR_PAUSED = bytes4(keccak256("EnforcedPause()"));

    function setUp() public {
        // Deploy the implementation contract
        stableToken implementation = new stableToken();

        // Prepare the initialization call data
        string memory name = "MyStableToken";
        string memory symbol = "MST";
        bytes memory initData = abi.encodeWithSelector(
            stableToken.initialize.selector,
            address(this), // initialOwner
            name,
            symbol
        );

        // Deploy the proxy
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        // Cast the proxy to the Benoit interface
        token = stableToken(address(proxy));
    }

    function test_Name() public {
        assertEq(token.name(), "MyStableToken");
    }

    function test_Symbol() public {
        assertEq(token.symbol(), "MST");
    }

    function test_initialSupply() public {
        assertEq(token.totalSupply(), 0);
    }

    function test_mintToken() public {
        uint256 amount = 1000 * 10 ** 18;

        token.mint(address(this), amount);
        assertEq(token.balanceOf(address(this)), amount);
        assertEq(token.totalSupply(), amount);
    }

    function test_pause() public {
        token.pause();
        assertTrue(token.paused());
    }

    function test_paused() public {
        token.pause();
        uint256 amount = 1000 * 10 ** 18;

        vm.expectRevert(ERROR_PAUSED);
        token.mint(address(this), amount);
    }

    // test to freeze assets
}
