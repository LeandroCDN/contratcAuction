// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import {SignatureVerifier} from "./libraries/SignatureVerifier.sol";
import {MedabotsMetadata} from "./libraries/MedabotsMetadata.sol";
import "./interfaces/IMedabots.sol";

contract MedabotsFactory is Ownable, Pausable {
    using SignatureVerifier for bytes32;
    mapping(bytes32 => bool) public usedKeys;
    IMedabots public medabots;
    IERC20 public medamon;
    IERC20 public medacoin;

    constructor(IMedabots _medabots, IERC20 _medamon,  IERC20 _medacoin) {
        medamon = _medamon;
        medacoin = _medacoin;
        medabots = _medabots;
    }

    function transferMedabotsOwnership(address newOwner) public virtual onlyOwner {
        medabots.transferOwnership(newOwner);
    }

    function mint(
        uint256 _priceMon,
        uint256 _priceMedacoin,
        string calldata _metadataURI,
        MedabotsMetadata.Metadata calldata _metadata,
        uint256 _expiry,
        bytes32 _idempotencyKey,
        bytes memory _signature
    ) public {
        require(_expiry > block.timestamp, "FACTORY: Permit expired");
        require(!usedKeys[_idempotencyKey], "FACTORY: Permit already used");
        bytes32 metadataHash = keccak256(
            abi.encode(
                _metadata.nameId,
                _metadata.partId,
                _metadata.imageUrl,
                _metadata.speed,
                _metadata.life, 
                _metadata.attack,
                _metadata.defense,
                _metadata.rarityId,
                _metadata.familyId
            )
        );
        bytes32 checksHash = keccak256(abi.encode(msg.sender, _price, _expiry, _idempotencyKey));
        bool isPermitValid = verify(owner(), metadataHash, checksHash, _signature);
        require(isPermitValid, "FACTORY: Permit invalid");
        medamon.transferFrom(msg.sender, owner(), _priceMon);
        medacoin.transferFrom(msg.sender, owner(), _priceMedacoin);
        medabots.mint(msg.sender, _metadataURI, _metadata);
        usedKeys[_idempotencyKey] = true;
    }

    function verify(
        address owner,
        bytes32 metadataHash,
        bytes32 checksHash,
        bytes memory _signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(metadataHash, checksHash);
        bytes32 signedMessage = messageHash.getEthSignedMessageHash();
        return signedMessage.getSigner(_signature) == owner;
    }

    function getMessageHash(bytes32 metadataHash, bytes32 checksHash) public pure returns (bytes32) {
        return keccak256(abi.encode(metadataHash, checksHash));
    }

    function ownerMint(string calldata _metadataURI, MedabotsMetadata.Metadata calldata _metadata) public onlyOwner {
        medabots.mint(msg.sender, _metadataURI, _metadata);
    }
}
