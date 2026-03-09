![ButterflyUI banner](https://github.com/mimix23179/ButterflyUI/blob/main/assets/banner.png?raw=true)

# ButterflyUI

ButterflyUI is a Python-authored UI framework with a Flutter runtime.

Python builds a control tree. The Flutter side receives JSON commands and renders the app. The framework is currently centered on strong layout, input, navigation, overlay, display, media, and effects controls for desktop and web apps.

It is not a Flet copy. It uses its own control contract and runtime bridge.

## Core Idea

ButterflyUI should be approached in this order:

1. Build the screen with normal controls like `Container`, `Row`, `Column`, `Text`, `Button`, and `TextField`.
2. Compose larger screens from layout, navigation, overlay, data, and media controls.
3. Use tokens, colors, gradients, shadows, motion, and effects where visual refinement is needed.
4. Keep behavior explicit through events, invokes, and control state instead of hidden framework magic.

## Public Model

These are the main public concepts:

- `Controls`: renderable UI nodes like `Container`, `Surface`, `Row`, `Button`, `Slider`, `MarkdownView`
- `Layout`: sizing, spacing, alignment, scrolling, panes, and grid composition
- `Inputs`: fields, toggles, selectors, and action controls
- `Navigation`: app bars, menus, sidebars, tabs, and pagination
- `Overlay`: dialogs, popovers, drawers, sheets, tooltips, snack bars, and toasts
- `Display and Media`: text, charts, markdown, images, audio, and video
- `Effects and Motion`: explicit visual treatment and animation controls

## Quick Start

```python
import butterflyui as bui


def main(page: bui.Page) -> None:
    page.title = "ButterflyUI"

    page.content = bui.Container(
        content=bui.Column(
            controls=[
                bui.Text("ButterflyUI", variant="headline"),
                bui.Text("A Python-authored UI framework with a Flutter runtime."),
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

Flex Layouts:
![Flex Layouts](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/FlexLayouts.png?raw=true)

---

Scrollable And Split:
![Scrollable And Split](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/ScrollableAndSplit.png?raw=true)

---

Surfaces:
![Surfaces](https://github.com/mimix23179/ButterflyUI/blob/main/assets/screenshots/Surfaces.png?raw=true)

---

## Design Rules

- Prefer one canonical name for each control or concept.
- Keep the Python contract and Flutter runtime aligned.
- Document controls by role and behavior, not just prop names.
- Keep customization explicit and local.
- Prefer predictable composition over hidden umbrella systems.

## Read Next

- [Authoring Model](G:/Projects/ButterflyUI/docs/authoring_model.md)
- [Control Contract](G:/Projects/ButterflyUI/docs/control_contract.md)
- [Implementation Playbook](G:/Projects/ButterflyUI/docs/implementation_playbook.md)
- [Desktop vs Web Target](G:/Projects/ButterflyUI/docs/desktop_modes.md)
