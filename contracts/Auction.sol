pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './MyNFT.sol';

contract Auction {

    struct AuctionHouse {
        address payable seller;
        address payable bidder;
        uint256 startingPrice;
        uint currentPrice;
        uint256 limitDate;
    }

    uint256 public nbAuction;
    mapping (uint256 => AuctionHouse) public auctions;
    mapping (uint256 => bool) public activeAuctions;

    MyNFT mynft;

    constructor() {
        mynft = MyNFT(msg.sender);
    }

    modifier activeAuction(uint256 _tokenId) {
        require(activeAuctions[_tokenId], "The auction isn't active");
        _;
    }

    function createAuction(uint256 tokenId_, uint256 startingPrice_, uint256 immediatBuyingPrice_ ) public activeAuction(tokenId_) returns(bool) {
        require(myNFT.exist(tokenId_), "This tokenId doesn't belong to this address");
        require(myNFT.ownerOf(tokenId_) == msg.sender, "The token doesn't belong to you");
        activeAuctions[tokenId_] = true;
        AuctionStruct memory auction = AuctionHouse(msg.sender, msg.sender, startingPrice_, startingPrice_, block.timestamp + (2 * 1 days) );
        auctions[tokenId_] = auction;
        nbAuction += 1;
        return true;
    }

    function bidOnAuction(address payable from, uint256 _tokenId) public payable activeAuction(_tokenId) returns(bool) {
        if(auctions[_tokenId].currentPrice > msg.value){
            return false;
        }
        else{
            auctions[_tokenId].bidder.transfer(auctions[_tokenId].currentPrice);
            auctions[_tokenId].bidder = msg.sender;
            auctions[_tokenId].currentPrice = msg.value;
            return true;
        }
    }

    function claimAuction(uint256 tokenId) public returns(bool) {
        require(msg.sender == auctions[tokenId].bidder, 'You must be the bidder in order to claim your auction');
        require(auctions[tokenId].deadline < block.timestamp, "The auction isn't finished yet");
        
        
        myNFT.safeTransferFrom(auctions[tokenId].seller, auctions[tokenId].bidder, tokenId);
        auctions[tokenId].seller.transfer(msg.value);
        activeAuctions[tokenId] = false;

        return true;
    }

    // Send ETH to the contract address
    receive() external payable {

    }


}