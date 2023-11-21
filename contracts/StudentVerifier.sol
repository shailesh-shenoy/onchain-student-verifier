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
        string memory _name,
        string memory _symbol_
    ) ERC721(_name, _symbol_) {}

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
    ) internal override {
        // check that challenge input is address of sender
        address addr = GenesisUtils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        // this is linking between msg.sender and address in proof
        require(
            _msgSender() == addr,
            "address in proof is not a sender address"
        );
        // Set the value to check in proof to sender's address
        // Get the last 15 digits of sender's address after converting to uint256
        uint256 dynamicValue = uint256(uint160(_msgSender())) % 10 ** 15;

        _setDynamicValue(TRANSFER_REQUEST_ID, dynamicValue);
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

    /**
     * @dev Override the token URI function to return the metadata URI.
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
