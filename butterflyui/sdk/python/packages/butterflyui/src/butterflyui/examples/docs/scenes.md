# Authored Scene Layers

ButterflyUI scenes are authored directly from Python. They are not named
presets, and they are not browser CSS backgrounds.

Scene layers are value objects that Styling can compose behind or above normal
content.

## Supported layer types

- `ParticleField`
- `GradientWash`
- `LineField`
- `OrbitField`
- `NoiseField`
- `ShaderLayer`

## Example

```python
ui.Container(
    class_name="hero mx-auto max-w-6xl",
    style=ui.Style(
        background_layers=[
            ui.GradientWash(
                colors=["#ffffff", "#eef2ff", "#e0f2fe"],
                opacity=0.72,
                intensity=0.55,
            ),
            ui.ParticleField(
                count=220,
                spread="scatter",
                opacity=0.84,
                speed=0.18,
                rotation=0.22,
                palette=["#3b82f6", "#8b5cf6", "#fb7185", "#f59e0b"],
            ),
            ui.OrbitField(
                count=64,
                radius=0.42,
                opacity=0.34,
                speed=0.15,
            ),
        ],
    ),
)
```

## Scene authoring rules

- use scene layers for atmosphere and motion, not for layout
- keep content readable by tuning opacity and density
- let containers clip and isolate scenes when needed
- prefer authored parameters over named presets so pages stay intentional

## When to use each layer

- `ParticleField`: spark-like or confetti-like motion
- `GradientWash`: soft atmospheric color fields
- `LineField`: thin motion lines or scanning textures
- `OrbitField`: radial or orbital motion around a center
- `NoiseField`: subtle grain, fog, or ambient turbulence
- `ShaderLayer`: lower-level custom shader-backed effects
