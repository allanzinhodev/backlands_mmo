---
name: isometric_projection
description: Logic and math for isometric projection in OTClient and Map Editor, including offset and direction mapping for missiles and rendering.
---

# Isometric Projection in OTClient

This skill documents the math and rendering logic required to properly align objects (like Missiles/Projectiles) in the custom isometric perspective used in this project.

## Coordinate System Mapping
The game uses a tilted coordinate system where the screen axes map to logical map coordinates (X, Y) as follows:
- **North (Up-Left)**: Map `Y` decreases. `dx = -1`, `dy = -1`
- **East (Up-Right)**: Map `X` increases. `dx = 1`, `dy = -1`
- **South (Down-Right)**: Map `Y` increases. `dx = 1`, `dy = 1`
- **West (Down-Left)**: Map `X` decreases. `dx = -1`, `dy = 1`

## Screen Delta / Offset Calculation
To convert map coordinate differences (`dx`, `dy`) into pixel screen offsets (`m_delta.x`, `m_delta.y`), the following transformation is used:
```cpp
m_delta.x = (dx - dy) * 32;
m_delta.y = (dx + dy) * 32;
```
For 3D elevation (Z-axis), an offset of `-32 * dz` is usually applied to both X and Y.

## Direction Mapping (Otc::Direction)
When determining the visual direction of an object (e.g., to select the correct sprite from an outfit), the logical directions must be re-mapped to match the isometric rotation:
- `Otc::North` -> visually looks like `NorthWest`
- `Otc::East` -> visually looks like `NorthEast`
- `Otc::South` -> visually looks like `SouthEast`
- `Otc::West` -> visually looks like `SouthWest`

Example code to update visual direction for a Missile:
```cpp
if (dx == 1 && dy == -1) m_direction = Otc::East;
else if (dx == 1 && dy == 1) m_direction = Otc::South;
else if (dx == -1 && dy == 1) m_direction = Otc::West;
else if (dx == -1 && dy == -1) m_direction = Otc::North;
```

This ensures that the rendering engine selects the correct sprite rotation to match the isometric grid movement.
