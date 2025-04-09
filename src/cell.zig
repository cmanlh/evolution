const std = @import("std");
const rl = @import("raylib");
const math = std.math;
const utils = @import("utils.zig");

pub const Cell = @This();

rand: *const std.Random,
x: f32,
y: f32,
radius: f32,
color: *const rl.Color,
move_speed: f32 = -1.0,

// 基因属性
move_normal_speed: f32 = -1.0,
move_acceleration: f32 = -1.0,
move_max_speed: f32 = -1.0,

pub fn Init(x: f32, y: f32, radius: f32, color: *const rl.Color, rand: *const std.Random) @This() {
    return @This(){
        .x = x,
        .y = y,
        .radius = radius,
        .color = color,
        .move_speed = 15.9,
        .rand = rand,
    };
}

pub fn IsInside(self: *const @This(), x: f32, y: f32) bool {
    return self.radius >= math.pow(f32, (self.x - x) * (self.x - x) + (self.y - y) * (self.y - y), 0.5);
}

fn MoveDistance(self: *@This()) f32 {
    const times = rl.getFrameTime();

    const normal_speed = utils.FetchPlusValue(self.move_normal_speed);
    const acceleration = utils.FetchPlusValue(self.move_acceleration);
    const max_speed = utils.FetchPlusValue(self.move_max_speed);

    var distance: f32 = 0.0;
    if (self.move_speed < 0.0) {
        self.move_speed = normal_speed + acceleration * times;
        distance = normal_speed * times + acceleration * times * times;
    } else {
        self.move_speed = self.move_speed + acceleration * times;
        distance = self.move_speed * times + acceleration * times * times;
    }

    if (self.move_max_speed > 0.0 and self.move_speed > max_speed) {
        self.move_speed = self.move_max_speed;
    }

    return distance;
}

fn MoveToPoint(self: *@This(), x: f32, y: f32) void {
    const distance = self.MoveDistance();

    const vector_distance = math.pow(f32, (x - self.x) * (x - self.x) + (y - self.y) * (y - self.y), 0.5);

    self.x = self.x + distance * (x - self.x) * vector_distance;
    self.y = self.y + distance * (y - self.y) * vector_distance;
}

/// 朝下为零度，逆时针旋转为角度增加方向
fn MoveByAngle(self: *@This(), degree: f32) void {
    const distance = self.MoveDistance();
    const radius: f32 = math.rad_per_deg * degree;

    self.x = self.x + distance * math.sin(radius);
    self.y = self.y + distance * math.cos(radius);
}

fn Move(self: *@This()) void {
    self.MoveByAngle(@floatFromInt(self.rand.intRangeAtMost(u32, 0, 360)));
}

pub fn DoAction(self: *@This()) void {
    self.Move();
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
