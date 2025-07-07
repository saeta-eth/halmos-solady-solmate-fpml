// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

contract UnsafeOps {

    // Solmate implementation: unsafeMod
    function solmateUnsafeMod(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.unsafeMod(x, y);
    }

    // Solmate implementation: unsafeDiv
    function solmateUnsafeDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.unsafeDiv(x, y);
    }

    // Solady implementation: rawMod (equivalent to unsafeMod)
    function soladyRawMod(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.rawMod(x, y);
    }

    // Solady implementation: rawDiv (equivalent to unsafeDiv)
    function soladyRawDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.rawDiv(x, y);
    }
}