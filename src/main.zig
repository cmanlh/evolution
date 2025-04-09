const rl = @import("raylib");
const std = @import("std");
const Setting = @import("setting.zig");
const Cell = @import("cell.zig");

pub fn main() anyerror!void {
    rl.initWindow(@intFromFloat(Setting.ScreenWidth), @intFromFloat(Setting.ScreenHeight), "Evolution");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var prng = std.Random.DefaultPrng.init(@intCast(std.time.timestamp()));
    const random = prng.random();

    var t = Cell.Init(320, 160, 15, Setting.FetchRndColor(&random), &random);
    // Main game loop
    while (!rl.windowShouldClose()) {
        t.DoAction();

        rl.beginDrawing();

        rl.clearBackground(.white);
        t.Draw();

        const mouse_position = rl.getMousePosition();
        rl.drawText(rl.textFormat("%d", .{@as(u8, @intFromBool(t.IsInside(mouse_position.x, mouse_position.y)))}), 480, 360, 20, rl.Color.red);

        rl.endDrawing();
    }
}
