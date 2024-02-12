// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {Bannable} from "./Bannable.sol";

/// @title A Stable Token Contract
/// @dev Extends ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PausableUpgradeable,
/// OwnableUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable, and Bannable
contract stableToken is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PausableUpgradeable,
    OwnableUpgradeable,
    ERC20PermitUpgradeable,
    UUPSUpgradeable,
    Bannable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    /// @dev Prevents the implementation contract from being initialized
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract with a given owner, name, and symbol.
    /// @dev Sets up the initial state of the contract.
    /// @param initialOwner The address of the initial owner.
    /// @param name_ The name of the token.
    /// @param symbol_ The symbol of the token.
    function initialize(address initialOwner, string memory name_, string memory symbol_) public initializer {
        __ERC20_init(name_, symbol_);
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init(name_);
        __UUPSUpgradeable_init();
    }

    /// @notice Pauses all token transfers.
    /// @dev Can only be called by the contract owner.
    function pause() public onlyOwner {
        _pause();
    }

    /// @notice Unpauses all token transfers.
    /// @dev Can only be called by the contract owner.
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @notice Mints tokens to a specified address.
    /// @dev Can only be called by the owner and if the address is not banned.
    /// @param to The address to mint tokens to.
    /// @param amount The amount of tokens to mint.
    function mint(address to, uint256 amount) public onlyOwner notBanned(to) {
        _mint(to, amount);
    }

    /// @notice Allows the owner to rescue ERC20 tokens sent to this contract.
    /// @dev Only callable by the owner.
    /// @param tokenContract The contract address of the ERC20 token.
    /// @param to The address to send the rescued tokens to.
    /// @param amount The amount of tokens to rescue.
    function rescueERC20(IERC20 tokenContract, address to, uint256 amount) external onlyOwner {
        tokenContract.transfer(to, amount);
    }

    // ------------------------
    // FUNCTION OVERRIDES
    // ------------------------

    /// @notice Transfer tokens to a specified address.
    /// @dev Override with additional notBanned checks.
    /// @param to The address to transfer tokens to.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the operation was successful.
    function transfer(address to, uint256 value) public override notBanned(msg.sender) notBanned(to) returns (bool) {
        return super.transfer(to, value);
    }

    /// @notice Transfers tokens from one address to another.
    /// @dev Overrides the base transferFrom function with additional notBanned checks.
    /// @param from The address to transfer tokens from.
    /// @param to The address to transfer tokens to.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the operation was successful.
    function transferFrom(address from, address to, uint256 value)
        public
        override
        notBanned(msg.sender)
        notBanned(from)
        notBanned(to)
        returns (bool)
    {
        return super.transferFrom(from, to, value);
    }

    /// @notice Approves another address to spend a specified amount of tokens on behalf of msg.sender.
    /// @dev Overrides the base approve function with additional notBanned checks.
    /// @param spender The address which is approved to spend the tokens.
    /// @param value The amount of tokens spender is approved to use.
    /// @return A boolean indicating whether the operation was successful.
    function approve(address spender, uint256 value)
        public
        override
        notBanned(msg.sender)
        notBanned(spender)
        returns (bool)
    {
        return super.approve(spender, value);
    }

    // ------------------------
    // ADMIN FUNCTIONS
    // ------------------------

    /// @dev Authorizes an upgrade to a new implementation.
    /// @param newImplementation The address of the new contract implementation.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    /// @dev Internal function to handle token update logic.
    /// @param from The address from which tokens are transferred.
    /// @param to The address to which tokens are transferred.
    /// @param value The amount of tokens being transferred.
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20PausableUpgradeable)
    {
        super._update(from, to, value);
    }
}
