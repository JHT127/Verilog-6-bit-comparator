# 6-bit Signed/Unsigned Comparator with Synchronization

A Verilog implementation of a 6-bit comparator that supports both signed and unsigned number comparison with register synchronization.

## Features
- Dual-mode operation (signed/unsigned comparison)
- Structural and behavioral implementations
- Synchronous operation with input/output registers
- Comprehensive testbench verifying all combinations
- Gate-level timing annotations

## Modules
1. **comparator_unsigned.v** - 6-bit unsigned comparator (structural)
2. **comparator_signed.v** - 6-bit signed comparator (structural)
3. **comparator_beh.v** - Behavioral implementation
4. **comparator_with_registers.v** - Top-level synchronized design
5. **tb_comparator.v** - Complete testbench
