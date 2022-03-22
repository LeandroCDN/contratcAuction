// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {MedabotsMetadata} from "../libraries/MedabotsMetadata.sol";

interface IMedabotsGarage is IERC721 {
    struct Robot {
        MedabotsMetadata.Family familyId;
        address owner;
        uint256 tokenPartOne;
        uint256 tokenPartTwo;
        uint256 tokenPartThree;
        uint256 tokenPartFour;
        bool available;
    }

    /**
     * @dev Emitted when the user call to {assemble}
     **/
    event AssembleEvent(
        uint256 robotId,
        MedabotsMetadata.Family familyId,
        address owner,
        uint256 tokenPartOne,
        uint256 tokenPartTwo,
        uint256 tokenPartThree,
        uint256 tokenPartFour,
        bool available
    );

    /**
     * @dev  Emitted when the user call to {disassemble}
     **/
    event DisassembleEvent(
        uint256 robotId,
        MedabotsMetadata.Family familyId,
        address owner,
        uint256 tokenPartOne,
        uint256 tokenPartTwo,
        uint256 tokenPartThree,
        uint256 tokenPartFour,
        bool available
    );

    function assemble(
        MedabotsMetadata.Family familyId,
        uint256 tokenPartOne,
        uint256 tokenPartTwo,
        uint256 tokenPartThree,
        uint256 tokenPartFour
    ) external;

    function disassemble(uint256 robotId) external;

    function robotOwner(uint256 _robotId) external view returns (address);

    function transferRobot(uint256 _robotId, address _newOwner) external;

    function getRobot(uint256 _robotId) external returns (Robot memory);

    function isAvailable(uint256 _robotId) external view returns (bool);
}
