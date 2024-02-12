// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/// @title Bannable
/// @dev Contract module which allows an owner to ban or unban addresses.
/// Utilizes OpenZeppelin's OwnableUpgradeable for ownership management.
abstract contract Bannable is OwnableUpgradeable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private banList;

    error AccountBanned();

    /// @notice Bans a specified account.
    /// @dev Can only be called by the contract owner.
    /// @param account The address to be banned.
    function ban(address account) public onlyOwner {
        banList.add(account);
    }

    /// @notice Unbans a specified account.
    /// @dev Can only be called by the contract owner.
    /// @param account The address to be unbanned.
    function unban(address account) public onlyOwner {
        banList.remove(account);
    }

    /// @notice Retrieves the banned address at a specific index.
    /// @dev Can only be called by the contract owner.
    /// @param index The index of the banned address in the list.
    /// @return The address of the banned account.
    function getBan(uint256 index) public view onlyOwner returns (address) {
        return banList.at(index);
    }

    /// @notice Lists all banned addresses.
    /// @dev Can only be called by the contract owner.
    /// @return An array of banned addresses.
    function listBanned() public view onlyOwner returns (address[] memory) {
        address[] memory banned = new address[](banList.length());
        for (uint256 i = 0; i < banList.length(); i++) {
            banned[i] = banList.at(i);
        }
        return banned;
    }

    /// @notice Checks if an account is banned.
    /// @param account The address to check.
    /// @return True if the account is banned, false otherwise.
    function isBanned(address account) public view returns (bool) {
        return banList.contains(account);
    }

    /// @notice Modifier that reverts if the account is banned.
    /// @param account The address to check for a ban.
    modifier notBanned(address account) {
        if (isBanned(account)) {
            revert AccountBanned();
        }
        _;
    }
}
