//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Goldberg20.sol";
import "./Goldberg721.sol";
import "./Goldberg1155.sol";

contract GoldbergController is Ownable {

    event Make20(address indexed to, uint256 amount);
    event Make721(address indexed to);
    event Make1155(address indexed to, uint256 currencyAmount, uint256 item1Amount,
     uint256 item2Amount);

    Goldberg20 public GB20;
    Goldberg721 public GB721;
    Goldberg1155 public GB1155;
     

     constructor(address GB20addy, address GB721addy, address GB1155addy) {
        GB20 = Goldberg20(GB20addy);
        GB721 = Goldberg721(GB721addy);
        GB1155 = Goldberg1155(GB1155addy);
    }

    function _make20s(address to, uint256 amount) private onlyOwner {
        GB20.mint(to, amount);
        emit Make20(to, amount);
    }

    function _make721s(address to) private onlyOwner {
        GB721.mintWithCounter(to);
        emit Make721(to);
    }

    function _make1155s(address to, uint256 currencyAmount, uint256 item1Amount,
     uint256 item2Amount) private onlyOwner {
        GB1155.mint( to, currencyAmount, item1Amount, item2Amount);
        emit Make1155(to, currencyAmount, item1Amount, item2Amount);
    }

    receive() external payable {
        if (msg.value == 1 ether) {
            _make20s(msg.sender, 100);
        } else if (msg.value == 2 ether) {
            _make721s(msg.sender);
        } else if (msg.value == 3 ether) {
            _make1155s(msg.sender, 10, 1, 2);
        } 
    }
}