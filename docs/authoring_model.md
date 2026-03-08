# ButterflyUI Authoring Model

This document defines the public mental model of ButterflyUI.

It exists for two audiences:

- users writing ButterflyUI apps
- LLMs generating or editing ButterflyUI code

If ButterflyUI feels hard to explain, it usually means one of these concepts is blurred in the API.

## One-Sentence Definition

ButterflyUI is a Python-authored, scope-driven, token-aware UI framework rendered by a Flutter runtime.

Python builds a control tree. The runtime receives JSON commands and renders that tree.

## The Canonical Grammar

Every public ButterflyUI concept should fit one of these categories.

### 1. Controls

Controls are renderable nodes.

Examples:

- `Container`
- `Surface`
- `Row`
- `Column`
- `Text`
- `Button`
- `Slider`
- `Video`
- `MarkdownView`

Use controls when you are building structure, content, interaction, or feedback.

### 2. Scopes

Scopes apply behavior or identity to a subtree.

Examples:

- `CandyScope`
- `SkinsScope`
- `GalleryScope`

Use scopes when descendants should inherit a shared context instead of repeating props on every control.

### 3. Style Packs

Style packs are named app-wide or subtree-wide identities.

Examples:

- `base`
- `glass`
- `neon`
- custom registered packs

Use style packs when you want to switch the broad visual character of a UI without manually restyling every control.

### 4. Tokens

Tokens are the design values behind the framework.

Examples:

- colors
- spacing
- radii
- typography
- shadows
- motion specs
- effect presets

Use tokens when values should be shared, named, and consistent.

### 5. Style

`Style` is a local override layer for a control or subtree.

Use it for:

- slot-specific styling
- local variants
- class-like reusable styling
- control-level overrides

Style should not replace the whole theme system. It is the local layer on top of tokens and style packs.

### 6. Modifiers

Modifiers describe interaction-driven visual changes.

Use them for:

- hover behavior
- pressed behavior
- focus behavior
- selected or active state styling

Modifiers are about stateful reaction, not static appearance.

### 7. Motion

Motion defines animation contracts.

Use it for:

- enter and exit transitions
- hover and press animation
- coordinated movement
- timing and easing defaults

Motion should answer how something changes over time.

### 8. Effects

Effects are visual treatment layers.

Use them for:

- glow
- blur
- pixelation
- noise
- chromatic shift
- decorative gradients

Effects should answer what special visual treatment is being added.

## The Preferred Teaching Order

Users and LLMs should learn ButterflyUI in this order:

1. page and root app structure
2. core controls
3. layout and surfaces
4. style packs and tokens
5. local `Style`
6. `Modifier`
7. `Motion`
8. `Effects`
9. umbrella scopes like Candy, Skins, and Gallery

If an example teaches Candy or Skins before it teaches `Container` or `Button`, it is teaching the framework backwards.

## What Candy, Skins, and Gallery Mean

These are umbrella systems, but they are not separate runtime engines.

### Candy

Candy is the craft layer.

Candy should group:

- layout primitives
- surfaces
- decoration
- interaction wrappers
- motion helpers
- visual effects

Candy is about how UI is built and styled at the primitive level.

### Skins

Skins is the identity layer.

Skins should group:

- palettes
- typography systems
- radii
- elevation models
- materials
- motion defaults
- effect presets

Skins is about what a UI feels like.

### Gallery

Gallery is the asset layer.

Gallery should group:

- asset browsing
- preview
- filtering
- selection
- apply actions
- media-aware display

Gallery is about how resources are explored and applied inside the UI.

## What ButterflyUI Should Not Be

ButterflyUI should not present itself as:

- a Flet clone
- a bag of unrelated widget names
- six competing mini-frameworks
- a framework where every visual feature is a top-level concept

That creates noise for users and bad heuristics for LLMs.

## Public API Rules

These rules keep the framework legible.

- One concept should have one canonical name.
- Aliases are compatibility behavior, not primary teaching surface.
- Controls should be documented by role, capabilities, slots, states, events, and invokes.
- Scopes should be explicit when a subtree changes identity or behavior.
- Style packs should be named and documented as identities, not just token dumps.
- Modifiers, motion, and effects should be described separately because they solve different problems.

## LLM Guidance

If an LLM is generating ButterflyUI code, these defaults should hold:

- start with core controls
- pick one style pack first
- use direct props for simple cases
- use `Style` for local slot overrides
- use `Modifier` for interaction states
- use `Motion` for animation
- use `Effects` only when they add clear value
- use `CandyScope`, `SkinsScope`, or `GalleryScope` only when subtree-wide behavior is needed

## Documentation Priority

When documenting ButterflyUI, prefer this order:

1. what the control is for
2. what it contains or affects
3. what it inherits from scope or style packs
4. what states it supports
5. what events it emits
6. what invoke methods it supports
7. one small example
8. one styled example

If docs start with a long prop dump, they are probably harder than they need to be.
