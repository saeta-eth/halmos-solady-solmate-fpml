# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a differential verification project using Halmos (symbolic bounded model checker) to verify mathematical equivalence between Solady and Solmate FixedPointMathLib implementations.

## Key Commands

### Testing Commands

#### Equivalence Testing (Halmos)

- `halmos --function testCheck__SqrtStrippedEquivalence` - Symbolic test of sqrt stripped estimation logic equivalence
- `halmos --function testCheck__MulWadEquivalence` - Symbolic test of mulWad equivalence
- `halmos --function testCheck__MulWadUpEquivalence` - Symbolic test of mulWadUp equivalence
- `halmos --function testCheck__DivWadEquivalence` - Symbolic test of divWad equivalence
- `halmos --function testCheck__DivWadUpEquivalence` - Symbolic test of divWadUp equivalence
- `halmos --function testCheck__MulDivDownEquivalence` - Symbolic test of mulDivDown equivalence
- `halmos --function testCheck__MulDivUpEquivalence` - Symbolic test of mulDivUp equivalence
- `halmos --function testCheck__RpowEquivalence` - Symbolic test of rpow equivalence
- `halmos --function testCheck__UnsafeModEquivalence` - Symbolic test of unsafeMod vs rawMod equivalence
- `halmos --function testCheck__UnsafeDivEquivalence` - Symbolic test of unsafeDiv vs rawDiv equivalence

#### Edge Case Testing (Foundry)

- `forge test --match-test test__SqrtEdgeCases` - Test sqrt edge cases
- `forge test --match-test test__SqrtWadEdgeCases` - Test sqrtWad edge cases (Solady only)
- `forge test --match-test test__PowWadEdgeCases` - Test powWad edge cases (Solady only)
- `forge test --match-test test__UnsafeOpsEdgeCases` - Test unsafe operations edge cases

#### Comprehensive Testing

- `forge test` - Run all Foundry tests (46 tests, 500K+ fuzz runs per equivalence test)

### Build Commands

- `forge build` - Build the project
- `forge test` - Run all Foundry tests

## Architecture

### Directory Structure

- `src/functions/` - Individual function implementations (Sqrt.sol, MulWad.sol, DivWad.sol, MulDivDown.sol, MulDivUp.sol, PowWad.sol, Rpow.sol, SqrtWad.sol, UnsafeOps.sol, etc.)
- `test/` - Test contracts, some for Foundry fuzzing, others for Halmos verification

### Verification Strategy

Functions are broken into separate contracts due to Halmos deployment size limitations. Three verification approaches are used:

1. **Equivalence verification** - Prove equivalence between Solady and Solmate implementations (e.g., sqrt, mulWad, divWad)
2. **Stripped function analysis** - Focus verification on algorithmic differences by abstracting out identical code sections (e.g., sqrt stripped versions)
3. **Edge case testing** - Comprehensive testing for Solady-only functions with no Solmate equivalents (e.g., powWad, sqrtWad)

### Key Implementation Details

- Functions are split between optimized Solady versions and Solmate reference implementations
- Some functions use "stripped" versions that abstract out identical code sections to focus on algorithmic differences
- Tests include both symbolic (Halmos) and fuzz (Foundry)
- Modern test patterns using `bound()` for input constraints and `test_RevertWhen_*` for revert testing
- Cross-library equivalence mapping (Solmate unsafe* ↔ Solady raw* operations)

## Verification Status

All implemented functions have been successfully verified:

- ✅ sqrt - Equivalence verified via both full and stripped versions (stripped versions focus on estimation logic differences)
- ✅ mulWad - Equivalence between Solady and Solmate implementations proven
- ✅ mulWadUp - Correctness via fuzzing, equivalence via symbolic testing
- ✅ divWad - Equivalence via symbolic testing with overflow-safe input bounds
- ✅ divWadUp - Equivalence via symbolic testing with overflow-safe input bounds
- ✅ mulDivDown - Equivalence via symbolic testing with uint128 input bounds
- ✅ mulDivUp - Equivalence via symbolic testing with uint128 input bounds
- ✅ rpow - Equivalence via symbolic testing with carefully bounded inputs
- ✅ powWad - Edge case testing for correctness (Solady only, no Solmate equivalent)
- ✅ sqrtWad - Edge case testing for correctness (Solady only, no Solmate equivalent)
- ✅ unsafeOps - Equivalence verified between Solmate unsafe operations and Solady raw operations (unsafeMod↔rawMod, unsafeDiv↔rawDiv)

**Note**: powWad and sqrtWad are Solady-only functions, so they are tested for correctness via comprehensive edge case testing rather than cross-library equivalence verification.

## Key Testing Innovations

- **Stripped Function Analysis**: Abstract out identical code to focus verification on algorithmic differences
- **Cross-Library Mapping**: Maps equivalent functions between Solmate and Solady (unsafe* ↔ raw*)
- **Overflow Prevention**: Careful input bounding prevents arithmetic overflow during testing
- **WAD Precision Handling**: Correctly handles 1e18 precision mathematics in edge cases
