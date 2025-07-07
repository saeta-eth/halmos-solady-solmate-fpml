// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract MulWadUp {

    // Solady implementation: mulWadUp
    function soladyMulWadUp(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.mulWadUp(x, y);
    }

    // Solmate implementation: mulWadUp
    function solmateMulWadUp(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.mulWadUp(x, y);
    }
}