// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract DivWad {
    // Solady implementation: divWad
    function soladyDivWad(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.divWad(x, y);
    }

    // Solmate implementation: divWadDown
    function solmateDivWad(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.divWadDown(x, y);
    }
}