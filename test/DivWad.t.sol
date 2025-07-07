// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/DivWad.sol";

// DivWad differential testing using Halmos
// This test proves equivalence between Solady and Solmate implementations

// To run:
// - `halmos --function testCheck__DivWadEquivalence` (proves equivalence between Solady and Solmate)
// - `forge test --match test__DivWadEdgeCases` (test edge cases with concrete values)

contract DivWadTests is Test {
    DivWad c;

    function setUp() public {
        c = new DivWad();
    }

    // Symbolic test to confirm equivalence between Solady and Solmate implementations
    function testCheck__DivWadEquivalence(uint256 x, uint256 y) public {
        // Bound inputs to valid ranges to prevent overflow
        x = bound(x, 1, type(uint256).max / 1e18);
        y = bound(y, 1, type(uint256).max);
        
        uint256 solady = c.soladyDivWad(x, y);
        uint256 solmate = c.solmateDivWad(x, y);
        
        assertEq(solady, solmate);
    }

    // Test edge cases with concrete values
    function test__DivWadEdgeCases() public {
        // Test x = 0
        assertEq(c.soladyDivWad(0, 1), 0);
        assertEq(c.solmateDivWad(0, 1), 0);
        
        // Test y = 1 (should return x * WAD)
        assertEq(c.soladyDivWad(1, 1), 1e18);
        assertEq(c.solmateDivWad(1, 1), 1e18);
        
        // Test x = y (should return WAD)
        assertEq(c.soladyDivWad(123, 123), 1e18);
        assertEq(c.solmateDivWad(123, 123), 1e18);
        
        // Test fractional result: divWad(x, y) = (x * WAD) / y
        // So divWad(1e18, 2) = (1e18 * 1e18) / 2 = 5e35
        assertEq(c.soladyDivWad(1e18, 2), 5e35); 
        assertEq(c.solmateDivWad(1e18, 2), 5e35);
        
        // For normal fractional result: 1/2 = 0.5 in WAD
        assertEq(c.soladyDivWad(1, 2), 5e17);
        assertEq(c.solmateDivWad(1, 2), 5e17);
    }

    // Test revert conditions
    function test_RevertWhen_DivWadZeroDenominator() public {
        vm.expectRevert();
        c.soladyDivWad(1, 0);
        
        vm.expectRevert();
        c.solmateDivWad(1, 0);
    }

    function test_RevertWhen_DivWadOverflow() public {
        vm.expectRevert();
        c.soladyDivWad(type(uint256).max, 1);
        
        vm.expectRevert();
        c.solmateDivWad(type(uint256).max, 1);
    }
}