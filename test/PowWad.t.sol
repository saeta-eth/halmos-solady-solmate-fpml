// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/PowWad.sol";

// PowWad testing - Note: Only Solady has powWad, Solmate doesn't
// This test verifies Solady's powWad and related functions

// To run:
// - `forge test --match test__PowWadEdgeCases` (test edge cases with concrete values)

contract PowWadTests is Test {
    PowWad c;

    function setUp() public {
        c = new PowWad();
    }

    // Test edge cases with concrete values for Solady-only functions
    function test__PowWadEdgeCases() public {
        // Test powWad: 1^anything = 1
        assertEq(c.soladyPowWad(1e18, 0), 1e18);    // 1^0 = 1
        assertEq(c.soladyPowWad(1e18, 1e18), 1e18); // 1^1 = 1
        assertEq(c.soladyPowWad(1e18, 2e18), 1e18); // 1^2 = 1
        
        // Test expWad: exp(0) = 1
        assertEq(c.soladyExpWad(0), 1e18);
        
        // Test lnWad: ln(e) ≈ 1, ln(1) = 0
        assertEq(c.soladyLnWad(1e18), 0); // ln(1) = 0
        
        // Test with small positive values to avoid overflow
        int256 result = c.soladyExpWad(1e18); // exp(1) ≈ e ≈ 2.718
        assertGt(result, 2e18); // Should be > 2
        assertLt(result, 3e18); // Should be < 3
    }

    // Test lambertW0Wad with safe inputs
    function test__LambertW0WadEdgeCases() public {
        // W(0) = 0
        assertEq(c.soladyLambertW0Wad(0), 0);
        
        // Test with small positive values
        int256 result = c.soladyLambertW0Wad(1e17); // W(0.1)
        assertGt(result, 0); // Should be positive
        assertLt(result, 1e17); // Should be less than input for small values
    }

    // Test that functions handle expected revert conditions
    function test_RevertWhen_LnWadNegative() public {
        vm.expectRevert();
        c.soladyLnWad(-1);
    }

    function test_RevertWhen_LambertW0WadTooNegative() public {
        // Should revert for x < -1/e
        vm.expectRevert();
        c.soladyLambertW0Wad(-4e17); // Less than -1/e ≈ -0.368
    }
}