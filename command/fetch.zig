const std = @import("std");
const Allocator = std.mem.Allocator;

const fetcher = @import("lib/fetcher.zig");
const fs = @import("lib/fs.zig");
const time = @import("lib/time.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const session = std.process.getEnvVarOwned(alloc, "AOC_SESSION_TOKEN") catch {
        std.debug.print("error: environment variable AOC_SESSION_TOKEN not found\n", .{});
        return;
    };
    defer alloc.free(session);

    if (session.len == 0) {
        std.debug.print("error: the AOC_SESSION_TOKEN can not to be empty\n", .{});
        return;
    }

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);
    if (args.len != 3) {
        std.debug.print("error: you need expecify a 'year' and 'day': zig build fetch -Dyear=2024 -Dday=1\n", .{});
        return;
    }

    const now = time.getCurrentEST();

    const year = try std.fmt.parseInt(u32, args[1], 10);
    if (year < 2015 or year > now.year) {
        std.debug.print("error: you need expecify a year [2015 to {d}]\n", .{now.year});
        return;
    }

    const day = try std.fmt.parseInt(u32, args[2], 10);
    if (day < 1 or day > 25) {
        std.debug.print("error: you need expecify a day [1 to 25]\n", .{});
        return;
    }

    std.debug.print("Advent of Code {d}\n", .{year});

    try generatePuzzle(alloc, year, day, session);
    defer alloc.free(session);
}

fn generatePuzzle(alloc: Allocator, year: u32, day: u32, session: []const u8) !void {
    const filename = try std.fmt.allocPrint(alloc, "src/day{:0>2}/puzzle.txt", .{day});
    defer alloc.free(filename);

    const puzzle = try fetcher.fetchPuzzle(alloc, year, day, session);
    defer puzzle.deinit();

    if (puzzle.status != .ok) {
        const RED = "\x1b[31m";
        const RESET = "\x1b[0m";
        const body = std.mem.trim(u8, puzzle.body, "\n");

        std.debug.print("{s}* error {s} {s}\n", .{ RED, RESET, body });

        return;
    }

    try fs.saveFile(filename, puzzle.body);
}
