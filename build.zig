const std = @import("std");
const Allocator = std.mem.Allocator;

const time = @import("command/lib/time.zig");

pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const now = time.getCurrentEST();
    const year_args = b.option([]const u8, "year", "The year of the Advent of Code challenge") orelse b.fmt("{d}", .{now.year});
    const day_args = b.option([]const u8, "day", "The day of the Advent of Code challenge") orelse b.fmt("{d}", .{now.day});

    // Generate command
    const generate_exe = b.addExecutable(.{
        .name = "generate",
        .root_module = b.createModule(.{
            .root_source_file = b.path("command/generate.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const generate_step = b.step("generate", "Generate files with a specific day");
    const generate_cmd = b.addRunArtifact(generate_exe);
    generate_cmd.addArgs(&.{ year_args, day_args });
    generate_step.dependOn(&generate_cmd.step);

    // Fetch command
    const fetch_exe = b.addExecutable(.{
        .name = "fetch",
        .root_module = b.createModule(.{
            .root_source_file = b.path("command/fetch.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const fetch_step = b.step("fetch", "Fetch puzzle with year and day");
    const fetch_cmd = b.addRunArtifact(fetch_exe);
    fetch_cmd.addArgs(&.{ year_args, day_args });
    fetch_step.dependOn(&fetch_cmd.step);

    for (1..26) |day| {
        const day_name = b.fmt("day{:0>2}", .{day});
        const part_one_name = "part_one";
        const part_two_name = "part_two";

        const main_path = b.fmt("src/{s}/main.zig", .{day_name});
        const part_one_path = b.fmt("src/{s}/{s}.zig", .{ day_name, part_one_name });
        const part_two_path = b.fmt("src/{s}/{s}.zig", .{ day_name, part_two_name });

        const exe = b.addExecutable(.{
            .name = day_name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(main_path),
                .target = target,
                .optimize = optimize,
            }),
        });

        const part_one_test = b.addTest(.{
            .name = b.fmt("{s} {s}", .{ day_name, part_one_name }),
            .root_module = b.createModule(.{
                .root_source_file = b.path(part_one_path),
                .target = target,
                .optimize = optimize,
            }),
        });

        const part_two_test = b.addTest(.{
            .name = b.fmt("{s} {s}", .{ day_name, part_two_name }),
            .root_module = b.createModule(.{
                .root_source_file = b.path(part_two_path),
                .target = target,
                .optimize = optimize,
            }),
        });

        // Add the run steps
        const run_step = b.step(b.fmt("{s}-run", .{day_name}), b.fmt("Run the {s}", .{day_name}));
        const run_cmd = b.addRunArtifact(exe);
        run_step.dependOn(&run_cmd.step);

        // Add the test steps
        const test_step = b.step(b.fmt("{s}-test", .{day_name}), b.fmt("Test the {s}", .{day_name}));
        const part_one_cmd = b.addRunArtifact(part_one_test);
        const part_two_cmd = b.addRunArtifact(part_two_test);
        test_step.dependOn(&part_one_cmd.step);
        test_step.dependOn(&part_two_cmd.step);

        // Add the install steps
        const install_step = b.step(b.fmt("{s}-install", .{day_name}), b.fmt("Install the {s} in zig-out/bin", .{day_name}));
        const install_cmd = b.addInstallArtifact(exe, .{});
        install_step.dependOn(&install_cmd.step);
    }
}
