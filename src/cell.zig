const std = @import("std");
const rl = @import("raylib");
const math = std.math;

pub const Cell = @This();

x: f32,
y: f32,
radius: f32,
color: *const rl.Color,

pub fn Init(x: f32, y: f32, radius: f32, color: *const rl.Color) @This() {
    return @This(){
        .x = x,
        .y = y,
        .radius = radius,
        .color = color,
    };
}

pub fn IsInside(self: *const @This(), x: f32, y: f32) bool {
    return self.radius >= math.pow(f32, (self.x - x) * (self.x - x) + (self.y - y) * (self.y - y), 0.5);
}

const SegmentAngle: f32 = 15.0;
const CircleSize: f32 = 360.0;
pub fn Draw(self: *const @This()) void {
    rl.gl.rlBegin(rl.gl.rl_triangles);
    rl.gl.rlColor4ub(self.color.r, self.color.g, self.color.b, self.color.a);
    var angle: f32 = 0.0;
    var delta: f32 = 0.0;
    var startX: f32 = self.x + math.cos(0.0) * self.radius;
    var startY: f32 = self.y + math.sin(0.0) * self.radius;
    var endX: f32 = 0.0;
    var endY: f32 = 0.0;
    var notDone = true;
    while (notDone) {
        delta = angle + SegmentAngle;
        if (delta > CircleSize) {
            delta = CircleSize;
            notDone = false;
        }
        endX = self.x + math.cos(math.rad_per_deg * delta) * self.radius;
        endY = self.y + math.sin(math.rad_per_deg * delta) * self.radius;

        rl.gl.rlVertex2f(self.x, self.y);
        rl.gl.rlVertex2f(endX, endY);
        rl.gl.rlVertex2f(startX, startY);

        startX = endX;
        startY = endY;
        angle += SegmentAngle;
    }
    rl.gl.rlEnd();
}
