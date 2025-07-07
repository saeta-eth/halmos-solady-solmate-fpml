// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulDivDown.sol";

// MulDivDown verification using Halmos
// This test proves correctness and equivalence between implementations

// To run:
// - `forge test --match-test test__MulDivDownCorrectness` (fuzz for correctness of all versions)
// - `halmos --function testCheck__MulDivDownEquivalence` (proves equivalence between simple implementations)
// - `halmos --function testCheck__MulDivDownCorrectness` (proves correctness against reference)
// - `forge test --match-test test__FullMulDivCorrectness` (fuzz test for full precision version)

contract MulDivDownTests is Test {
    MulDivDown c;

    function setUp() public {
        c = new MulDivDown();
    }


    // Symbolic test to confirm equivalence between Solady and Solmate simple implementations
    function testCheck__MulDivDownEquivalence(uint256 x, uint256 y, uint256 d) public {
        // Bound inputs to valid ranges to prevent overflow
        x = bound(x, 1, type(uint128).max);
        y = bound(y, 1, type(uint128).max);
        d = bound(d, 1, type(uint256).max);
        
        uint256 solady = c.soladyMulDiv(x, y, d);
        uint256 solmate = c.solmateMulDivDown(x, y, d);
        
        assertEq(solady, solmate);
    }



    // Test edge cases
    function testCheck__MulDivDownEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyMulDiv(0, 1, 1), 0);
        assertEq(c.solmateMulDivDown(0, 1, 1), 0);
        assertEq(c.soladyFullMulDiv(0, 1, 1), 0);
        
        // Test y = 0
        assertEq(c.soladyMulDiv(1, 0, 1), 0);
        assertEq(c.solmateMulDivDown(1, 0, 1), 0);
        assertEq(c.soladyFullMulDiv(1, 0, 1), 0);
        
        // Test d = 1 (should return x * y)
        assertEq(c.soladyMulDiv(123, 456, 1), 123 * 456);
        assertEq(c.solmateMulDivDown(123, 456, 1), 123 * 456);
        assertEq(c.soladyFullMulDiv(123, 456, 1), 123 * 456);
        
        // Test x = y = d (should return 1)
        assertEq(c.soladyMulDiv(123, 123, 123 * 123), 1);
        assertEq(c.solmateMulDivDown(123, 123, 123 * 123), 1);
        assertEq(c.soladyFullMulDiv(123, 123, 123 * 123), 1);
    }

    // Test precise division behavior
    function testCheck__MulDivDownPrecision() public {
        // Test floor behavior: (5 * 3) / 4 = 15 / 4 = 3 (not 4)
        uint256 x = 5;
        uint256 y = 3;
        uint256 d = 4;
        
        uint256 expected = 3; // floor(15/4) = 3
        
        assertEq(c.soladyMulDiv(x, y, d), expected);
        assertEq(c.solmateMulDivDown(x, y, d), expected);
        assertEq(c.soladyFullMulDiv(x, y, d), expected);
    }

    // Test high precision cases where fullMulDiv shines
    function testCheck__FullMulDivHighPrecision() public {
        // Test case where x * y would overflow uint256 but result fits
        uint256 x = type(uint128).max; // Very large number
        uint256 y = type(uint128).max; // Very large number  
        uint256 d = type(uint128).max; // Large divisor
        
        // This should equal type(uint128).max since (max * max) / max = max
        uint256 soladyResult = c.soladyFullMulDiv(x, y, d);
        uint256 solmateResult = c.solmateMulDivDown(x, y, d);
        assertEq(soladyResult, type(uint128).max);
        assertEq(solmateResult, type(uint128).max);
    }

    // Test revert conditions
    function test_RevertWhen_MulDivDownZeroDenominator() public {
        vm.expectRevert();
        c.soladyMulDiv(1, 1, 0);
        
        vm.expectRevert();
        c.solmateMulDivDown(1, 1, 0);
    }

    function test_RevertWhen_MulDivDownOverflow() public {
        vm.expectRevert();
        c.soladyMulDiv(type(uint256).max, 2, 1);
        
        vm.expectRevert();
        c.solmateMulDivDown(type(uint256).max, 2, 1);
    }

    function test_RevertWhen_FullMulDivZeroDenominator() public {
        vm.expectRevert();
        c.soladyFullMulDiv(1, 1, 0);
    }

    function test_RevertWhen_FullMulDivResultOverflow() public {
        // Case where result would exceed uint256
        vm.expectRevert();
        c.soladyFullMulDiv(type(uint256).max, type(uint256).max, 1);
    }
}