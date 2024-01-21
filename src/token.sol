// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {Bannable} from "./Bannable.sol";


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
    // using EnumerableSet for EnumerableSet.AddressSet;

    // EnumerableSet.AddressSet private banList;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, string memory name_, string memory symbol_) public initializer {
        __ERC20_init(name_, symbol_);
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init(name_);
        __UUPSUpgradeable_init();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner notBanned(to) {
        _mint(to, amount);
    }

    // TODO: Add freeze function

    // TODO: Add unfreeze function

    // TODO: Add forceBurn function

    // TODO: Add Return token function

    
    // FUNCTION OVERRIDES

    function transfer(address to,uint256 value) public override notBanned(msg.sender) notBanned(to) returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from,address to,uint256 value)
        public
        override
        notBanned(msg.sender)
        notBanned(from)
        notBanned(to)
        returns (bool)
    {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender,uint256 value) public override notBanned(msg.sender) notBanned(spender) returns (bool) {
        return super.approve(spender, value);
    }

    // function increaseAllowance(address spender,uint256 addedValue)
    //     public
    //     override
    //     notBanned(msg.sender)
    //     notBanned(spender)
    //     returns (bool)
    // {
    //     return super.increaseAllowance(spender, addedValue);
    // }

    // function decreaseAllowance(address spender,uint256 subtractedValue)
    //     public
    //     override
    //     notBanned(msg.sender)
    //     notBanned(spender)
    //     returns (bool)
    // {
    //     return super.decreaseAllowance(spender, subtractedValue);
    // }

    // function _beforeTokenTransfer(address from,address to,uint256 amount)
    //     internal
    //     override(ERC20Upgradeable, ERC20PausableUpgradeable)
    //     notBanned(from)
    //     notBanned(to)
    // {
    //     super._beforeTokenTransfer(from, to, amount);
    // }

    // ADMIN FUNCTIONS

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20PausableUpgradeable)
    {
        super._update(from, to, value);
    }
}
