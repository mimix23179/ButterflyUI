# Windsurf LLM Playbook: Implementing Conduit Controls

This guide is written from the perspective of an LLM agent working inside Windsurf
(or a similar IDE). It focuses on the end-to-end path for adding new controls so
the control is known, serialized, and rendered when used from the Python SDK.

## Mental Model

Conduit is a Python-driven UI system. Python builds a control tree, serializes it
to JSON, and streams it to the Flutter runtime. The runtime renders widgets based
on control type + props. If any layer is missing, the control will not appear or
will render incorrectly.

Pipeline overview:

- Python Control Class -> JSON payload
- JSON -> Runtime registry / renderer
- Renderer -> Flutter widget

## File Map (Where Things Live)

Python (SDK):
- `conduit/sdk/python/packages/conduit/src/conduit/core/schema.py`
- `conduit/sdk/python/packages/conduit/src/conduit/core/control.py`
- `conduit/sdk/python/packages/conduit/src/conduit/core/*.py`
- `conduit/sdk/python/packages/conduit/src/conduit/components.py`
- `conduit/sdk/python/packages/conduit/src/conduit/app.py`

Dart (Runtime):
- `conduit/src/lib/src/core/control_registry.dart`
- `conduit/src/lib/src/core/control_renderer.dart`
- `conduit/src/lib/src/core/controls/**`
- `conduit/src/lib/src/core/style/style_packs.dart`
- `conduit/src/lib/src/core/candy/theme.dart`

Docs + Tests:
- `conduit/docs/conduit_docs.md`
- `test_apps/**`

## Checklist: Add a New Control

1) Define the Python control class
- Create a new file in `conduit/core/` or extend an existing module.
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
  `conduit/src/lib/src/core/controls/` and calling it from the renderer.

5) Map props and implement the widget
- Parse props carefully (strings, numbers, lists, bools).
- Respect the style pack and theme tokens where possible.
- Keep defaults consistent with the tokens instead of hard-coded colors.

6) Wire events and invokes
- If the control emits events, register them in the widget.
- If it supports imperative methods, implement invoke handlers in the runtime
  (and provide Python helpers if needed).

7) Update docs + demo
- Document the control in `conduit_docs.md` and/or add a small example in
  `test_apps/`.

## Checklist: Make Sure It Renders

- The Python control type string matches the runtime renderer type.
- The schema includes the props you send (or you are using `strict=False`).
- `control.to_json()` includes props + children as expected.
- Dart side parses props and builds a widget without type exceptions.
- The control appears in the UI tree when you call `page.update()`.

## Style Packs and Tokens

To keep controls consistent with style packs:

- In Dart, use `conduit_*` theme helpers (from `control_theme.dart`) instead of
  raw `Colors.*` defaults.
- Use `style_pack` prop to override a subtree style.
- In Python, set `page.style_pack` for a global theme.
- For custom packs, register them from Python with `page.register_style_pack(...)`.
- Prefer candy-driven defaults for control props via `controls.*` tokens (and
  optional `control_groups`) instead of hard-coded values in widgets.

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
  built = ConduitGlowBox(
    color: coerceColor(props['color']) ?? conduitPrimary(context),
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
