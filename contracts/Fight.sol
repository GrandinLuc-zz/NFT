pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './MyNFT.sol';

contract Fight {

    mapping (uint256 => address payable) public userToken;

    uint fighter;
    uint stake;

    struct Fight {
        uint256 fighter_1;
        uint256 fighter_2;
        uint256 stake;
    }

    MyNFT mynft;

    constructor() {
        mynft = MyNFT(msg.sender);
    }
    
    function proposeToFight(uint256 _tokenID, uint256 _stake) public {
        fighter = _tokenId;
        stake = _stake;

        userToken[_tokenID] = msg.sender;
    }

    function acceptFight(uint256 _tokenID) public {
        require(userToken[fighter] != msg.sender, "You can't fight yourself");

        Fight memory newFight = Fight(fighter, _tokenID, stake);

        userToken[_tokenID] = msg.sender;

        startFight(newFight);
    }

    function startFight(Fight memory fight) internal returns(uint256) {

        uint256 stats1 = MyNFT.characts[fight.fighter_1].aggresivity + MyNFT.characts[fight.fighter_1].tenacity + MyNFT.characts[fight.fighter_1].cunning;
        uint256 stats2 = MyNFT.characts[fight.fighter_2].aggresivity + MyNFT.characts[fight.fighter_2].tenacity + MyNFT.characts[fight.fighter_2].cunning;

        uint256 winner;
        uint256 looser;
        

        if(stats1 > stats2) {
            winner = fight.fighter_1;
            looser = fight.fighter_2;
        }
        else if(stats1 > stats2){
            winner = fight.fighter_2;
            looser = fight.fighter_1;
        }
        else if(MyNFT.random(2) == 0){
            winner = fight.fighter_2;
            looser = fight.fighter_1;
        }

        MyNFT.deadAnimal(looser);

        return winner;
    }
}