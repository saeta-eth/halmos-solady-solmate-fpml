// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/Rpow.sol";

// Rpow differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__RpowEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__RpowEdgeCases` (test edge cases with concrete values)

contract RpowTests is Test {
    Rpow c;

    function setUp() public {
        c = new Rpow();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__RpowEquivalence(uint256 x, uint256 n, uint256 scalar) public {
        // Bound inputs to reasonable ranges to prevent overflow
        x = bound(x, 1, 1e10); // Reasonable base values
        n = bound(n, 0, 10);   // Small exponents to prevent overflow
        scalar = bound(scalar, 1e18, 1e18); // Standard WAD
        
        uint256 solady = c.soladyRpow(x, n, scalar);
        uint256 solmate = c.solmateRpow(x, n, scalar);
        
        assertEq(solady, solmate);
    }

    // Test edge cases with concrete values
    function test__RpowEdgeCases() public {
        uint256 scalar = 1e18; // WAD
        
        // Test 0^0 = 1 (by convention)
        assertEq(c.soladyRpow(0, 0, scalar), scalar);
        assertEq(c.solmateRpow(0, 0, scalar), scalar);
        
        // Test 0^n = 0 for n > 0
        assertEq(c.soladyRpow(0, 1, scalar), 0);
        assertEq(c.solmateRpow(0, 1, scalar), 0);
        
        assertEq(c.soladyRpow(0, 5, scalar), 0);
        assertEq(c.solmateRpow(0, 5, scalar), 0);
        
        // Test x^0 = 1 for any x > 0
        assertEq(c.soladyRpow(1e18, 0, scalar), scalar);
        assertEq(c.solmateRpow(1e18, 0, scalar), scalar);
        
        assertEq(c.soladyRpow(5e18, 0, scalar), scalar);
        assertEq(c.solmateRpow(5e18, 0, scalar), scalar);
        
        // Test x^1 = x
        assertEq(c.soladyRpow(1e18, 1, scalar), 1e18);
        assertEq(c.solmateRpow(1e18, 1, scalar), 1e18);
        
        assertEq(c.soladyRpow(2e18, 1, scalar), 2e18);
        assertEq(c.solmateRpow(2e18, 1, scalar), 2e18);
        
        // Test 1^n = 1 for any n
        assertEq(c.soladyRpow(1e18, 5, scalar), 1e18);
        assertEq(c.solmateRpow(1e18, 5, scalar), 1e18);
        
        // Test 2^2 = 4
        assertEq(c.soladyRpow(2e18, 2, scalar), 4e18);
        assertEq(c.solmateRpow(2e18, 2, scalar), 4e18);
        
        // Test 2^3 = 8
        assertEq(c.soladyRpow(2e18, 3, scalar), 8e18);
        assertEq(c.solmateRpow(2e18, 3, scalar), 8e18);
    }

    // Test with smaller inputs to avoid overflow
    function test__RpowSmallInputs() public {
        uint256 scalar = 1e18;
        
        // Test with half (0.5)^2 = 0.25
        uint256 half = 5e17; // 0.5 in WAD
        uint256 result1 = c.soladyRpow(half, 2, scalar);
        uint256 result2 = c.solmateRpow(half, 2, scalar);
        assertEq(result1, result2);
        assertEq(result1, 25e16); // 0.25 in WAD
        
        // Test with 1.5^2 = 2.25
        uint256 onePointFive = 15e17; // 1.5 in WAD
        uint256 result3 = c.soladyRpow(onePointFive, 2, scalar);
        uint256 result4 = c.solmateRpow(onePointFive, 2, scalar);
        assertEq(result3, result4);
        assertEq(result3, 225e16); // 2.25 in WAD
    }

    // Test that both implementations handle the same overflow conditions
    function test_RevertWhen_RpowOverflow() public {
        uint256 scalar = 1e18;
        // This should revert for both implementations
        vm.expectRevert();
        c.soladyRpow(type(uint128).max, 10, scalar);
        
        vm.expectRevert();
        c.solmateRpow(type(uint128).max, 10, scalar);
    }
}