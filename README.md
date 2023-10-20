# goldberg
This is a project that has no purpose other than to play with solidity.

There are 3 phases:

Phase 0:
    - the contract is in active

Phase 1:
    - When people send ETH to the GoldbergController, it mints erc20, 721 or 1155 tokens based on the amount the sent

Phase2:
    - Each token type has a "game" associated with it.
        - ERC20s simply divide and distribute the ETH from phase 1 ERC20 mints by 2 each time someone calls the "game" function and has a token
        - ERC721s these award the whole pot minus 1 ETH to the first user to send a signature with an embedded "secret" message
        - ERC1155s currently thinking an auction


TODOS:
- upgradable (diamond)
- rarity of items could be fun to play with, maybe have an upgrade that's allowed after the inital 3 phases and this allows for people who didn't win to play a new rarity based game.
- tests!

