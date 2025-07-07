// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/UnsafeOps.sol";

// UnsafeOps differential testing using Halmos
// This test proves equivalence between Solmate unsafe operations and Solady raw operations

// To run:
// - `halmos --function testCheck__UnsafeModEquivalence` (proves equivalence between unsafeMod and rawMod)
// - `halmos --function testCheck__UnsafeDivEquivalence` (proves equivalence between unsafeDiv and rawDiv)
// - `forge test --match-test test__UnsafeOpsEdgeCases` (test edge cases with concrete values)

contract UnsafeOpsTests is Test {
    UnsafeOps c;

    function setUp() public {
        c = new UnsafeOps();
    }

    // Symbolic test to confirm equivalence between Solmate unsafeMod and Solady rawMod
    function testCheck__UnsafeModEquivalence(uint256 x, uint256 y) public {
        uint256 solmate = c.solmateUnsafeMod(x, y);
        uint256 solady = c.soladyRawMod(x, y);
        
        assertEq(solmate, solady);
    }

    // Symbolic test to confirm equivalence between Solmate unsafeDiv and Solady rawDiv
    function testCheck__UnsafeDivEquivalence(uint256 x, uint256 y) public {
        uint256 solmate = c.solmateUnsafeDiv(x, y);
        uint256 solady = c.soladyRawDiv(x, y);
        
        assertEq(solmate, solady);
    }

    // Test edge cases with concrete values
    function test__UnsafeOpsEdgeCases() public {
        // Test division by zero - should return 0 instead of reverting
        assertEq(c.solmateUnsafeMod(100, 0), 0);
        assertEq(c.soladyRawMod(100, 0), 0);
        
        assertEq(c.solmateUnsafeDiv(100, 0), 0);
        assertEq(c.soladyRawDiv(100, 0), 0);
        
        // Test normal operations
        assertEq(c.solmateUnsafeMod(100, 7), 2);
        assertEq(c.soladyRawMod(100, 7), 2);
        
        assertEq(c.solmateUnsafeDiv(100, 7), 14);
        assertEq(c.soladyRawDiv(100, 7), 14);
        
        // Test with 1
        assertEq(c.solmateUnsafeMod(100, 1), 0);
        assertEq(c.soladyRawMod(100, 1), 0);
        
        assertEq(c.solmateUnsafeDiv(100, 1), 100);
        assertEq(c.soladyRawDiv(100, 1), 100);
        
        // Test with same numbers
        assertEq(c.solmateUnsafeMod(42, 42), 0);
        assertEq(c.soladyRawMod(42, 42), 0);
        
        assertEq(c.solmateUnsafeDiv(42, 42), 1);
        assertEq(c.soladyRawDiv(42, 42), 1);
        
        // Test with zero dividend
        assertEq(c.solmateUnsafeMod(0, 42), 0);
        assertEq(c.soladyRawMod(0, 42), 0);
        
        assertEq(c.solmateUnsafeDiv(0, 42), 0);
        assertEq(c.soladyRawDiv(0, 42), 0);
    }
}