// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract MulDivDown {

    // Solady implementation: mulDiv (equivalent to mulDivDown)
    function soladyMulDiv(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SoladyFixedPointMathLib.mulDiv(x, y, d);
    }

    // Solmate implementation: mulDivDown
    function solmateMulDivDown(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SolmateFixedPointMathLib.mulDivDown(x, y, d);
    }

    // Solady full precision implementation: fullMulDiv
    function soladyFullMulDiv(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SoladyFixedPointMathLib.fullMulDiv(x, y, d);
    }
}