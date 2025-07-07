// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/DivWadUp.sol";

// DivWadUp differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__DivWadUpEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__DivWadUpEdgeCases` (test edge cases with concrete values)

contract DivWadUpTests is Test {
    DivWadUp c;

    function setUp() public {
        c = new DivWadUp();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__DivWadUpEquivalence(uint256 x, uint256 y) public {
        // Bound inputs to valid ranges to prevent overflow
        x = bound(x, 1, type(uint256).max / 1e18);
        y = bound(y, 1, type(uint256).max);
        
        uint256 solady = c.soladyDivWadUp(x, y);
        uint256 solmate = c.solmateDivWadUp(x, y);
        
        assertEq(solady, solmate);
    }

    // Test edge cases with concrete values
    function test__DivWadUpEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyDivWadUp(0, 1), 0);
        assertEq(c.solmateDivWadUp(0, 1), 0);
        
        // Test y = 1 (should return x * WAD)
        assertEq(c.soladyDivWadUp(1, 1), 1e18);
        assertEq(c.solmateDivWadUp(1, 1), 1e18);
        
        // Test x = y (should return WAD)
        assertEq(c.soladyDivWadUp(123, 123), 1e18);
        assertEq(c.solmateDivWadUp(123, 123), 1e18);
        
        // Test rounding up behavior: divWadUp(x, y) = (x * WAD + y - 1) / y
        // divWadUp(1.5e18, 2) = ((1.5e18 * 1e18) + 2 - 1) / 2 = 7.5e35
        uint256 result1 = c.soladyDivWadUp(15e17, 2);
        uint256 result2 = c.solmateDivWadUp(15e17, 2);
        assertEq(result1, result2);
        assertEq(result1, 75e34); // (1.5 * WAD * WAD) / 2
        
        // Test case where rounding up occurs
        // 3 * WAD / 4 = 0.75 * WAD exactly (no rounding needed)
        assertEq(c.soladyDivWadUp(3, 4), 75e16);
        assertEq(c.solmateDivWadUp(3, 4), 75e16);
        
        // Test case with remainder: 1 * WAD / 3 should round up
        uint256 result3 = c.soladyDivWadUp(1, 3);
        uint256 result4 = c.solmateDivWadUp(1, 3);
        assertEq(result3, result4);
        // (1 * WAD) / 3 should round up from floor division
        uint256 product = 1 * 1e18;
        uint256 floorDiv = product / 3;
        assertGt(result3, floorDiv); // Should be greater than floor division
    }

    // Test revert conditions
    function test_RevertWhen_DivWadUpZeroDenominator() public {
        vm.expectRevert();
        c.soladyDivWadUp(1, 0);
        
        vm.expectRevert();
        c.solmateDivWadUp(1, 0);
    }

    function test_RevertWhen_DivWadUpOverflow() public {
        vm.expectRevert();
        c.soladyDivWadUp(type(uint256).max, 1);
        
        vm.expectRevert();
        c.solmateDivWadUp(type(uint256).max, 1);
    }
}