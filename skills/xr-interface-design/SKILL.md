---
name: xr-interface-design
description: Use when designing for XR (AR/VR/MR), choosing interaction modes, or adapting 2D UI patterns for spatial computing
---

# XR Interface Design

## When to Use
When building user interfaces for augmented reality, virtual reality, or mixed reality experiences.

## Core Jobs

### 1. Input Modality Selection
Choose the right input for each interaction:
| Modality | Use When | Avoid When |
|----------|---------|-----------|
| Gaze + dwell | Hands occupied, accessibility | Fast interactions (too slow) |
| Hand tracking | Natural, markerless | Precise targets < 2cm |
| Controller | Precision, gaming | Markerless consumer AR |
| Voice | Quick commands, eyes-free | Noisy environments, private |
| Spatial tap (visionOS) | Natural selection | Complex gestures |

Prefer direct manipulation (touch the thing) over raycast menus where possible.

### 2. Spatial UI Placement
- **Arm's length zone** (0.5–2m): optimal for readable, interactive UI
- **Too close** (< 0.5m): causes eye strain, uncomfortable
- **Too far** (> 3m): hard to read, hard to interact with
- **World-locked**: UI stays in the world (good for contextual info)
- **Head-locked**: UI follows the user (use sparingly — causes motion sickness)
- **Body-locked**: locked to body position but not rotation (good compromise)

### 3. Comfort Guidelines
- No interaction requiring sustained arm elevation (gorilla arm fatigue)
- Minimum interaction target size: 2cm × 2cm at interaction distance
- Depth conflicts: avoid placing UI that competes visually with real world objects in AR
- Frame rate: VR must target 72fps minimum (90fps preferred); drops cause motion sickness

### 4. Adapt 2D Patterns for 3D
- Replace dropdown menus with radial menus or spatial panels
- Replace hover states with proximity highlight (gaze or hand approach)
- Replace modals with spatial overlays that don't block the world
- Depth cue for hierarchy: closer elements = foreground = more important

## Key Outputs
- Input modality map (what triggers what)
- Spatial placement spec
- Comfort review checklist
- 2D to 3D adaptation guide

## Anti-Patterns
- Porting 2D UI directly into 3D space (flat UI panels floating in space)
- Head-locked menus for anything other than critical HUD
- Interaction targets below minimum size
- No affordance for the interaction mode (users don't know what's interactive)
