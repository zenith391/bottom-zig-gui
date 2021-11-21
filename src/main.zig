const std = @import("std");
const zgt = @import("zgt");
pub usingnamespace zgt.cross_platform;

pub fn main() !void {
    try zgt.backend.init();

    var window = try zgt.Window.init();
    try window.set(
        zgt.Button(.{ .label = "Test" })
    );
    
    window.resize(800, 600);
    window.show();

    zgt.runEventLoop();
}
