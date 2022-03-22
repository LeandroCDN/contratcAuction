// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import {MedabotsMetadata} from "../libraries/MedabotsMetadata.sol";

interface IMedabots is IERC721Metadata {
    function mint(
        address _owner,
        string calldata _metadataURI,
        MedabotsMetadata.Metadata calldata _metadata
    ) external returns (uint256);

    function transferOwnership(address newOwner) external;

    function familyOf(uint256 tokenId) external view returns (MedabotsMetadata.Family);

    function partOf(uint256 tokenId) external view returns (MedabotsMetadata.Part);
}
