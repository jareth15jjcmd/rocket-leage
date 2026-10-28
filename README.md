# Turbo Arena 3D

A fresh Godot 4 vehicle-soccer prototype. This repository is separate from the Nerf Blaster Arena project.

## Current prototype
- Procedurally built 3D arena with blue and orange ends
- Physics-based car body and ball
- Acceleration, reverse, steering, jump input, and boost logic
- Chase camera and score/time HUD
- Goal detection and kickoff reset

## Controls
- **W / Up Arrow:** accelerate
- **S / Down Arrow:** reverse
- **A / Left Arrow:** steer left
- **D / Right Arrow:** steer right
- **Space:** jump
- **Shift:** boost

## Run it
1. Install Godot 4.x from https://godotengine.org/download/.
2. Download this repository as a ZIP and extract it.
3. In Godot, choose Import and select the folder containing project.godot.
4. Press F5 to run the project.

## Important status
This is an early prototype framework, not a finished Rocket League clone. It has not yet been verified in the Godot editor. The current version is single-player. Online multiplayer, replicated physics, proper curved arena walls, polished car handling, boost pads, audio, and menus are still planned.

## Roadmap
1. Test and tune the vehicle physics.
2. Add a second local or AI car and reliable round flow.
3. Add multiplayer session creation and synchronized ball physics.
4. Improve arena geometry, effects, sound, and menus.
