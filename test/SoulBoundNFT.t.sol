// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SoulBoundNFT.sol";

contract SoulBoundNFTTest is Test {
    SoulBoundNFT public nft;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        nft = new SoulBoundNFT("SoulBoundNFT", "SBNFT");
    }

    function testMint() public {
        nft.safeMint(user1, "SomeToken1");
        assertEq(nft.balanceOf(user1), 1);
        assertEq(nft.ownerOf(0), user1);
        assertEq(nft.tokenURI(0), "SomeToken1");
    }

    function testFailMintTwice() public {
        nft.safeMint(user1, "SomeToken1");
        nft.safeMint(user1, "SomeToken2");
    }

    function testFailNonOwnerMint() public {
        vm.prank(user1);
        nft.safeMint(user2, "SomeToken1");
    }

    function testFailTransfer() public {
        nft.safeMint(user1, "SomeToken1");
        vm.prank(user1);
        nft.transferFrom(user1, user2, 0);
    }

    function testFailApprove() public {
        nft.safeMint(user1, "SomeToken1");
        vm.prank(user1);
        nft.approve(user2, 0);
    }

    function testFailSetApprovalForAll() public {
        nft.safeMint(user1, "SomeToken1");
        vm.prank(user1);
        nft.setApprovalForAll(user2, true);
    }

    function testTokenURI() public {
        nft.safeMint(user1, "SomeToken1");
        assertEq(nft.tokenURI(0), "SomeToken1");
    }

    function testFailNonexistentTokenURI() public view {
        nft.tokenURI(999);
    }
}