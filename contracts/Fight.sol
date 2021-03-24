pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './MyNFT.sol';

contract Fight {

    mapping (uint256 => address payable) public userToken;

    uint fighter;
    uint stake;
    
}