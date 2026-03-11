# Tokens

Tokens define shared design values that the Styling engine can resolve
everywhere.

Current first-class token families:

- colors
- typography
- spacing
- radii
- borders
- shadows
- motion timing
- depth
- overlays

## Defining tokens

Author token overrides in `:root`.

```python
page.stylesheet = """
:root {
  --background: #f4f6fb;
  --surface: #ffffff;
  --text: #0f172a;
  --muted: #64748b;
  --accent: #4f46e5;
  --radius-xl: 28;
  --space-xl: 32;
}
"""
```

## Referencing tokens

Use either `var(...)` or `token(...)`.

```css
Container.hero {
  background_color: var(--surface, #ffffff);
  border_color: var(--border, rgba(15,23,42,0.10));
}

Button.primary {
  background_color: token(primary, #4f46e5);
  label_text_color: token(on_primary, #ffffff);
}
```

Fallbacks are important because they let shared rules stay safe even when a
theme omits a specific token.

## Why tokens matter

Tokens let you:

- retint a whole app or page shell
- swap theme packs without rewriting rules
- keep motion, spacing, and radius values consistent
- make Genesis and other apps share the same Styling engine language

## Practical token example

```python
page.stylesheet = """
:root {
  --surface: #f8fafc;
  --surface-alt: #eef2ff;
  --text: #0f172a;
  --muted: #64748b;
  --accent: #2563eb;
}

Surface.panel {
  background_color: var(--surface, #ffffff);
  border_color: rgba(15,23,42,0.08);
  shadow: [{"color": "rgba(37,99,235,0.14)", "blur": 28, "offset": [0, 14]}];
}

Button.primary {
  background_color: token(primary, #2563eb);
  label_text_color: token(on_primary, #ffffff);
}
"""
```
