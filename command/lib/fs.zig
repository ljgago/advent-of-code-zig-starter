const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn saveFile(filename: []const u8, content: []const u8) !void {
    const GREEN = "\x1b[32m";
    const YELLOW = "\x1b[33m";
    const RESET = "\x1b[0m";

    // If file is already present, do nothing
    if (std.fs.cwd().access(filename, .{})) |_| {
        std.debug.print("{s}* ignoring{s} {s} already exists\n", .{ YELLOW, RESET, filename });
    } else |_| {

        // create new file
        const dir = try std.fs.cwd().makeOpenPath(
            std.fs.path.dirname(filename).?,
            .{},
        );

        const file = try dir.createFile(std.fs.path.basename(filename), .{});
        defer file.close();

        try file.writeAll(content);
        std.debug.print("{s}* creating{s} {s}\n", .{ GREEN, RESET, filename });
    }
}
