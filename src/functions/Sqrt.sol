// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FixedPointMathLib as SoladyFixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {FixedPointMathLib as SolmateFixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract Sqrt {

    // Solady implementation: sqrt
    function soladySqrt(uint256 x) public pure returns (uint256) {
        return SoladyFixedPointMathLib.sqrt(x);
    }

    // Solady implementation: sqrtWad (square root in WAD precision)
    function soladySqrtWad(uint256 x) public pure returns (uint256) {
        return SoladyFixedPointMathLib.sqrtWad(x);
    }

    // Solmate implementation: sqrt
    function solmateSqrt(uint256 x) public pure returns (uint256) {
        return SolmateFixedPointMathLib.sqrt(x);
    }

    // Stripped Solady implementation: focuses on the unique estimation logic
    function soladySqrtStripped(uint256 x) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := 181
            
            // Solady's compact bit manipulation approach
            let r := shl(7, lt(0xffffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffffff, shr(r, x))))
            z := shl(shr(1, r), z)
            
            // Final estimation using tracked shift amount r
            z := shr(18, mul(z, add(shr(r, x), 65536)))
        }
    }

    // Stripped Solmate implementation: focuses on the unique estimation logic
    function solmateSqrtStripped(uint256 x) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            let y := x
            z := 181
            
            // Solmate's explicit if statement approach
            if iszero(lt(y, 0x10000000000000000000000000000000000)) {
                y := shr(128, y)
                z := shl(64, z)
            }
            if iszero(lt(y, 0x1000000000000000000)) {
                y := shr(64, y)
                z := shl(32, z)
            }
            if iszero(lt(y, 0x10000000000)) {
                y := shr(32, y)
                z := shl(16, z)
            }
            if iszero(lt(y, 0x1000000)) {
                y := shr(16, y)
                z := shl(8, z)
            }
            
            // Final estimation using progressively shifted y
            z := shr(18, mul(z, add(y, 65536)))
        }
    }
}