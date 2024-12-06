// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFT} from "../src/NFT.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTTest is Test{
    NFT public nft;
    address public wallet;

    function setUp() public {
        // Deploy the contract with sample name and symbol
        nft = new NFT("TestNFT", "TNFT");
        wallet = address(vm.envAddress("WALLET"));
    }

    function testMint() public {
        vm.prank(wallet);
        // Mint a new NFT and validate token details
        string memory tokenURI = "QmTokenURI1";
        uint256 tokenId = nft.mint(tokenURI);

        assertEq(tokenId, 1, "Token ID should increment starting from 1");
        //assertEq(nft.tokenURI(tokenId), string(abi.encodePacked(nft._baseURI(), tokenURI)), "Token URI should be set correctly");
        assertEq(nft.getURIByDayRevert(tokenId, 0), tokenURI, "Initial history entry should match token URI");
    }

    function testUpdateNFT() public {
        vm.prank(wallet);
        // Mint an NFT and update its metadata
        string memory initialURI = "QmInitialURI";
        uint256 tokenId = nft.mint(initialURI);

        string memory updatedURI = "QmUpdatedURI";
        nft.updateNFT(tokenId, updatedURI);

        //assertEq(nft.tokenURI(tokenId), string(abi.encodePacked(nft._baseURI(), updatedURI)), "Updated URI should be reflected");
        assertEq(nft.getURIByDayRevert(tokenId, 0), updatedURI, "History should reflect updated URI");
        assertEq(nft.getURIByDayRevert(tokenId, 1), initialURI, "History should retain previous URI");
    }

    function testHistoryShift() public {
        vm.prank(wallet);
        // Mint an NFT and update its metadata multiple times
        string memory tokenURI1 = "QmURI1";
        uint256 tokenId = nft.mint(tokenURI1);

        for (uint8 i = 2; i <= 35; i++) {
            string memory newURI = string(abi.encodePacked("QmURI", Strings.toString(i)));
            nft.updateNFT(tokenId, newURI);
        }

        // Validate that the history retains only the last 30 entries
        assertEq(nft.getURIByDayRevert(tokenId, 0), "QmURI35", "Most recent URI should be correct");
        assertEq(nft.getURIByDayRevert(tokenId, 29), "QmURI6", "Oldest URI in history should match the 30th most recent update");
    }

    function testGetURIByDayRevert() public {
        vm.prank(wallet);
        // Mint an NFT and test out-of-bounds history retrieval
        uint256 tokenId = nft.mint("QmTokenURI1");

        vm.expectRevert("Only the last 30 days");
        nft.getURIByDayRevert(tokenId, 31);
    }


    function testUpdateHistory() public {
        vm.prank(wallet);
        uint256 tokenId = nft.mint("initialURI");

        // Update history with new URIs
        nft.updateHistory(tokenId, "newURI1");
        nft.updateHistory(tokenId, "newURI2");
        nft.updateHistory(tokenId, "newURI3");

        // Verify the most recent history entries
        string memory uri0 = nft.getURIByDayRevert(tokenId, 0);
        string memory uri1 = nft.getURIByDayRevert(tokenId, 1);
        string memory uri2 = nft.getURIByDayRevert(tokenId, 2);
        string memory uri3 = nft.getURIByDayRevert(tokenId, 3);

        assertEq(uri0, "newURI3", "Latest URI should be at index 0");
        assertEq(uri1, "newURI2", "Second-latest URI should be at index 1");
        assertEq(uri2, "newURI1", "Third-latest URI should be at index 2");
        assertEq(uri3, "initialURI", "Oldest URI should remain in history");
    }

    function testHistoryLimit() public {
        vm.prank(wallet);
        uint256 tokenId = nft.mint("initialURI");

        // Simulate 30 updates
        for (uint8 i = 1; i <= 30; i++) {
            nft.updateHistory(tokenId, string(abi.encodePacked("newURI_", Strings.toString(i))));
        }

        assertEq(nft.getURIByDayRevert(tokenId, 0), "newURI_30", "URI should be at index 0");
        assertEq(nft.getURIByDayRevert(tokenId, 1), "newURI_29", "URI should be at index 1");
        assertEq(nft.getURIByDayRevert(tokenId, 2), "newURI_28", "URI should be at index 2");
        assertEq(nft.getURIByDayRevert(tokenId, 3), "newURI_27", "URI should be at index 3");
        assertEq(nft.getURIByDayRevert(tokenId, 4), "newURI_26", "URI should be at index 4");
        assertEq(nft.getURIByDayRevert(tokenId, 5), "newURI_25", "URI should be at index 5");
        assertEq(nft.getURIByDayRevert(tokenId, 6), "newURI_24", "URI should be at index 6");
        assertEq(nft.getURIByDayRevert(tokenId, 7), "newURI_23", "URI should be at index 7");
        assertEq(nft.getURIByDayRevert(tokenId, 8), "newURI_22", "URI should be at index 8");
        assertEq(nft.getURIByDayRevert(tokenId, 9), "newURI_21", "URI should be at index 9");
        assertEq(nft.getURIByDayRevert(tokenId, 10), "newURI_20", "URI should be at index 10");
        assertEq(nft.getURIByDayRevert(tokenId, 11), "newURI_19", "URI should be at index 11");
        assertEq(nft.getURIByDayRevert(tokenId, 12), "newURI_18", "URI should be at index 12");
        assertEq(nft.getURIByDayRevert(tokenId, 13), "newURI_17", "URI should be at index 13");
        assertEq(nft.getURIByDayRevert(tokenId, 14), "newURI_16", "URI should be at index 14");
        assertEq(nft.getURIByDayRevert(tokenId, 15), "newURI_15", "URI should be at index 15");
        assertEq(nft.getURIByDayRevert(tokenId, 16), "newURI_14", "URI should be at index 16");
        assertEq(nft.getURIByDayRevert(tokenId, 17), "newURI_13", "URI should be at index 17");
        assertEq(nft.getURIByDayRevert(tokenId, 18), "newURI_12", "URI should be at index 18");
        assertEq(nft.getURIByDayRevert(tokenId, 19), "newURI_11", "URI should be at index 19");
        assertEq(nft.getURIByDayRevert(tokenId, 20), "newURI_10", "URI should be at index 20");  
        assertEq(nft.getURIByDayRevert(tokenId, 21), "newURI_9", "URI should be at index 21");
        assertEq(nft.getURIByDayRevert(tokenId, 22), "newURI_8", "URI should be at index 22");
        assertEq(nft.getURIByDayRevert(tokenId, 23), "newURI_7", "URI should be at index 23");
        assertEq(nft.getURIByDayRevert(tokenId, 24), "newURI_6", "URI should be at index 24");
        assertEq(nft.getURIByDayRevert(tokenId, 25), "newURI_5", "URI should be at index 25");
        assertEq(nft.getURIByDayRevert(tokenId, 26), "newURI_4", "URI should be at index 26");
        assertEq(nft.getURIByDayRevert(tokenId, 27), "newURI_3", "URI should be at index 27");
        assertEq(nft.getURIByDayRevert(tokenId, 28), "newURI_2", "URI should be at index 28");
        assertEq(nft.getURIByDayRevert(tokenId, 29), "newURI_1", "URI should be at index 29");
        assertEq(nft.getURIByDayRevert(tokenId, 30), "initialURI", "31th most recent URI should be preserved");
        
        vm.expectRevert();
        nft.getURIByDayRevert(tokenId, 31); // Beyond the limit
    }

    function testBaseURI() public {
        vm.prank(wallet);
        assertEq(nft.getBaseURI(), "https://ipfs.io/ipfs/");
    }

    function testFail_BaseURI() public view {
        assertEq(nft.getBaseURI(), "https://");
    }
}