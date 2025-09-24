//! Generates the files
//!
//! Used with the build system:
//!   $ zig build generate -Dyear=2024 -Dday=1
//!

const std = @import("std");
const Allocator = std.mem.Allocator;

const fetcher = @import("lib/fetcher.zig");
const fs = @import("lib/fs.zig");
const time = @import("lib/time.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    const now = time.getCurrentEST();

    const year = try std.fmt.parseInt(u32, args[1], 10);
    if (year < 2015 or year > now.year) {
        std.debug.print("error: you need expecify a year within the range [2015 to {d}]\n", .{now.year});
        return;
    }

    const day = try std.fmt.parseInt(u32, args[2], 10);
    if (day < 1 or day > 25) {
        std.debug.print("error: you need expecify a day [1 to 25]\n", .{});
        return;
    }

    std.debug.print("Advent of Code {d}\n", .{year});

    try generateFiles(alloc, day);

    if (std.process.getEnvVarOwned(alloc, "AOC_SESSION_TOKEN")) |session| {
        // if AOC_SESSION_TOKEN is available generate the puzzle
        try generatePuzzle(alloc, year, day, session);
        defer alloc.free(session);
    } else |_| {}
}

const MAIN_TEMPLATE =
    \\//! --- Advent of Code: Day {{day}} ---
    \\
    \\const std = @import("std");
    \\const print = std.debug.print;
    \\const Allocator = std.mem.Allocator;
    \\
    \\const part_one = @import("part_one.zig");
    \\const part_two = @import("part_two.zig");
    \\
    \\const puzzle = @embedFile("puzzle.txt");
    \\
    \\pub fn main() !void {
    \\    var gpa: std.heap.DebugAllocator(.{}) = .init;
    \\    defer _ = gpa.deinit();
    \\    const alloc = gpa.allocator();
    \\
    \\    //var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    \\    //defer arena.deinit();
    \\    //const alloc = arena.allocator();
    \\
    \\    print("--- Part One ---\n", .{});
    \\    print("Result: {any}\n", .{try part_one.solve(alloc, puzzle)});
    \\
    \\    print("--- Part Two ---\n", .{});
    \\    print("Result: {any}\n", .{try part_two.solve(alloc, puzzle)});
    \\}
;

const PART_ONE_TEMPLATE =
    \\//! --- Day {{day}}: Part One ---
    \\
    \\const std = @import("std");
    \\const Allocator = std.mem.Allocator;
    \\
    \\// -----------------------
    \\// --- Part One: Solve ---
    \\// -----------------------
    \\
    \\pub fn solve(alloc: Allocator, input: []const u8) !i32 {
    \\    _ = alloc;
    \\    _ = input;
    \\
    \\    return 0;
    \\}
    \\
    \\// ----------------------
    \\// --- Part One: Test ---
    \\// ----------------------
    \\
    \\test "day{{day_full}}: solve" {
    \\    const testing = std.testing;
    \\    const alloc = testing.allocator;
    \\
    \\    const input = "0";
    \\    const result = try solve(alloc, input);
    \\    try testing.expectEqual(0, result);
    \\}
;

const PART_TWO_TEMPLATE =
    \\//! --- Day {{day}}: Part Two ---
    \\
    \\const std = @import("std");
    \\const Allocator = std.mem.Allocator;
    \\
    \\// -----------------------
    \\// --- Part Two: Solve ---
    \\// -----------------------
    \\
    \\pub fn solve(alloc: Allocator, input: []const u8) !i32 {
    \\    _ = alloc;
    \\    _ = input;
    \\
    \\    return 0;
    \\}
    \\
    \\// ----------------------
    \\// --- Part Two: Test ---
    \\// ----------------------
    \\
    \\test "day{{day_full}}: solve" {
    \\    const testing = std.testing;
    \\    const alloc = testing.allocator;
    \\
    \\    const input = "0";
    \\    const result = try solve(alloc, input);
    \\    try testing.expectEqual(0, result);
    \\}
;

const PARSER_TEMPLATE =
    \\//! --- Day {{day}}: Parser ---
    \\
    \\const std = @import("std");
    \\const Allocator = std.mem.Allocator;
    \\
    \\// ---------------------
    \\// --- Parser: Parse ---
    \\// ---------------------
    \\
    \\pub fn parse(alloc: Allocator, input: []const u8) !i32 {
    \\    _ = alloc;
    \\
    \\    const result = std.mem.trim(u8, input, "\n");
    \\
    \\    return try std.fmt.parseInt(i32, result, 10);
    \\}
    \\
    \\// --------------------
    \\// --- Parser: Test ---
    \\// --------------------
    \\
    \\test "day{{day_full}}: parser" {
    \\    const testing = std.testing;
    \\    const alloc = testing.allocator;
    \\
    \\    const input = "0\n";
    \\    const result = try parse(alloc, input);
    \\    try testing.expectEqual(0, result);
    \\}
;

const README_TEMPLATE =
    \\# Advent of Code: Day {{day}}
    \\
    \\## Part One
    \\
    \\TODO: Content
    \\
    \\## Part Two
    \\
    \\TODO: Content
    \\
    \\
;

fn generateFiles(alloc: Allocator, day: u32) !void {
    const filenames = &[_][]const u8{
        try std.fmt.allocPrint(alloc, "src/day{:0>2}/main.zig", .{day}),
        try std.fmt.allocPrint(alloc, "src/day{:0>2}/part_one.zig", .{day}),
        try std.fmt.allocPrint(alloc, "src/day{:0>2}/part_two.zig", .{day}),
        try std.fmt.allocPrint(alloc, "src/day{:0>2}/parser.zig", .{day}),
        try std.fmt.allocPrint(alloc, "src/day{:0>2}/README.md", .{day}),
    };

    const templates = [_][]const u8{
        MAIN_TEMPLATE,
        PART_ONE_TEMPLATE,
        PART_TWO_TEMPLATE,
        PARSER_TEMPLATE,
        README_TEMPLATE,
    };

    for (filenames, templates) |filename, template| {
        const parsed_template = try parse_template(alloc, template, day);
        defer alloc.free(parsed_template);

        try fs.saveFile(filename, parsed_template);
        defer alloc.free(filename);
    }
}

fn generatePuzzle(alloc: Allocator, year: u32, day: u32, session: []const u8) !void {
    const filename = try std.fmt.allocPrint(alloc, "src/day{:0>2}/puzzle.txt", .{day});
    defer alloc.free(filename);

    const puzzle = try fetcher.fetchPuzzle(alloc, year, day, session);
    defer puzzle.deinit();

    if (puzzle.status != .ok) {
        const RED = "\x1b[31m";
        const RESET = "\x1b[0m";

        std.debug.print("{s}* error {s} {s}\n", .{ RED, RESET, std.mem.trim(u8, puzzle.body, "\n") });

        return;
    }

    try fs.saveFile(filename, puzzle.body);
}

fn parse_template(alloc: Allocator, template: []const u8, day: u32) ![]const u8 {
    const day_var = try std.fmt.allocPrint(alloc, "{d}", .{day});
    defer alloc.free(day_var);

    const day_full_var = try std.fmt.allocPrint(alloc, "{:0>2}", .{day});
    defer alloc.free(day_full_var);

    const template_step1 = std.mem.replaceOwned(u8, alloc, template, "{{day}}", day_var) catch @panic("out of memory");
    defer alloc.free(template_step1);
    const template_end = std.mem.replaceOwned(u8, alloc, template_step1, "{{day_full}}", day_full_var) catch @panic("out of memory");

    return template_end;
}
