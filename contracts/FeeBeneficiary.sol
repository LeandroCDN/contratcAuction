// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FeeBeneficiary is Ownable {
    uint256 public feePercentage;
    address public feeTo;

    constructor(address _feeTo, uint256 _feePercentage) {
        setFee(_feeTo == address(0) ? address(this) : _feeTo, _feePercentage);
    }

    function setFee(address _feeTo, uint256 _feePercentage) public onlyOwner {
        feeTo = _feeTo;
        feePercentage = _feePercentage;
    }

    function _chargeFee(IERC20 _token, uint256 _totalAmount) internal returns (uint256) {
        uint256 fee = (_totalAmount * feePercentage) / 100;
        _token.transferFrom(msg.sender, feeTo, fee);
        uint256 resultingAmount = _totalAmount - fee;
        return resultingAmount;
    }

    function _getResultingAmount(uint256 _totalAmount, IERC20 _token) internal returns (uint256) {
        uint256 fee = (_totalAmount * feePercentage) / 100;

        if (feeTo != address(this)) {
            _token.transfer(feeTo, fee);
        }
        uint256 resultingAmount = _totalAmount - fee;
        return resultingAmount;
    }
}
