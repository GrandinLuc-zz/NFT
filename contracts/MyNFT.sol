pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/math/Math.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

contract MyNFT is ERC721 {

    using SafeMath for uint;
    using Math for uint;

    uint256 private _nbToken;

    mapping(address => bool) public registeredBreeders;
    mapping(uint256 => Characteristics) public characts;

    constructor() ERC721("Animal collector", "AC") {
        _nbToken = 0;
    }

    struct Characteristics {
        uint256 height;
        uint256 mass;
        uint256[3] color;
        uint256 aggresivity;
        uint256 tenacity;
        uint256 cunning;

    }

    function isRegistered(address _recipient) public returns (bool) {
        if(registered[_recipient] == true){
            return true;
        }
        else{
            return false;
        }
    }

    function exist(uint256 tokenId) public returns(bool) {
        return _exists(tokenId);
    }

    function registerBreeder(address _recipient) public onlyOwner {
        registered[_recipient] = true;
        return true;
    }

    function random(uint256 modulo) public returns (uint256) {
      return SafeMath.mod(uint(keccak256(abi.encodePacked(blockhash(block.number - 1),block.timestamp))), modulo);
    }

    function declareAnimal() public returns (bool) {
        require(isRegistered(msg.sender), "Not authorized to declare an animal");
        uint256 height = random(50); 
        uint256 mass = SafeMath.add(15, random(5));
        uint256[3] color = [random(256),random(256),random(256)];
        uint256 aggresivity = random(100);
        uint256 tenacity = random(100);
        uint256 cunning = random(100);
        Characteristics memory chars = Characteristics(height, mass, color, aggresivity, tenacity, cunning);
        characts[_nbToken] = chars;
        _nbToken += 1;
        return true;
    }

    function deadAnimal(uint _tokenID) public returns (bool) {
        require(isRegistered(msg.sender), "Not authorized to kill an animal");
        _burn(_tokenID); 
        return true;
    }

    function breedAnimal(uint _tokenID1, uint _tokenID2) public returns (bool) {
        require(isRegistered(msg.sender), "Not authorized to breed animals");
        require(ownerOf(_tokenID1) == ownerOf(_tokenID2), "You need to own both animals if you want them to breed");
        uint256 height = Math.average(characts[_tokenID1].height, characts[_tokenID2].height);
        uint256 mass = Math.average(characts[_tokenID1].mass, characts[_tokenID2].mass);
        uint256[3] color = [
            Math.average(characts[_tokenID1].color[0], characts[_tokenID2].color[0]),
            Math.average(characts[_tokenID1].color[1], characts[_tokenID2].color[1]),
            Math.average(characts[_tokenID1].color[2], characts[_tokenID2].color[2])
            ];
        uint256 aggresivity = Math.average(characts[_tokenID1].aggresivity, characts[_tokenID2].aggresivity);
        uint256 tenacity = Math.average(characts[_tokenID1].tenacity, characts[_tokenID2].tenacity);
        uint256 cunning = Math.average(characts[_tokenID1].cunning, characts[_tokenID2].cunning);
        Characteristics memory chars = Characteristics(height, mass, color, aggresivity, tenacity, cunning);
        characts[_nbToken] = chars;
        _nbToken += 1;
        return true;

    }
}


