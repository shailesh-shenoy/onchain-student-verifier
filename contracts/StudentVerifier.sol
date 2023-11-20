// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {GenesisUtils} from "@iden3/contracts/lib/GenesisUtils.sol";
import {ICircuitValidator} from "@iden3/contracts/interfaces/ICircuitValidator.sol";
import {ZKPVerifier} from "@iden3/contracts/verifiers/ZKPVerifier.sol";

contract StudentVerifier is ERC721, ZKPVerifier {
    uint64 public constant TRANSFER_REQUEST_ID = 1;

    uint256 private _tokenIdCounter;

    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) {}

    /**
     * @dev Override the base URI function to return the metadata URI.
     * This metadata will be same for all SBTs.
     */
    function _baseURI() internal pure override returns (string memory) {
        // TODO: change to real metadata URI
        return
            "https://ipfs.io/ipfs/QmUFbUjAifv9GwJo7ufTB5sccnrNqELhDMafoEmZdPPng7";
    }

    function _beforeProofSubmit(
        uint64 /* requestId */,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that challenge input is address of sender
        address addr = GenesisUtils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        // this is linking between msg.sender and address in proof
        require(
            _msgSender() == addr,
            "address in proof is not a sender address"
        );
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator /* validator */
    ) internal override {
        require(
            requestId == TRANSFER_REQUEST_ID && addressToId[_msgSender()] == 0,
            "proof can not be submitted more than once"
        );

        // get user id
        uint256 id = inputs[1];
        // additional check didn't get airdrop tokens before
        if (idToAddress[id] == address(0) && addressToId[_msgSender()] == 0) {
            _tokenIdCounter += 1;
            _safeMint(_msgSender(), _tokenIdCounter);
            addressToId[_msgSender()] = id;
            idToAddress[id] = _msgSender();
        }
    }

    function _beforeTokenTransfer(
        address from,
        address /* to */,
        uint256 /* tokenId */
    ) internal pure override {
        require(
            from == address(0),
            "This token is bound to the verified address and can not be transferred"
        );
    }
}
