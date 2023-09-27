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

    uint public ethFor20s;
    uint public ethFor721s;
    uint public ethFor1155s;

    enum Phases {ZERO,ONE,TWO}
    Phases _phase;
    uint public _startAt;
    uint public _endAt;
     
    constructor(address GB20addy, address GB721addy, address GB1155addy) {
        GB20 = Goldberg20(GB20addy);
        GB721 = Goldberg721(GB721addy);
        GB1155 = Goldberg1155(GB1155addy);
        _phase = Phases.ZERO;
    }

    function getPhase() public view returns (uint){
      return uint(_phase);
    }

    // give this game phases of 7 days, enum wasn't necessary just used for demonstrative
    // purpose and reading clarity
    function startThePhase(uint newPhase) external onlyOwner {
        require(newPhase > 0 && newPhase <= 2, "GoldbergController: not a phase");
        require(block.timestamp > _endAt, "GoldbergController: too early to start phase");
        _phase = Phases(newPhase);
        _startAt = block.timestamp;
        _endAt = block.timestamp + 7 days;
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

    function _handleSentFunds() private {
        require(_phase == Phases.ONE, "GoldbergController: need to be in phase 1");
        if (msg.value == 1 ether) {
            _make20s(msg.sender, 1);
            ethFor20s += 1;
        } else if (msg.value == 2 ether) {
            _make721s(msg.sender);
            ethFor721s += 2;
        } else if (msg.value == 3 ether) {
            _make1155s(msg.sender, 10, 1, 2);
            ethFor1155s += 3;
        } 
    }

    receive() external payable {
       _handleSentFunds();
    }

    fallback() external payable {
        _handleSentFunds();
    }

    // one opportunity per eth paid to win half the eth
    function gameOf20s() external {
        require(GB20.balanceOf(msg.sender) > 0, "GoldbergController: need to have a balance");
        require(_phase == Phases.TWO, "GoldbergController: need to be in phase 2");
        require(ethFor20s >= 1 ether, "GoldbergController: not enough 20 reward eth left");//allow them to win every eth but 1, so the contract creator can get some
        uint giveaway = ethFor20s/2;
        ethFor20s -= giveaway;
        GB20.burn(msg.sender, 1);
        msg.sender.call{value: giveaway};
    }

    //ruggable
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "GoldbergController: empty balance");
        
        address _owner = owner();
        (bool sent, ) = _owner.call{value: balance}("");
        require(sent, "GoldbergController: failed withdraw");
  }
}