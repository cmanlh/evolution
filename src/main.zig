const rl = @import("raylib");
const std = @import("std");
const Cell = @import("cell.zig");

pub fn main() anyerror!void {

    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Evolution");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        var t = Cell.Init(450, 320, 15, &rl.Color.red);
        t.Draw();

        const mouse_position = rl.getMousePosition();
        rl.drawText(rl.textFormat("%d", .{@as(u8, @intFromBool(t.IsInside(mouse_position.x, mouse_position.y)))}), 480, 360, 20, rl.Color.red);
        //----------------------------------------------------------------------------------
    }
}
