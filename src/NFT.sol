// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    uint256 private idIncrement;
    uint8 constant private LIMIT_DAY=31;
    mapping (uint256 => string[LIMIT_DAY]) private histories;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        idIncrement = 0;
    }
    function mint(string memory _tokenURI) public returns (uint256) {
        // tokenId
        idIncrement++;

        _safeMint(msg.sender, idIncrement);
        _setTokenURI(idIncrement, _tokenURI);

        // starting history of the NFT
        histories[idIncrement][0]=_tokenURI;

        return idIncrement;
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getBaseURI() public view returns (string memory) {
        return _baseURI();
    }
    
    /**
    * @notice Updates the metadata of a given NFT and records the update in its history.
    * @dev This function updates the token's URI and shifts the history of the token's URIs to record the latest update.
    * @param _tokenId The unique identifier of the NFT to update.
    * @param _tokenURI The new URI for the NFT's metadata.
    */
    function updateNFT(uint256 _tokenId, string memory _tokenURI) public {
        _setTokenURI(_tokenId, _tokenURI);
        updateHistory(_tokenId, _tokenURI);
    }

    /**
    * @notice Retrieves the URI of an NFT as it was a specified number of days ago.
    * @dev The `_dayRevert` parameter must be less than 31, as only the history of the last 30 days is retained.
    * @param _tokenId The unique identifier of the NFT.
    * @param _dayRevert The number of days ago to retrieve the URI (0 for the most recent, up to 30 days ago).
    * @return The URI of the NFT from the specified day in its history.
    */
    function getURIByDayRevert(uint256 _tokenId, uint8 _dayRevert) public view returns (string memory) {
        require(_dayRevert < 31, 'Only the last 30 days');
        return histories[_tokenId][_dayRevert];
    }

    /**
    * @notice Updates the URI history of an NFT by adding the latest URI at the beginning and shifting older entries.
    * @dev This function modifies the `histories` mapping for the specified token ID, preserving only the most recent 30 entries.
    * @param _tokenId The unique identifier of the NFT whose history is being updated.
    * @param _tokenURI The new URI to be added to the history.
    */
    function updateHistory(uint256 _tokenId, string memory _tokenURI) public {
        for (uint8 index=LIMIT_DAY - 1; index > 0; --index){
            histories[_tokenId][index] = histories[_tokenId][ index - 1];
        }
        histories[_tokenId][0]=_tokenURI;
    }

    // /**
    // * @notice Shifts all elements in the input array one step to the right, replacing each element with the one before it.
    // * @param arr The input array of strings to be shifted.
    // */
    // function shiftOneStep(string[LIMIT_DAY] storage arr) public {
    //     for (uint8 index=LIMIT_DAY - 1; index > 0; --index){
    //         arr[index] = arr[ index - 1];
    //     }
    // }


}
