// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/Sqrt.sol";

// Sqrt differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__SqrtEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__SqrtEdgeCases` (test edge cases with concrete values)

contract SqrtTests is Test {
    Sqrt c;

    function setUp() public {
        c = new Sqrt();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__SqrtEquivalence(uint256 x) public {
        uint256 solady = c.soladySqrt(x);
        uint256 solmate = c.solmateSqrt(x);
        
        assertEq(solady, solmate);
    }

    // Symbolic test using stripped versions to focus on estimation logic differences
    function testCheck__SqrtStrippedEquivalence(uint256 x) public {
        uint256 soladyStripped = c.soladySqrtStripped(x);
        uint256 solmateStripped = c.solmateSqrtStripped(x);
        
        assertEq(soladyStripped, solmateStripped);
    }

    // Test edge cases with concrete values
    function test__SqrtEdgeCases() public {
        // Test x = 0
        assertEq(c.soladySqrt(0), 0);
        assertEq(c.solmateSqrt(0), 0);
        
        // Test x = 1
        assertEq(c.soladySqrt(1), 1);
        assertEq(c.solmateSqrt(1), 1);
        
        // Test perfect squares
        assertEq(c.soladySqrt(4), 2);
        assertEq(c.solmateSqrt(4), 2);
        
        assertEq(c.soladySqrt(9), 3);
        assertEq(c.solmateSqrt(9), 3);
        
        assertEq(c.soladySqrt(16), 4);
        assertEq(c.solmateSqrt(16), 4);
        
        assertEq(c.soladySqrt(100), 10);
        assertEq(c.solmateSqrt(100), 10);
        
        // Test large perfect square
        assertEq(c.soladySqrt(1000000), 1000);
        assertEq(c.solmateSqrt(1000000), 1000);
        
        // Test non-perfect squares (floor)
        assertEq(c.soladySqrt(8), 2); // floor(sqrt(8)) = 2
        assertEq(c.solmateSqrt(8), 2);
        
        assertEq(c.soladySqrt(15), 3); // floor(sqrt(15)) = 3
        assertEq(c.solmateSqrt(15), 3);
    }

    // Test Solady-only sqrtWad function (WAD precision sqrt)
    function test__SqrtWadEdgeCases() public {
        // Test sqrtWad with WAD values - returns results in WAD precision
        // sqrt(1.0) = 1.0 in WAD precision
        assertEq(c.soladySqrtWad(1e18), 1e18);
        
        // sqrt(4.0) = 2.0 in WAD precision  
        assertEq(c.soladySqrtWad(4e18), 2e18);
        
        // Test with 0
        assertEq(c.soladySqrtWad(0), 0);
    }
}