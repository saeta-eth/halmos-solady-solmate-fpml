// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract MulWad {

    // Solady implementation: mulWad
    function soladyMulWad(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.mulWad(x, y);
    }

    // Solmate implementation: mulWadDown
    function solmateMulWadDown(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.mulWadDown(x, y);
    }
}