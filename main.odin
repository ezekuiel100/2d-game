package main

import "core:fmt"
import b2 "vendor:box2d"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(500, 300, "My game")
	rl.SetWindowState(rl.ConfigFlags{rl.ConfigFlag.WINDOW_RESIZABLE})

	defer rl.CloseWindow()

	rl.SetTargetFPS(144)

	// --- Mundo ---------
	world_def := b2.DefaultWorldDef()
	world_def.gravity = b2.Vec2{0, -9.8}
	world_id := b2.CreateWorld(world_def)
	defer b2.DestroyWorld(world_id)

	// --- Chão ----------
	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{0, 250}
	ground_id := b2.CreateBody(world_id, ground_body_def)
	ground_box := b2.MakeBox(20.0, 50.0)
	ground_shape_def := b2.DefaultShapeDef()
	_ = b2.CreatePolygonShape(ground_id, ground_shape_def, ground_box)


	dt: f32 = 1.0 / 144.0

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		b2.World_Step(world_id, dt, 4)
		position := b2.Body_GetPosition(ground_id)

		rl.DrawRectangle(i32(position[0]), i32(position[1]), 400, 400, rl.RED)

		rl.ClearBackground(rl.SKYBLUE)

		rl.EndDrawing()
	}
}
