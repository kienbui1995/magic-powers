---
name: technical-art
description: Use when writing shader briefs, defining performance budgets, creating LOD strategies, or bridging art and engineering
---

# Technical Art

## When to Use
When optimizing a game's visual pipeline, writing briefs for shaders or VFX, or establishing art performance standards.

## Core Jobs

### 1. Performance Budgets
Define per target platform before art production starts:
| Asset Type | Mobile Budget | Console/PC Budget |
|-----------|--------------|------------------|
| Character polygons | 5k–15k | 50k–200k |
| Texture resolution | 512–1024 | 2048–4096 |
| Draw calls per frame | < 100 | < 500 |
| Particle count per effect | 50–100 | 500–1000 |

Set budgets before production — retrofitting is expensive.

### 2. LOD Strategy (Level of Detail)
- LOD0: full detail (close up)
- LOD1: 50% polygon reduction (medium distance)
- LOD2: 25% of original (far distance)
- LOD3: impostor / billboard (very far)
- Transition distances: define per asset category in the engine

Automatic LOD generation: Simplygon, InstaLOD, or Unreal/Unity auto-LOD.

### 3. Shader Briefs
Per shader (e.g., "Water Surface Shader"):
- Visual reference: 3 screenshots of target look
- Required inputs: base color, normal map, roughness, depth
- Key effects: refraction, foam at shoreline, dynamic waves
- Performance target: N instructions max (for mobile: aggressive)
- Platform constraints: mobile = no tessellation, no geometry shaders

### 4. VFX Performance Guidelines
Per effect:
- Max particle count
- Texture sheet size
- Screen space vs world space
- Overdraw limit (transparent particles = expensive)
- Mobile fallback (simplified version for low-end)

## Key Outputs
- Platform performance budget document
- LOD strategy and transition distances
- Shader briefs (per unique shader)
- VFX performance guidelines
- Art pipeline documentation

## Anti-Patterns
- Defining budgets after art production begins
- No LOD system (tanks performance at mid-range view distances)
- Shaders written without performance constraints
- No mobile fallbacks for particle-heavy effects
