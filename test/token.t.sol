// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "forge-std/Test.sol";
import {stableToken} from "../src/token.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract TokenTest is Test {
    stableToken public token;
    bytes4 ERROR_PAUSED = bytes4(keccak256("EnforcedPause()"));
    bytes4 ACCOUNT_BANNED = bytes4(keccak256("AccountBanned()"));

    address testUser1 = address(uint160(uint256(keccak256(abi.encodePacked("testUser1")))));
    address testUser2 = address(uint160(uint256(keccak256(abi.encodePacked("testUser2")))));
    address testUser3 = address(uint160(uint256(keccak256(abi.encodePacked("testUser3")))));

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

    function test_ban() public {
        token.ban(testUser1);
        assertTrue(token.isBanned(testUser1));
    }

    function test_unban() public {
        token.ban(testUser1);
        token.unban(testUser1);
        assertFalse(token.isBanned(testUser1));
    }

    function test_listBanned() public {
        token.ban(testUser1);
        token.ban(testUser2);
        token.ban(testUser3);

        address[] memory banned = token.listBanned();
        assertEq(banned.length, 3);
        assertEq(banned[0], testUser1);
        assertEq(banned[1], testUser2);
        assertEq(banned[2], testUser3);
    }

    function test_bannedTransfer() public {
        token.ban(testUser1);
        uint256 amount = 1000 * 10 ** 18;
        token.mint(address(this), amount);
        vm.expectRevert(ACCOUNT_BANNED);
        token.transfer(testUser1, amount);
    }

    function test_unbannedTransfer() public {
        token.ban(testUser1);
        token.unban(testUser1);
        uint256 amount = 1000 * 10 ** 18;

        token.mint(address(this), amount);
        token.transfer(testUser1, amount);
    }

    function test_bannedMint() public {
        token.ban(testUser1);
        vm.expectRevert(ACCOUNT_BANNED);
        token.mint(testUser1, 1000 * 10 ** 18);
    }

    // test to freeze assets
}
