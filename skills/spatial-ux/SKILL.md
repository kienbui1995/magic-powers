---
name: spatial-ux
description: Use when designing 3D layouts, applying depth cues, planning spatial hierarchies, or ensuring user comfort in spatial experiences
---

# Spatial UX

## When to Use
When designing the spatial organization of content, navigation, or interaction in a 3D environment.

## Core Jobs

### 1. Spatial Hierarchy
Establish importance through space:
- **Proximity**: close = relevant, far = background
- **Scale**: larger = more important (use carefully — very large objects in AR can feel threatening)
- **Height**: eye level = primary, above = secondary, below = tertiary
- **Depth order**: foreground vs background as organizational principle

### 2. Depth Cues for Clarity
Human depth perception cues to leverage:
- **Occlusion**: objects in front block objects behind (strong depth cue)
- **Perspective foreshortening**: farther objects appear smaller
- **Atmospheric perspective**: subtle blur/haze on distant objects
- **Drop shadows**: helps objects read as floating vs embedded in world
- **Motion parallax**: objects at different depths move differently with head movement

### 3. Navigation Design
In spatial environments:
- Teleportation (VR): reduces motion sickness, but loses sense of scale
- Smooth locomotion (VR): immersive, causes sickness for some users — offer both
- Physical movement (AR/MR): user walks naturally — design for walkable spaces
- Waypoints and maps: spatial environments need orientation aids (landmarks, minimap)

### 4. Environmental Storytelling Through Space
- Use lighting to direct attention (bright = look here)
- Use sound spatially (audio cue from the direction of important events)
- Negative space as breathing room — don't fill every cubic meter

## Key Outputs
- Spatial hierarchy diagram
- Depth cue specification
- Navigation design (locomotion approach)
- Environmental UX guidelines

## Anti-Patterns
- Flat 2D thinking applied to 3D space (all elements at same Z depth)
- No waypoints in large environments (users get lost)
- Only smooth locomotion in VR (excludes users with motion sensitivity)
- Overloading spatial cues (too many competing visual signals)
