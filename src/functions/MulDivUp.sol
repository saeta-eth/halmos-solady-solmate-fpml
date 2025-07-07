// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract MulDivUp {

    // Solady implementation: mulDivUp
    function soladyMulDivUp(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SoladyFixedPointMathLib.mulDivUp(x, y, d);
    }

    // Solmate implementation: mulDivUp
    function solmateMulDivUp(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SolmateFixedPointMathLib.mulDivUp(x, y, d);
    }

    // Solady full precision implementation: fullMulDivUp
    function soladyFullMulDivUp(uint256 x, uint256 y, uint256 d) public pure returns (uint256) {
        return SoladyFixedPointMathLib.fullMulDivUp(x, y, d);
    }
}