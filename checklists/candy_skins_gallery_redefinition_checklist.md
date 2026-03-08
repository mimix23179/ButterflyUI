# Candy, Skins, And Gallery Redefinition Checklist

This checklist locks in the current direction for ButterflyUI.

The goal is not to treat `Candy`, `Skins`, and `Gallery` as vague umbrella wrappers.
The goal is to make them clear ButterflyUI systems with distinct responsibilities.

## Public Definitions

### Candy

Candy is the ButterflyUI visual enhancement system.

Candy should:

- enhance existing controls and layouts
- add cinematic polish, ambient motion, and reactive interaction effects
- support decorative layers like particles, glow, shimmer, scanline, parallax, animated backgrounds, and temporary actor-style overlays
- wrap or target existing controls instead of replacing the core control catalog

Candy should not:

- become a second layout framework
- replace `Container`, `Surface`, `Row`, `Column`, or other core controls
- be described as only a CSS-like customization control

### Skins

Skins is the ButterflyUI packaged identity system.

Skins should:

- define curated visual identity packs
- package colors, typography, spacing, radii, elevation, surfaces, and motion tendencies
- optionally link to compatible Candy polish layers
- apply a coherent look to a subtree, screen, or app section

Skins should not:

- collapse into one-off style props
- duplicate the role of `Style`
- be described as only a token map

### Gallery

Gallery is the ButterflyUI visual browser and showcase system.

Gallery should:

- browse, preview, filter, group, and select collections
- handle assets, presets, skins, demos, templates, and media
- support showcase-style presentation, not just image grids
- expose layouts like grid, masonry, list, carousel, virtual grid, and virtual list

Gallery should not:

- be framed as only an image gallery
- be treated as a generic asset dump without browsing semantics

## Implementation Tasks

### Python SDK

- rewrite `Candy`, `CandyScope`, and helpers to describe enhancement-layer behavior first
- rewrite `Skins`, `SkinsScope`, and helpers to describe packaged identity behavior first
- rewrite `Gallery`, `GalleryScope`, and helpers to describe showcase/browser behavior first
- add explicit high-level props where needed for presets, linked effects, showcase metadata, and filtering

### Dart Runtime

- teach `CandyScope` how to interpret semantic enhancement presets and layer groups
- let `CandyScope` render temporary decorative actor overlays when requested
- let `SkinsScope` apply linked Candy polish from skin metadata or explicit props
- let `Gallery` render collection/showcase metadata more clearly
- let `Gallery` respect filter and preview/showcase semantics at runtime

### Documentation Follow-Up

- update public docs so `Candy`, `Skins`, and `Gallery` are no longer called umbrella controls
- document canonical names first and aliases second
- build example coverage around enhancement, identity, and browsing workflows

## Validation

- Python controls compile
- Dart files analyze without new syntax errors
- Candy still wraps and enhances existing controls
- Skins still applies themed identities and can add linked Candy polish
- Gallery still renders current layouts and now behaves more like a showcase/browser
