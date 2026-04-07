---
name: visionos-patterns
description: Use when designing for Apple visionOS, applying spatial design conventions, or building for the Apple Vision Pro platform
---

# visionOS Design Patterns

## When to Use
When building apps or experiences for Apple Vision Pro using visionOS.

## Core Jobs

### 1. Window and Volume Types
| Type | Use When |
|------|---------|
| Window (2D) | App that's a panel (productivity, media) |
| Volume (3D) | App that places 3D objects in the world |
| Full Space (immersive) | Experiences that take over the environment |
| Passthrough + Space | Mixed: real world + digital content |

Start with Windows unless 3D is core to your experience. Full Space requires explicit user action to enter.

### 2. visionOS Interaction Model
- **Eyes**: primary pointer (look at to select)
- **Hands**: secondary (pinch to activate what eyes look at)
- **Voice**: third modality (Siri integration)
- Target affordance: elements must communicate they're interactive (hover effect via eye gaze)
- Standard gestures: tap (index + thumb pinch), press (sustained pinch), drag (pinch + move)

### 3. visionOS HIG Key Principles
- **Passthrough integration**: respect the real environment. Don't design as if user is in darkness.
- **Window anchoring**: windows can be anchored to surfaces or float in space. Float is default.
- **Depth and layers**: use SwiftUI's depth modifier to create z-axis separation
- **Materials**: use vibrancy and glass materials — don't use flat opaque backgrounds
- **Ornaments**: secondary controls that float beside the main window

### 4. RealityKit and SwiftUI Integration
- UI layer: SwiftUI (same as iOS/iPadOS)
- 3D content: RealityKit entities
- Spatial audio: attach audio sources to 3D entities
- Hand tracking: ARKit hand anchors for custom gesture recognition

## Key Outputs
- Window/volume/space type selection rationale
- Interaction design spec (what gestures trigger what)
- visionOS HIG compliance review
- Material and depth specification

## Anti-Patterns
- iOS app ported to visionOS without redesign (violates HIG, feels unnatural)
- Opaque flat backgrounds (use glass materials)
- Tiny interaction targets (minimum 44pt x 44pt, larger for gaze-only)
- Full Space for experiences that don't need it (jarring for users to enter)
