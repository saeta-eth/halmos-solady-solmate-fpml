// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

contract PowWad {

    // Solady implementation: powWad
    function soladyPowWad(int256 x, int256 y) public pure returns (int256) {
        return SoladyFixedPointMathLib.powWad(x, y);
    }

    // Solady implementation: expWad
    function soladyExpWad(int256 x) public pure returns (int256) {
        return SoladyFixedPointMathLib.expWad(x);
    }

    // Solady implementation: lnWad
    function soladyLnWad(int256 x) public pure returns (int256) {
        return SoladyFixedPointMathLib.lnWad(x);
    }

    // Solady implementation: lambertW0Wad
    function soladyLambertW0Wad(int256 x) public pure returns (int256) {
        return SoladyFixedPointMathLib.lambertW0Wad(x);
    }

    // Note: Solmate does not have powWad, expWad, lnWad, or lambertW0Wad functions
}