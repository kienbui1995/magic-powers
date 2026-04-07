---
name: game-design-doc
description: Use when writing a Game Design Document (GDD), defining core mechanics, or planning player loops
---

# Game Design Document

## When to Use
When starting a new game project, aligning team members on what to build, or documenting mechanics for implementation.

## Core Jobs

### 1. Core Concept (1 page)
- **Logline**: one sentence that captures the essence. "A roguelite deck-builder where your deck evolves based on how you play, not what you pick."
- **Genre(s)**: be specific (roguelite, not "action")
- **Target player**: who plays this? ("people who played Hades and want more narrative depth")
- **Core emotion**: what feeling does the player chase? (power fantasy, tension, exploration)
- **Platform and estimated scope**

### 2. Core Loop (the fun part)
The 3 layers:
- **Micro loop** (seconds): what does the player do moment-to-moment?
- **Macro loop** (minutes): what is the session goal?
- **Meta loop** (hours/days): what keeps them coming back?

Write it as actions, not features:
"Player fights → defeats enemy → gains resources → upgrades → faces harder enemy → (repeat)" is good.
"Combat system with progression mechanics" is bad.

### 3. Mechanics Documentation
Per mechanic:
- Name and description
- Player interaction (what does the player do?)
- Rules (exact behavior, edge cases)
- Feel goal (what should it feel like?)
- Implementation notes (for engineers)

### 4. Scope Management
MoSCoW for game design:
- **Must have** (launch): core loop, win/lose conditions, 1 environment, tutorial
- **Should have** (launch): 3 environments, variety, polish
- **Could have** (post-launch): extra modes, community features
- **Won't have** (this version): anything that doesn't serve the core loop

## Key Outputs
- Game concept and logline
- Core loop diagram (3 layers)
- Mechanics documentation
- MoSCoW feature list

## Anti-Patterns
- GDD with no core loop — features without a framework
- Designing features before validating the core loop is fun
- Scope that exceeds team capacity by 3x
- Not playtesting before full implementation
