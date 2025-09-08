const std = @import("std");
const Allocator = std.mem.Allocator;

const Puzzle = struct {
    allocator: Allocator,
    status: std.http.Status,
    body: []const u8,

    pub fn deinit(self: Puzzle) void {
        self.allocator.free(self.body);
    }
};

pub fn fetchPuzzle(alloc: Allocator, year: u32, day: u32, session: []const u8) !Puzzle {
    var client = std.http.Client{ .allocator = alloc };
    defer client.deinit();

    const url = try std.fmt.allocPrint(alloc, "https://adventofcode.com/{d}/day/{d}/input", .{ year, day });
    defer alloc.free(url);

    var response_body = std.io.Writer.Allocating.init(alloc);
    defer response_body.deinit();

    const session_value = try std.fmt.allocPrint(alloc, "session={s}", .{session});
    defer alloc.free(session_value);

    const result = try client.fetch(.{
        .method = .GET,
        .location = .{ .url = url },
        .extra_headers = &.{
            .{ .name = "cookie", .value = session_value },
        },
        .response_writer = &response_body.writer,
    });

    const body = try response_body.toOwnedSlice();

    return Puzzle{
        .allocator = alloc,
        .status = result.status,
        .body = body,
    };
}
