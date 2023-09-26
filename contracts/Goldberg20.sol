//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Goldberg20 is ERC20, Ownable {

     uint256 immutable MAX_SUPPLY;
     
     constructor(uint256 maxSupply) ERC20("GB20", "GB2") {
          MAX_SUPPLY = maxSupply;
     }

     function mint(address account, uint256 amount) public onlyOwner {
          require(MAX_SUPPLY >= (totalSupply() + amount), "Goldberg20: not enough supply");
          _mint(account, amount);
     }
}