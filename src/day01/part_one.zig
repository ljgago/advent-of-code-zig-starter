//! --- Day 1: Part One ---

const std = @import("std");
const Allocator = std.mem.Allocator;

// -----------------------
// --- Part One: Solve ---
// -----------------------

pub fn solve(alloc: Allocator, comptime input: []const u8) !i32 {
    _ = alloc;
    _ = input;

    return 0;
}

// ----------------------
// --- Part One: Test ---
// ----------------------

test "day01: solve" {
    const testing = std.testing;
    const alloc = testing.allocator;

    const input = "0";
    const result = try solve(alloc, input);
    try testing.expectEqual(0, result);
}
