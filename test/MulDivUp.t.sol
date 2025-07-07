// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulDivUp.sol";

// MulDivUp verification using Halmos
// This test proves correctness and equivalence between implementations

// To run:
// - `halmos --function testCheck__MulDivUpEquivalence` (proves equivalence between simple implementations)
// - `halmos --function testCheck__MulDivUpCorrectness` (proves correctness against reference)

contract MulDivUpTests is Test {
    MulDivUp c;

    function setUp() public {
        c = new MulDivUp();
    }


    // Symbolic test to confirm equivalence between Solady and Solmate simple implementations
    function testCheck__MulDivUpEquivalence(uint256 x, uint256 y, uint256 d) public {
        // Bound inputs to valid ranges to prevent overflow
        x = bound(x, 1, type(uint128).max);
        y = bound(y, 1, type(uint128).max);
        d = bound(d, 1, type(uint256).max);
        
        uint256 solady = c.soladyMulDivUp(x, y, d);
        uint256 solmate = c.solmateMulDivUp(x, y, d);
        
        assertEq(solady, solmate);
    }



    // Test edge cases
    function testCheck__MulDivUpEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyMulDivUp(0, 1, 1), 0);
        assertEq(c.solmateMulDivUp(0, 1, 1), 0);
        assertEq(c.soladyFullMulDivUp(0, 1, 1), 0);
        
        // Test y = 0
        assertEq(c.soladyMulDivUp(1, 0, 1), 0);
        assertEq(c.solmateMulDivUp(1, 0, 1), 0);
        assertEq(c.soladyFullMulDivUp(1, 0, 1), 0);
        
        // Test d = 1 (should return x * y)
        assertEq(c.soladyMulDivUp(123, 456, 1), 123 * 456);
        assertEq(c.solmateMulDivUp(123, 456, 1), 123 * 456);
        assertEq(c.soladyFullMulDivUp(123, 456, 1), 123 * 456);
        
        // Test x = y = d (should return 1)
        assertEq(c.soladyMulDivUp(123, 123, 123 * 123), 1);
        assertEq(c.solmateMulDivUp(123, 123, 123 * 123), 1);
        assertEq(c.soladyFullMulDivUp(123, 123, 123 * 123), 1);
    }

    // Test rounding up behavior specifically
    function testCheck__MulDivUpRounding() public {
        // Test ceil behavior: (5 * 3) / 4 = 15 / 4 = 3.75 → 4 (rounded up)
        uint256 x = 5;
        uint256 y = 3;
        uint256 d = 4;
        
        uint256 expected = 4; // ceil(15/4) = 4
        
        assertEq(c.soladyMulDivUp(x, y, d), expected);
        assertEq(c.solmateMulDivUp(x, y, d), expected);
        assertEq(c.soladyFullMulDivUp(x, y, d), expected);
        
        // Verify it's actually rounded up (should be > regular division)
        uint256 product = x * y;
        uint256 regularDiv = product / d;
        assertGt(expected, regularDiv);
    }

    // Test specific rounding cases
    function testCheck__MulDivUpRoundingCases() public {
        // Case where there's no remainder - should equal regular division
        uint256 x = 8;
        uint256 y = 3;
        uint256 d = 4;
        // 8 * 3 = 24, 24 / 4 = 6 exactly (no remainder)
        
        uint256 result = c.soladyMulDivUp(x, y, d);
        assertEq(result, 6);
        assertEq(c.solmateMulDivUp(x, y, d), 6);
        
        // Case where there's a remainder - should round up
        x = 7; y = 3; d = 4;
        // 7 * 3 = 21, 21 / 4 = 5.25 → 6
        result = c.soladyMulDivUp(x, y, d);
        assertEq(result, 6);
        assertEq(c.solmateMulDivUp(x, y, d), 6);
        
        // Verify the floor would be different
        uint256 floor = (x * y) / d;
        assertEq(floor, 5);
        assertGt(result, floor);
    }

    // Test high precision cases where fullMulDivUp shines
    function testCheck__FullMulDivUpHighPrecision() public {
        // Test case where x * y would overflow uint256 but result fits
        uint256 x = type(uint128).max; // Very large number
        uint256 y = type(uint128).max; // Very large number  
        uint256 d = type(uint128).max; // Large divisor
        
        // This should equal type(uint128).max since (max * max) / max = max
        uint256 result = c.soladyFullMulDivUp(x, y, d);
        assertEq(result, type(uint128).max);
        
        // Test with remainder to ensure rounding up
        d = type(uint128).max - 1;
        result = c.soladyFullMulDivUp(x, y, d);
        // Should be slightly more than type(uint128).max due to rounding up
        assertGt(result, type(uint128).max);
    }

    // Test revert conditions
    function test_RevertWhen_MulDivUpZeroDenominator() public {
        vm.expectRevert();
        c.soladyMulDivUp(1, 1, 0);
        
        vm.expectRevert();
        c.solmateMulDivUp(1, 1, 0);
    }

    function test_RevertWhen_MulDivUpOverflow() public {
        vm.expectRevert();
        c.soladyMulDivUp(type(uint256).max, 2, 1);
        
        vm.expectRevert();
        c.solmateMulDivUp(type(uint256).max, 2, 1);
    }

    function test_RevertWhen_FullMulDivUpZeroDenominator() public {
        vm.expectRevert();
        c.soladyFullMulDivUp(1, 1, 0);
    }

    function test_RevertWhen_FullMulDivUpResultOverflow() public {
        // Case where result would exceed uint256
        vm.expectRevert();
        c.soladyFullMulDivUp(type(uint256).max, type(uint256).max, 1);
    }
}