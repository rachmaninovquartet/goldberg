//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Goldberg20.sol";
import "./Goldberg721.sol";
import "./Goldberg1155.sol";

contract GoldbergController is Ownable {

    Goldberg20 public GB20;
    Goldberg721 public GB721;
    Goldberg1155 public GB1155;
     

     constructor(address GB20addy, address GB721addy, address GB1155addy) {
        GB20 = Goldberg20(GB20addy);
        GB721 = Goldberg721(GB721addy);
        GB1155 = Goldberg1155(GB1155addy);
    }

    // can arbitrarily mint erc20s, yes the tokenomics are questionable
    function make20s(address to, uint256 amount) public onlyOwner {
        GB20.mint(to, amount);
    }

    // can arbitrarily mint erc721s
    function make721s(address to, string memory tokenURI) public onlyOwner {
        GB721.mintWithCounter(to, tokenURI);
    }

    // can arbitrarily mint erc1155s
    function make1155s(address to, uint256 currencyAmount, uint256 item1Amount, uint256 item2Amount,
     uint256 item3Amount) public onlyOwner {
        GB1155.mint( to, currencyAmount, item1Amount, item2Amount);
    }
}