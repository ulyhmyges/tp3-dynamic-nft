// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NFT} from "../src/NFT.sol";

contract NFTScript is Script {
    NFT public nft;
    address public wallet;
    function setUp() public {
        wallet = address(vm.envAddress("WALLET"));
    }

    function run() public {
        uint256 pk = vm.envUint("PK"); // private key
       
        vm.startBroadcast(pk);
        nft = new NFT("BituleNFT", "BNFT");
        
        uint256 tokenId = nft.mint("QmVXxHUWE2fdNjMxerzgWNJNeR8tu1F61KYY6BjDo2LRMA");
        console.log("tokenId: ", tokenId);

        console.log("url: ", nft.tokenURI(tokenId)); // => https://ipfs.io/ipfs/QmVXxHUWE2fdNjMxerzgWNJNeR8tu1F61KYY6BjDo2LRMA

        // update URI
        nft.updateNFT(1, "QmcFhGCkaeb3w9L9Mr7USF7ZD3pn2VRGNsbjYf3Xz5SAtB");
        console.log(nft.tokenURI(1));
        console.log(nft.getURIByDayRevert(1, 0));
        console.log(nft.getURIByDayRevert(1, 2));
        console.log(nft.getURIByDayRevert(1, 1));
    
        vm.stopBroadcast();
    }
}
