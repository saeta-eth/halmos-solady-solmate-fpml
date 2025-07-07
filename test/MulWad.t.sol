// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulWad.sol";

// MulWad differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__MulWadEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__MulWadEdgeCases` (test edge cases with concrete values)

contract MulWadTests is Test {
    MulWad c;

    function setUp() public {
        c = new MulWad();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__MulWadEquivalence(uint128 x, uint128 y) public {
        // Use uint128 to prevent overflow in x * y
        uint256 solady = c.soladyMulWad(x, y);
        uint256 solmate = c.solmateMulWadDown(x, y);
        
        assertEq(solady, solmate);
    }

    // Test edge cases with concrete values
    function test__MulWadEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyMulWad(0, 1e18), 0);
        assertEq(c.solmateMulWadDown(0, 1e18), 0);
        
        // Test y = 0
        assertEq(c.soladyMulWad(1e18, 0), 0);
        assertEq(c.solmateMulWadDown(1e18, 0), 0);
        
        // Test x = y = WAD (should return WAD)
        assertEq(c.soladyMulWad(1e18, 1e18), 1e18);
        assertEq(c.solmateMulWadDown(1e18, 1e18), 1e18);
        
        // Test multiplication by 2
        assertEq(c.soladyMulWad(1e18, 2e18), 2e18);
        assertEq(c.solmateMulWadDown(1e18, 2e18), 2e18);
        
        // Test fractional multiplication
        assertEq(c.soladyMulWad(1e18, 5e17), 5e17); // 1 * 0.5 = 0.5
        assertEq(c.solmateMulWadDown(1e18, 5e17), 5e17);
    }

    // Test revert conditions
    function test_RevertWhen_MulWadOverflow() public {
        vm.expectRevert();
        c.soladyMulWad(type(uint256).max, 2);
        
        vm.expectRevert();
        c.solmateMulWadDown(type(uint256).max, 2);
    }
}