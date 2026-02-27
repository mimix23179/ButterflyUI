# Implementation Playbook: Implementing ButterflyUI Controls

This guide is written from the perspective of an LLM agent working inside Windsurf
(or a similar IDE). It focuses on the end-to-end path for adding new controls so
the control is known, serialized, and rendered when used from the Python SDK.

## Mental Model

ButterflyUI is a Python-driven UI system. Python builds a control tree, serializes it
to JSON, and streams it to the Flutter runtime. The runtime renders widgets based
on control type + props. If any layer is missing, the control will not appear or
will render incorrectly.

Pipeline overview:

- Python Control Class -> JSON payload
- JSON -> Runtime registry / renderer
- Renderer -> Flutter widget

## File Map (Where Things Live)

Python (SDK):
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/core/schema.py`
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/core/control.py`
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/core/*.py`
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/components.py`
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/app.py`

Dart (Runtime):
- `butterflyui/src/lib/src/core/control_registry.dart`
- `butterflyui/src/lib/src/core/control_renderer.dart`
- `butterflyui/src/lib/src/core/controls/**`
- `butterflyui/src/lib/src/core/style/style_packs.dart`
- `butterflyui/src/lib/src/core/candy/theme.dart`

## Checklist: Add a New Control

1) Define the Python control class
- Create a new file in `butterflyui/core/` or extend an existing module.
- Inherit from `Control` and assign `control_type`.
- Decide what data is props vs children vs meta.
- Keep the constructor minimal and map fields to `self.props`.

2) Register schema for validation + docs
- Add a schema entry in `core/schema.py`.
- Include all props you expect the runtime to accept.
- Universal props are already merged, but custom props must be listed.

3) Export in components
- Add the control class to `components.py` (and `__init__.py` if needed).
- This keeps the Python API surface consistent.

4) Runtime registration
- Add a builder in `control_registry.dart` if it should be configurable there,
  or add a case in `control_renderer.dart` for direct rendering.
- Prefer building the widget in a dedicated file under
  `butterflyui/src/lib/src/core/controls/` and calling it from the renderer.

5) Map props and implement the widget
- Parse props carefully (strings, numbers, lists, bools).
- Respect the style pack and theme tokens where possible.
- Keep defaults consistent with the tokens instead of hard-coded colors.

6) Wire events and invokes
- If the control emits events, register them in the widget.
- If it supports imperative methods, implement invoke handlers in the runtime
  (and provide Python helpers if needed).

## Checklist: Make Sure It Renders

- The Python control type string matches the runtime renderer type.
- The schema includes the props you send (or you are using `strict=False`).
- `control.to_json()` includes props + children as expected.
- Dart side parses props and builds a widget without type exceptions.
- The control appears in the UI tree when you call `page.update()`.

## Style Packs and Tokens

To keep controls consistent with style packs:

- In Dart, use `butterflyui_*` theme helpers (from `control_theme.dart`) instead of
  raw `Colors.*` defaults.
- Use `style_pack` prop to override a subtree style.
- In Python, set `page.style_pack` for a global theme.
- For custom packs, register them from Python with `page.register_style_pack(...)`.
- Prefer candy-driven defaults for control props via `controls.*` tokens (and
  optional `control_groups`) instead of hard-coded values in widgets.

## CustomizationEngine Rules (Current Runtime Contract)

- Hover/press/focus visual modifiers are **interactables-only** (buttons, inputs,
  toggles, selectable items). Structural/display surfaces must not receive hover effects.
- Surface controls (`surface`/`box`/`container`, chat/code/terminal/window surfaces)
  default to **no outline/border**. Borders are opt-in via explicit props/style slots.
- Legacy `candy_*` props and control names are mapped to the modern style-pack/token
  pipeline for backward compatibility.
- Runtime style-pack resolution is subtree-aware: per-node `style_pack` inheritance
  drives resolver slots, modifier presets, and motion pack lookup.
- When `animation` is not explicitly provided, runtime motion definitions can still
  produce consistent enter animation wrappers from style-pack motion specs.

## Common Failure Modes

- Control type mismatch (Python: `control_type` does not match Dart case).
- Missing schema entries (props dropped in strict mode).
- Incorrect prop names (`min_width` vs `minWidth`, etc.).
- Using a Color where a string is required (or vice versa).
- Not rebuilding UI after updating state (`page.update()`).

## Minimal Example (Pseudo)

Python:

```python
class GlowBox(Control):
    control_type = "glow_box"
    def __init__(self, *, color=None, **kwargs):
        super().__init__()
        if color is not None:
            self.props["color"] = color
```

Dart:

```dart
case 'glow_box':
  built = ButterflyUIGlowBox(
    color: coerceColor(props['color']) ?? butterflyuiPrimary(context),
    child: child,
  );
  break;
```

If the control shows up and inherits the right theme colors, you are done.

## Suggested Verification

- Run a local demo in `test_apps/`.
- On Windows: `flutter run -d windows` (for runtime), then execute your Python app.
- On Web: `flutter run -d chrome`.

Keep the loop tight: add the control, render it once, then refine.
