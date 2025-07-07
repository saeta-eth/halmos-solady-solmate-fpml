// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

contract SqrtWad {

    // Solady implementation: sqrtWad
    function soladySqrtWad(uint256 x) public pure returns (uint256) {
        return SoladyFixedPointMathLib.sqrtWad(x);
    }

    // Solady implementation: cbrt (cube root)
    function soladyCbrt(uint256 x) public pure returns (uint256) {
        return SoladyFixedPointMathLib.cbrt(x);
    }

    // Solady implementation: cbrtWad (cube root in WAD)
    function soladyCbrtWad(uint256 x) public pure returns (uint256) {
        return SoladyFixedPointMathLib.cbrtWad(x);
    }

    // Note: Solmate does not have sqrtWad, cbrt, or cbrtWad functions
}