![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/banner.png?raw=true)

---

# 🦋 ButterflyUI - AI Coders used:
- Codex[Mostly]
- Copilot[Mostly]
- TRAE[For a short while]
- Kilo[For a short while]
- Antigravity[For a short while]

**ButterflyUI** is a layered application platform built on composable UI primitives, token-driven styling, and modular umbrella controls.

It is not just a UI toolkit.

It is an ecosystem where entire application domains — IDEs, visual builders, terminals, asset browsers, and theme systems — are constructed from structured control families.

---

# ✨ Core Philosophy

ButterflyUI follows a clear architectural hierarchy:

```

Candy     → Structural & visual primitives
Skins     → Token-driven visual identity
Gallery   → Asset intelligence layer

````

Each of these is an **umbrella control**:
- One control ID
- Many focused submodules
- Shared registries
- Manifest-driven configuration

This creates a predictable, plugin-style architecture similar to professional creative software.

---

# 🧱 Umbrella Controls

## 🍬 Candy — The Craft Layer

Candy is the foundational primitive layer.

It provides:

- Layout primitives (`row`, `column`, `stack`, `container`, `wrap`, etc.)
- Surfaces and decoration
- Effects (glow, glass, noise, neon, pixelate)
- Motion systems (animation, transition, stagger)
- Interaction wrappers (pressable, gesture_area, hover_region)
- Structural helpers (split_pane, grid, viewport, layer)

Candy is:
- Token-aware
- Deterministic
- Composable
- Performance-focused

Everything in ButterflyUI is built on top of Candy.

---

## 🎨 Skins — Visual Identity System

Skins defines the visual identity of your entire application.

It manages:

- Color tokens
- Typography systems
- Elevation & shadow models
- Borders & outlines
- Materials (glass, matte, neon)
- Effects & shaders
- Motion defaults
- Responsive breakpoints

Skins is:
- Token-driven
- Runtime switchable
- Serializable
- Integrated with Candy & Studio

If Candy provides the structure,
Skins provides the soul.

---

## 🖼 Gallery — Asset Intelligence Layer

Gallery is not just a grid of images.

It is a structured asset orchestration system supporting:

- Fonts
- Images
- Video
- Audio
- Documents
- Skins
- Presets

It includes:

- Grid & list layouts
- Filtering & search
- Pagination
- Selection systems
- Media-specific preview renderers
- Apply adapters for Studio & Skins

Gallery connects assets to tools in a clean, type-aware way.

---

## Alignment:
![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/Alignment.png?raw=true)

---

## Flex Layouts:
![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/FlexLayouts.png?raw=true)

---

## Scrollable And Split:
![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/ScrollableAndSplit.png?raw=true)

---

## Surfaces & Effects:
![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/Surfaces.png?raw=true)

---

# 🧩 Modular Architecture

Every umbrella control follows the same pattern:

## 1️⃣ Host
The main control orchestrates:
- Layout
- Registries
- Persistence
- Services

## 2️⃣ Submodules
Each module declares:
- `id`
- `version`
- `depends_on`
- contributions (panels, tools, providers, surfaces)

## 3️⃣ Manifest
Users define:

```json
{
  "enabledModules": [],
  "layout": {},
  "providers": {},
  "keymap": "default"
}
````

This allows building:

* A lightweight editor
* A full IDE
* A video studio
* A design tool
* A dashboard platform
* A terminal-only tool
* A custom OS-like interface

---

# 📚 Control Catalog

ButterflyUI includes an extensive catalog of advanced controls such as:

* `animated_gradient`
* `glass_blur`
* `neon_edge`
* `blob_field`
* `noise_displacement`
* `confetti_burst`
* `split_pane`
* `table_view`
* `spark_plot`
* `curve_editor`
* `layer_mask_editor`
* `scrollable_column`
* `reorderable_tree`
* `scene_view`
* `viewport`
* `webview`
* `chat`
* `markdown`
* `video`
* `progress`
* `notification_host`
* `overlay`
* `route`
* `page_nav`
* and many more…

All controls are:

* Token-aware
* Composable
* Deterministic
* Designed for real software

---

# 🧠 Architectural Goals

ButterflyUI is designed to:

* Scale from small apps to professional tools
* Keep visual identity centralized
* Keep execution logic isolated
* Separate structure from decoration
* Allow runtime composition of features
* Avoid framework magic
* Remain predictable and maintainable

---

# 🚀 What ButterflyUI Is

ButterflyUI is:

* A layered UI platform
* A plugin-oriented architecture
* A schema-driven runtime
* A modular application foundation
* A serious foundation for IDEs, builders, dashboards, and tools

---

# 🦋 Final Thought

Candy is the craft.
Skins is the identity.
Gallery supplies the resources.

Together, they form ButterflyUI.
