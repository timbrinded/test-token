// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

abstract contract Bannable is OwnableUpgradeable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private banList;

    error AccountBanned();

    function ban(address account) public onlyOwner {
        banList.add(account);
    }

    function unban(address account) public onlyOwner {
        banList.remove(account);
    }

    function getBan(uint256 index) public view onlyOwner returns (address) {
        return banList.at(index);
    }

    function listBanned() public view onlyOwner returns (address[] memory) {
        address[] memory banned = new address[](banList.length());
        for (uint256 i = 0; i < banList.length(); i++) {
            banned[i] = banList.at(i);
        }
        return banned;
    }

    function isBanned(address account) public view returns (bool) {
        return banList.contains(account);
    }

    modifier notBanned(address account) {
        if (isBanned(account)) {
            revert AccountBanned();
        }
        _;
    }
}
