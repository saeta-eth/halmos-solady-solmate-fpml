// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulWadUp.sol";

// MulWadUp differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__MulWadUpEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__MulWadUpEdgeCases` (test edge cases with concrete values)

contract MulWadUpTests is Test {
    MulWadUp c;

    function setUp() public {
        c = new MulWadUp();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__MulWadUpEquivalence(uint128 x, uint128 y) public {
        // Use uint128 to prevent overflow in x * y
        uint256 solady = c.soladyMulWadUp(x, y);
        uint256 solmate = c.solmateMulWadUp(x, y);
        
        assertEq(solady, solmate);
    }

    // Test edge cases with concrete values
    function test__MulWadUpEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyMulWadUp(0, 1e18), 0);
        assertEq(c.solmateMulWadUp(0, 1e18), 0);
        
        // Test y = 0
        assertEq(c.soladyMulWadUp(1e18, 0), 0);
        assertEq(c.solmateMulWadUp(1e18, 0), 0);
        
        // Test x = y = WAD (should return WAD)
        assertEq(c.soladyMulWadUp(1e18, 1e18), 1e18);
        assertEq(c.solmateMulWadUp(1e18, 1e18), 1e18);
        
        // Test rounding up behavior - should round up when there's a remainder
        // Example: (3 * 5e17) / 1e18 = 1.5, should round up to 2
        assertEq(c.soladyMulWadUp(3, 5e17), 2);
        assertEq(c.solmateMulWadUp(3, 5e17), 2);
        
        // Test exact division (no remainder) - should equal normal division
        assertEq(c.soladyMulWadUp(2e18, 5e17), 1e18); // 2 * 0.5 = 1.0 exactly
        assertEq(c.solmateMulWadUp(2e18, 5e17), 1e18);
    }

    // Test revert conditions
    function test_RevertWhen_MulWadUpOverflow() public {
        vm.expectRevert();
        c.soladyMulWadUp(type(uint256).max, 2);
        
        vm.expectRevert();
        c.solmateMulWadUp(type(uint256).max, 2);
    }
}