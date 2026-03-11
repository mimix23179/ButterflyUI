# Styling Mental Model

ButterflyUI Styling is the public customization system for the framework.

It is built from three inputs that compose together:

1. stylesheet selectors
2. utility classes
3. local structured `Style(...)`

## 1. Stylesheet selectors

Use a stylesheet when you want shared rules applied by control type, `#id`,
`.class`, slot, state, or breakpoint.

```python
page.stylesheet = """
:root {
  --surface: #f8fafc;
  --text: #0f172a;
  --accent: #4f46e5;
}

Container.hero {
  background: rgba(255, 255, 255, 0.82);
  border_color: rgba(15, 23, 42, 0.10);
  radius: 28;
  shadow: [{"color": "rgba(15,23,42,0.12)", "blur": 36, "offset": [0, 18]}];
}

Button.primary {
  background_color: var(--accent, #4f46e5);
  label_text_color: #ffffff;
}

Button.primary:hover {
  translate_y: -2;
}
"""
```

## 2. Utility classes

Use `class_name` when you want fast Tailwind-like styling.

```python
ui.Button(
    text="Launch",
    class_name="primary pill px-6 py-3 rounded-full shadow-lg hover:scale-105",
)
```

Utilities are ideal for:

- spacing
- typography scale
- alignment
- width and layout behavior
- one-off page composition

## 3. Structured local `Style(...)`

Use local `Style(...)` when a control needs typed, explicit overrides.

```python
ui.Container(
    style=ui.Style(
        background=ui.LinearGradient(
            colors=["#0f172a", "#111827"],
            begin="top_left",
            end="bottom_right",
        ),
        radius=24,
        padding=24,
        shadow=[
            ui.BoxShadow(color="#220f172a", blur=28, offset=[0, 16]),
        ],
        hover={
            "translate_y": -2,
        },
    )
)
```

Use local style sparingly. Prefer stylesheet rules and utility classes first.

## Slot styling

Styling can target control internals by slot instead of forcing every visual
decision into the outer control shell.

Common slots:

- `label`
- `icon`
- `content`
- `helper`
- `placeholder`
- `background`
- `border`

Examples:

```css
Button.primary {
  label_text_color: #ffffff;
}

TextField.search {
  background_color: rgba(255,255,255,0.78);
  border_color: rgba(15,23,42,0.10);
  placeholder_text_color: rgba(15,23,42,0.48);
  helper_text_color: rgba(15,23,42,0.58);
}
```

## Responsive styling

Breakpoints are authored directly in stylesheet rules or utility classes.

```css
@md Container.hero {
  max_width: 1200;
}

@lg Text.hero_title {
  font_size: 104;
}
```

```python
ui.Container(
    class_name="mx-auto max-w-6xl px-6 md:px-10 lg:px-16",
)
```

## How ButterflyUI Styling differs from browser CSS

ButterflyUI Styling is **not** browser CSS:

- it renders through Flutter, not the DOM
- authored scene layers are native runtime objects, not CSS backgrounds
- utility classes are resolved by ButterflyUI, not by a browser engine
- scene composition, blur, and effect layers are Flutter-native render layers

That difference is intentional. ButterflyUI aims for CSS-like authoring while
still supporting desktop and web through a single runtime.
