![ButterflyUI banner](https://github.com/mimix23179/ButterflyUI/blob/main/assets/banner.png?raw=true)

# ButterflyUI

ButterflyUI is a Python-authored, scope-driven, token-aware UI framework.

Python builds the control tree. The Flutter runtime receives JSON commands and renders the UI. ButterflyUI is designed for rich desktop and web apps that need strong layout, styling, motion, and visual customization without turning the API into framework magic.

It is not a Flet copy. It has its own model:

- core controls for structure and interaction
- scopes for subtree behavior
- style packs for app-wide identity
- tokens for design values
- style, modifiers, motion, and effects for local refinement
- umbrella systems only where they add real meaning

## Core Idea

ButterflyUI should be read in this order:

1. Build screens with normal controls like `Container`, `Row`, `Column`, `Text`, `Button`, and `TextField`.
2. Apply a style pack to define the overall look.
3. Use `Style` for slot overrides and local component variants.
4. Use `Modifier` for hover, press, and focus behavior.
5. Use `Motion` for animation.
6. Use `Effects` when you want glow, blur, noise, or other visual treatment.
7. Use `Candy`, `Skins`, and `Gallery` as scoped systems, not as replacements for normal composition.

## ButterflyUI Language

These are the canonical public concepts of the framework:

- `Controls`: renderable UI nodes like `Container`, `Surface`, `Row`, `Button`, `Slider`, `MarkdownView`
- `Scopes`: subtree wrappers like `CandyScope`, `SkinsScope`, and `GalleryScope`
- `Style packs`: named visual identities like `base`, `glass`, `neon`, and custom registered packs
- `Tokens`: color, spacing, radius, typography, shadow, motion, and effect values
- `Style`: local slot-based and variant-based overrides
- `Modifiers`: state-driven changes for hover, press, focus, and active interaction
- `Motion`: animation contracts and transitions
- `Effects`: visual treatment layers like glow, blur, pixelation, noise, and gradient accents

If a concept does not fit one of those buckets, the API is probably unclear and should be simplified.

## The Three Umbrella Systems

ButterflyUI currently treats these as the only umbrella systems worth explaining publicly:

### Candy

Candy is the craft layer.

It shapes structural and visual primitives:

- layout
- surfaces
- decoration
- motion
- interaction wrappers
- visual effects

Candy should feel like scoped composition, not a second framework inside the framework.

### Skins

Skins is the identity layer.

It shapes the visual language of a subtree or app:

- colors
- typography
- spacing
- radii
- shadows
- materials
- motion defaults
- effect presets

Skins should answer: "What does this app feel like?"

### Gallery

Gallery is the asset layer.

It shapes how media and resources are browsed, previewed, filtered, selected, and applied:

- images
- video
- audio
- documents
- fonts
- skins
- presets

Gallery should answer: "How do I work with assets inside this UI?"

## Quick Start

```python
import butterflyui as bui


def main(page: bui.Page) -> None:
    page.title = "ButterflyUI"
    page.style_pack = "base"

    page.content = bui.Container(
        content=bui.Column(
            controls=[
                bui.Text("ButterflyUI", variant="headline"),
                bui.Text(
                    "A Python-authored UI framework with scoped styling and visual systems."
                ),
                bui.Button(
                    text="Apply",
                    variant="filled",
                    on_click=lambda e: print("clicked"),
                ),
            ],
            spacing=12,
        ),
        padding=20,
        radius=20,
        bgcolor="#0f172a",
        color="#ffffff",
    )
    page.update()


if __name__ == "__main__":
    raise SystemExit(bui.run(main, target="desktop"))
```

## Examples

---

Alignment:
![Alignment](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/Alignment.png?raw=true)

---

Flet Layouts:
![Flex Layouts](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/FlexLayouts.png?raw=true)

---

Scrollable And Split:
![Scrollable And Split](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/ScrollableAndSplit.png?raw=true)

---

Surfaces:
![Surfaces](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/Surfaces.png?raw=true)

---

## Design Rules

These are the rules that keep ButterflyUI understandable for both users and LLMs:

- Prefer one canonical name for each concept.
- Keep aliases as compatibility behavior, not as primary docs.
- Document controls by role and capability, not just by listing props.
- Keep scopes explicit when a subtree changes identity or behavior.
- Keep styling layered: style pack -> tokens -> style -> modifiers -> motion -> effects.
- Keep umbrella systems scoped and compositional, never separate runtime pipelines.

## Read Next

- [Authoring Model](G:/Projects/ButterflyUI/docs/authoring_model.md)
- [Control Contract](G:/Projects/ButterflyUI/docs/control_contract.md)
- [Implementation Playbook](G:/Projects/ButterflyUI/docs/implementation_playbook.md)
- [Desktop vs Web Target](G:/Projects/ButterflyUI/docs/desktop_modes.md)

## Current Direction

ButterflyUI is being shaped around:

- strong layout and surface controls
- customizable app identity through style packs and tokens
- visually expressive interaction through style, modifiers, motion, and effects
- scoped umbrella systems for Candy, Skins, and Gallery

The goal is not to clone another framework. The goal is to make a framework that stays predictable while still being capable of building sick-looking and solid-feeling apps.
