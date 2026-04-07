---
name: game-audio
description: Use when writing a sound design brief, planning music direction, or building the audio systems specification for a game
---

# Game Audio

## When to Use
When defining audio direction for a game — music, sound effects, and audio systems.

## Core Jobs

### 1. Audio Direction Brief
Define the audio identity of the game:
- **Genre reference**: "Dark Souls meets No Man's Sky — orchestral tension with ambient electronic elements"
- **Emotional targets per zone**: dungeon (dread, tension), village (warmth, safety), boss (epic, urgency)
- **Instrumentation palette**: live orchestra? synth? folk instruments? hybrid?
- **Reference tracks**: 3–5 existing tracks that capture the target feel per zone

### 2. Music System Design
Types of music integration:
- **Linear**: pre-composed tracks, play and loop (simple, less reactive)
- **Vertical layering**: single track with stems that fade in/out based on game state
  - Example: combat enters → percussion stem adds; enemy defeated → fade back to ambient
- **Horizontal re-sequencing**: different sections that transition based on state (Wwise adaptive music)
- **Procedural**: generated music (rare — used in No Man's Sky, some roguelites)

Define per area: which system, what states trigger transitions, how transitions work (crossfade, stinger, instant).

### 3. Sound Effects Specification
For each significant mechanic:
- Action trigger (what causes the sound?)
- Emotional intent (what should the player feel?)
- Audio character (short/long, high/low, synthetic/organic)
- Priority level (what gets ducked if audio budget is full?)

Critical sounds: weapon impact, footsteps on surfaces, UI feedback, damage received, death.

### 4. Technical Audio Budget
Per platform:
- Simultaneous voices: how many sounds at once? (mobile: 16–32, console: 64–128)
- Memory budget for loaded assets
- Streaming vs loaded: music streams, frequent SFX loaded into RAM

## Key Outputs
- Audio direction brief
- Music system design document
- SFX specification per mechanic
- Technical audio budget

## Anti-Patterns
- Music that doesn't change between combat and exploration
- Generic placeholder audio that ships ("we'll replace it later")
- No audio budget planning until console cert fails
- SFX designed without considering the emotional context
