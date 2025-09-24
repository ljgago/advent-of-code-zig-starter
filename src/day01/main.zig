//! --- Advent of Code: Day 1 ---

const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const part_one = @import("part_one.zig");
const part_two = @import("part_two.zig");

const puzzle = @embedFile("puzzle.txt");

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    //var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    //defer arena.deinit();
    //const alloc = arena.allocator();

    print("--- Part One ---\n", .{});
    print("Result: {any}\n", .{try part_one.solve(alloc, puzzle)});

    print("--- Part Two ---\n", .{});
    print("Result: {any}\n", .{try part_two.solve(alloc, puzzle)});
}