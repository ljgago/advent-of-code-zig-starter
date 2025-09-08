const std = @import("std");
const Allocator = std.mem.Allocator;

const Datetime = struct {
    year: u32 = 0,
    day: u32 = 1,
    month: u32 = 1,
    hour: u32 = 0,
    minute: u32 = 0,
    second: u32 = 0,
};

/// Return the current Eastern Standard Time (UTC-5)
pub fn getCurrentEST() Datetime {
    const offset = 60 * 60 * 5;
    const now_timestamp = std.time.timestamp();
    const now = timestampToDatetime(now_timestamp - offset);

    var default = Datetime{};

    if (now.month < 12) {
        default.year = now.year - 1;
    }

    if (now.month == 12 and now.day < 26) {
        default.year = now.year;
        default.day = now.day;
    }

    return default;
}

pub fn timestampToDatetime(timestamp: i64) Datetime {
    // Constants
    const SECONDS_PER_MINUTE = 60;
    const SECONDS_PER_HOUR = 60 * SECONDS_PER_MINUTE;
    const SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR;

    var seconds: i64 = timestamp;
    var days: i64 = @divFloor(seconds, SECONDS_PER_DAY);
    seconds -= days * SECONDS_PER_DAY;

    // Time
    const hour: i64 = @intCast(@divFloor(seconds, SECONDS_PER_HOUR));
    seconds -= hour * SECONDS_PER_HOUR;
    const minute: i64 = @intCast(@divFloor(seconds, SECONDS_PER_MINUTE));
    seconds -= minute * SECONDS_PER_MINUTE;
    const second: i64 = @intCast(seconds);

    // Date
    var year: i64 = 1970;
    var days_in_year: i64 = undefined;

    while (true) {
        days_in_year = if (isLeapYear(year)) 366 else 365;
        if (days >= days_in_year) {
            days -= days_in_year;
            year += 1;
        } else break;
    }

    const month_lengths = [_]u8{
        31, if (isLeapYear(year)) 29 else 28, 31, 30, 31, 30,
        31, 31,                               30, 31, 30, 31,
    };

    var month: i64 = 1;
    for (month_lengths) |days_in_month| {
        if (days >= days_in_month) {
            days -= days_in_month;
            month += 1;
        } else break;
    }

    const day: i64 = @intCast(days + 1); // 1-based

    return Datetime{
        .year = @intCast(year),
        .month = @intCast(month),
        .day = @intCast(day),
        .hour = @intCast(hour),
        .minute = @intCast(minute),
        .second = @intCast(second),
    };
}

fn isLeapYear(year: i64) bool {
    return (@mod(year, 4) == 0 and @mod(year, 100) != 0) or (@mod(year, 400) == 0);
}

test "datetime from timestamp" {
    const testing = std.testing;

    var result: Datetime = undefined;
    var expected: Datetime = undefined;

    result = Datetime.fromTimestamp(1696143463);
    expected = Datetime{ .year = 2023, .month = 10, .day = 1, .hour = 6, .minute = 57, .second = 43 };
    try testing.expectEqualDeep(expected, result);

    result = Datetime.fromTimestamp(1700839305);
    expected = Datetime{ .year = 2023, .month = 11, .day = 24, .hour = 15, .minute = 21, .second = 45 };
    try testing.expectEqual(expected, result);

    result = Datetime.fromTimestamp(641595527);
    expected = Datetime{ .year = 1990, .month = 5, .day = 1, .hour = 20, .minute = 58, .second = 47 };
    try testing.expectEqual(expected, result);

    result = Datetime.fromTimestamp(1498694833);
    expected = Datetime{ .year = 2017, .month = 6, .day = 29, .hour = 0, .minute = 7, .second = 13 };
    try testing.expectEqual(expected, result);
}
