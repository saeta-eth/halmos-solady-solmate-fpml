// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract Rpow {

    // Solady implementation: rpow
    function soladyRpow(uint256 x, uint256 n, uint256 scalar) public pure returns (uint256) {
        return SoladyFixedPointMathLib.rpow(x, n, scalar);
    }

    // Solmate implementation: rpow
    function solmateRpow(uint256 x, uint256 n, uint256 scalar) public pure returns (uint256) {
        return SolmateFixedPointMathLib.rpow(x, n, scalar);
    }
}