const std = @import("std");

pub fn main() !void {
    //Alloc
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    //Getting args
    const args = try std.process.argsAlloc(allocator);

    //Proc args
    if (args.len != 3 or args[1][0] != '-') {
        std.debug.print("Wrong args", .{});
        return;
    }

    const path1 = args[2];
    const ext: []u8 = getExt(args[1][1]);

    if (ext[0] == 'I') {
        std.debug.print("Invalid Format", .{});
        return;
    }

    var dotPoint: u8 = 0;
    for (path1, 0..) |char, i| {
        if (char == '.') {
            dotPoint = @intCast(i);
            break;
        }
    }

    if (dotPoint == 0) {
        std.debug.print("Invalid File Name", .{});
        return;
    }

    var path2: [20]u8 = undefined;
    var istart: u8 = 0;
    for (istart..dotPoint) |i| {
        path2[i] = path1[i];
    }
    path2[dotPoint] = '.';
    istart = dotPoint + 1;
    for (ext) |char| {
        path2[istart] = char;
        istart += 1;
    }
    for (istart..20) |i| {
        path2[i] = 1;
    }
    std.debug.print("{s}", .{path2});
}
pub fn getExt(args: u8) []u8 {
    return @constCast(switch (args) {
        't' => "txt",
        'p' => "png",
        else => "Invalid",
    });
}
