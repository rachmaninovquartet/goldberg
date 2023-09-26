//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Goldberg721 is ERC721, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 immutable MAX_SUPPLY;
    string baseURI;

    constructor(uint256 maxSupply, string memory tokenURI) ERC721("GB721", "GB7") {
         MAX_SUPPLY = maxSupply;
         baseURI = tokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mintWithCounter(address to) public onlyOwner returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        require(MAX_SUPPLY >= newItemId, "Goldberg721: not enough supply");
        _mint(to, newItemId);
        _tokenIds.increment();
        return newItemId;
    }
}