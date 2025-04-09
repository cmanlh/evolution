const std = @import("std");
const Random = std.Random;
const rl = @import("raylib");
const Color = rl.Color;

pub const ScreenWidth: f32 = 800.0;
pub const ScreenHeight: f32 = 480.0;

pub const MoveSpeedMin: f32 = 15.0;
pub const MoveSpeedMax: f32 = 35.0;

pub fn FetchRndColor(rand: *const Random) *const Color {
    return PickableColor[rand.intRangeAtMost(usize, 0, PickableColor.len - 1)];
}
const PickableColor = [_]*const Color{ &Color.yellow, &Color.violet, &Color.sky_blue, &Color.red };
