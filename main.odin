package main

import "core:fmt"
import b2 "vendor:box2d"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1900, 1000, "My game")
	rl.SetWindowState(rl.ConfigFlags{rl.ConfigFlag.WINDOW_RESIZABLE})

	defer rl.CloseWindow()

	b2.SetLengthUnitsPerMeter(256)
	rl.SetTargetFPS(144)

	// --- Mundo ---------
	world_def := b2.DefaultWorldDef()
	world_def.gravity = b2.Vec2{0, -9.8}
	world_id := b2.CreateWorld(world_def)
	defer b2.DestroyWorld(world_id)

	// --- Chão ----------
	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{0, 900}
	ground_id := b2.CreateBody(world_id, ground_body_def)
	ground_box := b2.MakeBox(20.0, 20.0)
	ground_shape_def := b2.DefaultShapeDef()
	_ = b2.CreatePolygonShape(ground_id, ground_shape_def, ground_box)

	// --- Corpo ----------
	body_def := b2.DefaultBodyDef()
	body_def.type = .dynamicBody
	body_def.position = {500, 200}
	body_id := b2.CreateBody(world_id, body_def)
	body_box := b2.MakeBox(1.0, 1.0)
	body_shape_def := b2.DefaultShapeDef()
	body_shape_def.density = 1
	body_shape_def.friction = 0.
	_ = b2.CreatePolygonShape(body_id, body_shape_def, body_box)

	dt: f32 = 1.0 / 144.0

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		b2.World_Step(world_id, dt, 4)
		ground_position := b2.Body_GetPosition(ground_id)

		body_position := b2.Body_GetPosition(body_id)

		rl.DrawRectangle(i32(ground_position[0]), i32(ground_position[1]), 2000, 200, rl.BLUE)

		rl.DrawRectangle(i32(body_position[0]), i32(body_position[1]), 100, 100, rl.RED)

		rl.ClearBackground(rl.SKYBLUE)

		rl.EndDrawing()
	}
}
