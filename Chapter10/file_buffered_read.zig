const std = @import("std");

// Demonstrates buffered line-by-line reading using a stack buffer.
pub fn main() !void {
    const cwd = std.fs.cwd();

    // Prepare a file with multiple lines
    {
        const f = try cwd.createFile("log.txt", .{});
        defer f.close();
        try f.writeAll("line1\nline2\nline3\n");
    }

    const file = try cwd.openFile("log.txt", .{ .mode = .read_only });
    defer file.close();

    var buf: [4096]u8 = undefined;
    var reader = file.reader(&buf);

    while (try reader.interface.takeDelimiter('\n')) |line| {
        std.debug.print("Line: {s}\n", .{line});
    }
}
