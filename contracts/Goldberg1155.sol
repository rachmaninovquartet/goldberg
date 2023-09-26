//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Goldberg1155 is ERC1155, Ownable {

    struct Totals {
        uint256 totalCurrency;
        uint256 totalItem1;
        uint256 totalItem2;
    }

    uint256 public constant IN_GAME_CURRENCY = 0;
    uint256 public constant GAME_ITEM_1 = 1;
    uint256 public constant GAME_ITEM_2 = 2;

    uint256 immutable IN_GAME_CURRENCY_MAX;
    uint256 immutable GAME_ITEM_1_MAX;
    uint256 immutable GAME_ITEM_2_MAX;

    using Counters for Counters.Counter;
    Counters.Counter private _gameItem1;
    Counters.Counter private _gameItem2;

    uint256 private _totalCurrencySupply;

    constructor(string memory tokenURI, uint256 currencyAmountMax, uint256 item1AmountMax, uint256 item2AmountMax)
    ERC1155(tokenURI) {
        IN_GAME_CURRENCY_MAX = currencyAmountMax;
        GAME_ITEM_1_MAX = item1AmountMax;
        GAME_ITEM_2_MAX = item2AmountMax;
    }

    function totalSupply() public view virtual returns (Totals memory) {
        return Totals(_totalCurrencySupply, _gameItem1.current(), _gameItem2.current());
    }

    function mint(address to, uint256 currencyAmount, uint256 item1Amount,
     uint256 item2Amount) public onlyOwner {

        require(IN_GAME_CURRENCY_MAX >= (_totalCurrencySupply + currencyAmount), "Goldberg1155: not enough currency");
        require(GAME_ITEM_1_MAX > _gameItem1.current(), "Goldberg721: not enough item1");
        require(GAME_ITEM_2_MAX > _gameItem2.current(), "Goldberg721: not enough item2");
        
        _mint(to, IN_GAME_CURRENCY, currencyAmount, "");
        _mint(to, GAME_ITEM_1, item1Amount, "");
        _mint(to, GAME_ITEM_2, item2Amount, "");
        
        _totalCurrencySupply += currencyAmount;
        _gameItem1.increment();
        _gameItem2.increment();
    }
}