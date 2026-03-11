# Styling Engine To 100%

Current honest baseline: approximately `60%`

This checklist defines what still has to be completed before ButterflyUI can
credibly call the Styling system a real CSS-grade customization engine across
the framework.

## 0. Baseline Lock

- [x] Stylesheet parser exists on both ends
- [x] Utility class expansion exists
- [x] Structured `Style(...)` objects exist
- [x] Typed scene layers exist (`ParticleField`, `GradientWash`, etc.)
- [x] Core proof page exists in [stylesheet.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/examples/stylesheet.py)
- [x] Styling helper folders are analyzer-clean
- [x] Completion status is measured family-by-family instead of by broad estimate only

## 1. Cascade And Specificity

- [x] Document the exact cascade order in runtime code:
  - tokens/theme
  - control defaults
  - stylesheet selectors
  - utility classes
  - local `Style(...)`
  - state overrides
  - runtime interaction state
- [x] Publish the exact cascade order in user-facing docs
- [x] Add explicit selector specificity scoring
- [x] Add deterministic tie-breaking for same-specificity rules
- [x] Add stylesheet rule ordering tests
- [x] Add slot-specific specificity tests
- [x] Ensure `class_name` and `classes` always normalize to one internal path

Target files:
- [control_style_resolver.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/control_style_resolver.dart)
- [stylesheet.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/stylesheet.dart)
- [runtime_stylesheet_test.dart](G:/Projects/ButterflyUI/butterflyui/src/test/runtime_stylesheet_test.dart)

## 2. Design Tokens

- [x] Define first-class styling tokens for:
  - colors
  - typography
  - spacing
  - radius
  - borders
  - shadows
  - motion timing
  - z-depth
- [x] Make `:root` token declarations overrideable from Python
- [x] Allow stylesheet declarations to reference token aliases instead of raw values everywhere
- [x] Add token fallback behavior when a token is missing
- [x] Add token docs and example usage

Target files:
- [theme.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/theme.dart)
- [style_pack.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/style_pack.dart)
- [style_packs.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/style_packs.dart)
- [style.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/types/style.py)

## 3. Responsive Styling

- [x] Finish breakpoint support for:
  - `sm`
  - `md`
  - `lg`
  - `xl`
  - `2xl`
- [x] Add responsive utilities for:
  - width / max-width / min-width
  - padding / margin / gap
  - display text scales
  - alignment / justify / item placement
  - layout direction changes
- [x] Add responsive stylesheet rule tests
- [x] Add one responsive demo page

Target files:
- [utility_classes.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/utility_classes.dart)
- [stylesheet.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/stylesheet.dart)
- [stylesheet.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/examples/stylesheet.py)

## 4. Layout Authoring Primitives

- [x] Make all major layout controls Styling-first for:
  - `position`
  - `relative`
  - `absolute`
  - `fixed`
  - `top/right/bottom/left`
  - `z_index`
  - `overflow`
  - `max_width`
  - `min_height`
  - viewport sizing
- [x] Add centered shell/container utilities like `mx-auto`
- [x] Add layout utilities for `flex`, `grow`, `shrink`, `basis`, `gap`
- [x] Add grid and stack positioning coverage

Target files:
- [control_renderer.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/control_renderer.dart)
- [container.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/layout/container.dart)
- [stack.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/layout/stack.dart)
- [row.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/layout/row.dart)
- [column.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/layout/column.dart)

## 5. Typography System

- [x] Add named type roles:
  - `display`
  - `headline`
  - `title`
  - `body`
  - `caption`
  - `mono`
- [x] Add utilities and declarations for:
  - tracking
  - line-height
  - font-weight
  - max text width
  - text balance / wrapping policies
  - decoration style / offset
- [x] Make button labels, text nodes, inputs, helpers, captions, and headings use the same token model
- [x] Add typography-first demo examples

Target files:
- [text.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/display/text.dart)
- [button_runtime.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/buttons/button_runtime.dart)
- [text_field.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/inputs/text_field.dart)
- [utility_classes.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/utility_classes.dart)

## 6. Surface And Scene Compositing

- [x] Make authored scene layers compose cleanly inside surfaces instead of only behind them
- [x] Add per-surface clipping for scene layers
- [x] Add scene opacity and scene mask control
- [x] Add `mix_blend_mode` and `background_blend_mode`
- [x] Add background/foreground layer ordering guarantees
- [x] Add isolation rules so one styled surface does not leak into another
- [x] Add tests for hero-section clipping and nested-surface composition

Target files:
- [control_renderer.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/control_renderer.dart)
- [render_layers.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/effects/visuals/renderers/render_layers.dart)
- [scene_painters.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/effects/visuals/renderers/scene_painters.dart)

## 7. Scene Layer Expansion

- [x] Finish direct-authored scene primitives:
  - `LineField`
  - `OrbitField`
  - `NoiseField`
  - `ShaderLayer`
  - region masks
  - clipped radial fields
- [x] Add direct shader asset wiring from authored `ShaderLayer`
- [x] Add Lottie/Rive layer hosting through typed scene declarations, not legacy wrapper logic
- [x] Add particle and line-field parameter validation on the Python side

Target files:
- [layer.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/effects/visuals/scene/layer.dart)
- [scene_painters.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/effects/visuals/renderers/scene_painters.dart)
- [style.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/types/style.py)

## 8. Styling-First Core Controls

- [x] Remove remaining legacy paint ownership from:
  - buttons
  - text inputs
  - cards/surfaces
  - chips/badges
  - overlays/dialog chrome
- [x] Make slot styling consistent across:
  - `label`
  - `icon`
  - `content`
  - `helper`
  - `placeholder`
  - `background`
  - `border`
- [x] Ensure legacy `bgcolor`/`gradient` props become thin aliases over Styling resolution instead of parallel systems

Recent progress:
- [x] Buttons can now use Styling-owned surface composition with scene-aware background blending

Target files:
- [button_runtime.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/buttons/button_runtime.dart)
- [text_field.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/inputs/text_field.dart)
- [container.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/layout/container.dart)
- [overlay.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/controls/overlay/overlay.dart)

## 9. Styling-First Helper Layer

- [x] Effects/customization helpers now route through the Styling bridge
- [x] Remove any remaining duplicate helper-local styling models
- [x] Convert remaining helper docs and examples to Styling-first wording
- [x] Add helper-level tests for Lottie/Rive/scene bridge behavior where applicable

Target files:
- [helper_bridge.dart](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/helpers/helper_bridge.dart)
- [effects](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/helpers/effects)
- [customization](G:/Projects/ButterflyUI/butterflyui/src/lib/src/core/styling/helpers/customization)

## 10. Python API Completion

- [x] Make the main styling-facing Python APIs use the documented-field pattern
- [x] Add typed Python classes for any missing scene or token primitives
- [x] Normalize `class_name`, `classes`, `theme`, and `style` handling across controls
- [x] Add more examples under the Python package:
  - landing page
  - dashboard
  - glass UI
  - dense desktop tool

Target files:
- [stylesheet.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/stylesheet.py)
- [style.py](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/types/style.py)
- [examples](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/examples)

## 11. Documentation

- [x] Add a Styling mental-model doc:
  - selectors
  - utility classes
  - structured `Style(...)`
  - tokens
  - scene layers
- [x] Add a "how ButterflyUI Styling differs from browser CSS" doc
- [x] Add control-slot styling docs
- [x] Add a scene-layer authoring doc

Target locations:
- [docs](G:/Projects/ButterflyUI/docs)
- [butterflyui docs](G:/Projects/ButterflyUI/butterflyui/sdk/python/packages/butterflyui/src/butterflyui/docs)

## 12. Verification

- [x] Add a Styling-specific completion matrix
- [x] Add widget tests for:
  - responsive breakpoints
  - specificity
  - slot styling
  - scene clipping
  - token overrides
  - button/input legacy alias compatibility
- [x] Add one end-to-end Genesis-style app fixture that relies on Styling heavily

Target files:
- [runtime_stylesheet_test.dart](G:/Projects/ButterflyUI/butterflyui/src/test/runtime_stylesheet_test.dart)
- [runtime_controls_test.dart](G:/Projects/ButterUI/butterflyui/src/test/runtime_controls_test.dart)

## 13. Exit Criteria

Styling can be considered `100%` only when all of the following are true:

- [ ] A serious app page can be authored from Python with mostly stylesheet + class_name + local `Style(...)`
- [ ] Scene layers can be authored directly without named presets
- [ ] Core controls no longer visibly fight the Styling engine
- [ ] Button, input, text, surface, and overlay styling behave consistently
- [ ] Responsive layout and typography are usable in real pages
- [ ] The Styling system is documented as the primary customization model
- [ ] The Styling runtime has dedicated tests and a trustworthy completion matrix
