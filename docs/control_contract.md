# ButterflyUI Control Contract

This document defines the canonical contract for public ButterflyUI controls.

It is intended to keep the Python SDK, schema layer, runtime, docs, and examples aligned.

Every control does not need every capability. Every control does need the same shape of documentation and implementation contract.

## Goal

A ButterflyUI control should be understandable from one place.

For users, that means:

- they can tell what the control is for
- they can see which props matter
- they can understand how it behaves with style packs, scopes, and effects

For LLMs, that means:

- the control has a stable category
- the control has canonical names
- the control exposes predictable docs
- the control serializes and renders through one obvious pipeline

## Required Identity

Every public control should define:

- public class name
- canonical `control_type`
- category
- short summary
- child mode
- slots
- capabilities

## Required Documentation Shape

Each control file should document the following, directly or through generated metadata:

### 1. Summary

One short paragraph answering:

- what this control is
- when to use it

### 2. Child Model

State whether the control accepts:

- no children
- one child
- many children
- named slots

### 3. Capabilities

List only the capabilities the control actually supports.

Examples:

- layout
- surface
- style
- motion
- modifiers
- effects
- input
- selection
- scroll
- overlay
- actions

### 4. Slots

If the control supports named child areas, document them clearly.

Examples:

- `content`
- `leading`
- `trailing`
- `title`
- `subtitle`
- `actions`

### 5. Variants

If the control supports variants, document the variant axes and common values.

Examples:

- `variant`
- `intent`
- `size`
- `density`
- `tone`

### 6. States

Document the states that visually or behaviorally matter.

Examples:

- idle
- hover
- pressed
- focused
- disabled
- loading
- selected

### 7. Events

Document emitted events.

Examples:

- `on_click`
- `on_change`
- `on_focus`
- `on_blur`
- `on_submit`

### 8. Invoke Methods

Document imperative helpers when they exist.

Examples:

- `play()`
- `pause()`
- `seek()`
- `open()`
- `close()`
- `set_props()`
- `get_state()`

### 9. Examples

Every public control should have:

- one minimal example
- one realistic styled example

## Required Runtime Contract

A ButterflyUI control is complete only when all layers agree.

### Python SDK

The Python side should provide:

- canonical class name
- canonical `control_type`
- schema-covered props
- documented fields
- children/slot mapping
- event helpers where needed
- invoke helpers where needed

### Schema and Metadata

The metadata layer should provide:

- prop names
- type hints
- category
- capabilities
- child mode
- slot names
- event names
- docs

### Dart Runtime

The runtime side should provide:

- renderer registration
- prop parsing
- style-pack integration
- style/modifier/motion/effect integration where applicable
- event emission
- invoke handling where applicable

## Required Visual Integration

Controls that participate in the visual system should declare how they integrate with:

- style packs
- scoped tokens
- `Style`
- modifiers
- motion
- effects
- inherited surface tint or image context when relevant

If a control opts out of one of these, that should be explicit.

## Naming Rules

These rules keep the catalog understandable.

- Prefer one canonical name.
- Keep aliases for compatibility only.
- Do not document aliases before the canonical name.
- Do not expose near-duplicate names unless they have a real semantic difference.
- Avoid category names pretending to be behavior names.

Examples:

- prefer `markdown_view` over documenting both `markdown` and `markdown_view` as peers
- prefer `file_picker` over `filepicker`
- prefer one `combo_box` surface instead of multiple spellings

## Control Template

This is the expected conceptual template for any public control:

1. Summary
2. Role
3. Child model
4. Slots
5. Capabilities
6. Variants
7. States
8. Events
9. Invoke methods
10. Minimal example
11. Styled example
12. Notes on scope/style-pack behavior

## Completion Checklist

A control is not complete because it exists in the catalog.

A control is complete when:

- Python class exists
- schema exists
- metadata exists
- runtime renderer exists
- props serialize correctly
- control renders correctly
- events work
- invoke methods work
- docs are complete
- examples exist
- at least one targeted test exists

## Framework-Level Rule

ButterflyUI should not be explained as a giant list of controls.

It should be explained as:

- a small core language
- a predictable control contract
- a scoped styling model
- a rich but structured catalog

That is what makes it understandable for both users and LLMs.
