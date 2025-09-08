//! --- Parser ---

const std = @import("std");
const Allocator = std.mem.Allocator;

// ---------------------
// --- Parser: Parse ---
// ---------------------

pub fn parse(alloc: Allocator, comptime input: []const u8) !i32 {
    _ = alloc;

    const result = std.mem.trim(u8, input, "\n");

    return try std.fmt.parseInt(i32, result, 10);
}

// --------------------
// --- Parser: Test ---
// --------------------

test "day01: parser" {
    const testing = std.testing;
    const alloc = testing.allocator;

    const input = "0\n";
    const result = try parse(alloc, input);
    try testing.expectEqual(0, result);
}
