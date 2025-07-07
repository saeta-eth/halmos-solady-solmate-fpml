// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract DivWadUp {
    // Solady implementation: divWadUp
    function soladyDivWadUp(uint256 x, uint256 y) public pure returns (uint256) {
        return SoladyFixedPointMathLib.divWadUp(x, y);
    }

    // Solmate implementation: divWadUp
    function solmateDivWadUp(uint256 x, uint256 y) public pure returns (uint256) {
        return SolmateFixedPointMathLib.divWadUp(x, y);
    }
}