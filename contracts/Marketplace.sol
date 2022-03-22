// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IMedabotsGarage.sol";
import "./FeeBeneficiary.sol";

abstract contract Marketplace is FeeBeneficiary, Pausable {
    mapping(IERC721 => bool) public isTokenWhitelisted;
    IERC20 public currency;

    constructor(IERC721[] memory _tokens, IERC20 _currency) {
        currency = _currency;
        whitelistTokens(_tokens);
    }

    modifier onlyWhitelistedTokens(IERC721 _token) {
        require(isTokenWhitelisted[_token], "MARKETPLACE: Token address not whitelisted");
        _;
    }

    function pause(bool _paused) public onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    function setCurrency(IERC20 _currency) public onlyOwner {
        currency = _currency;
    }

    function whitelistTokens(IERC721[] memory _tokens) public onlyOwner {
        for (uint256 i = 0; i < _tokens.length; i++) {
            isTokenWhitelisted[_tokens[i]] = true;
        }
    }

    function blacklistTokens(IERC721[] memory _tokens) public onlyOwner {
        for (uint256 i = 0; i < _tokens.length; i++) {
            isTokenWhitelisted[_tokens[i]] = false;
        }
    }
}
