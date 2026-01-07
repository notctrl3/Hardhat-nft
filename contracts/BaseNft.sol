// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "./Ownable.sol";

contract BaseNft is ERC721A, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant PRICE_PER_NFT = 0.05 ether;

    string private _baseTokenURI;

    constructor(string memory baseToken) ERC721A("MyHardhatNFT", "MHN") {
        _baseTokenURI = baseToken;
    }

    function mint(uint256 quantity) external payable {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= PRICE_PER_NFT * quantity, "Insufficient payment");

        _safeMint(msg.sender, quantity);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
