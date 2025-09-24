//! --- Day 1: Part Two ---

const std = @import("std");
const Allocator = std.mem.Allocator;

// -----------------------
// --- Part Two: Solve ---
// -----------------------

pub fn solve(alloc: Allocator, input: []const u8) !i32 {
    _ = alloc;
    _ = input;

    return 0;
}

// ----------------------
// --- Part Two: Test ---
// ----------------------

test "day01: solve" {
    const testing = std.testing;
    const alloc = testing.allocator;

    const input = "0";
    const result = try solve(alloc, input);
    try testing.expectEqual(0, result);
}