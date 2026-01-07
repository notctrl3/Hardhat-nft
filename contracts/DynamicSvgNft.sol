// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "./Ownable.sol";
import "@chainlink/c"

contract DynamicSvgNft is ERC721A, Ownable {
    uint256 private s_lowImageURI;
    uint256 private s_highImageURI;

    mapping(uint256 => uint256) private s_tokenIdToHighValues;
    AggregatorV3Interface internal immutable i_priceFeed;

    constructor(
        address priceFeedAddress,
        string memory lowSvg,
        string memory highSvg
    ) ERC721A("DynamicSvgNft", "DSN") {
        i_priceFeed = AggregatorV3Interface(priceFeedAddress);
        s_lowImageURI = lowSvg;
        s_highImageURI = highSvg;
    }

    function mint(uint256 quantity) external payable {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= PRICE_PER_NFT * quantity, "Insufficient payment");

        _safeMint(msg.sender, quantity);
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }


}
