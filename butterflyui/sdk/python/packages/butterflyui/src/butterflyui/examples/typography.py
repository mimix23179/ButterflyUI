from __future__ import annotations

import argparse
import sys
from pathlib import Path


def _ensure_local_sdk_on_path() -> Path:
    root = Path(__file__).resolve().parents[3]
    src = root / "src"
    src_str = str(src)
    if src_str not in sys.path:
        sys.path.insert(0, src_str)
    return root


_ensure_local_sdk_on_path()

import butterflyui as bui


SURFACE = "#FBFAF7"
INK = "#111827"
MUTED = "#667085"
PRIMARY = "#295BFF"
ACCENT = "#EEF35B"


def _panel(*children: bui.Control, class_name: str = "") -> bui.Control:
    return bui.Container(
        bui.Column(*children, spacing=14),
        class_name=f"type_panel rounded-3xl px-6 py-6 shadow-lg {class_name}".strip(),
    )


def build_page(page: bui.Page) -> bui.Control:
    page.title = "ButterflyUI Typography Roles"
    page.bgcolor = SURFACE
    page.stylesheet = """
        :root {
          --surface: #fbfaf7;
          --background: #fbfaf7;
          --text: #111827;
          --muted_text: #667085;
          --border: #1118271c;
          --primary: #295bff;
          --radius_md: 20;
          --radius_lg: 30;
          --space_md: 16;
          --space_lg: 24;
        }

        .type_shell {
          background_color: #ffffffe8;
          border_color: token(border);
          border_width: 1;
        }

        .type_panel {
          background_color: #ffffffcc;
          border_color: token(border);
          border_width: 1;
        }

        .type_kicker {
          role: overline;
          text_color: #295bff;
          letter_spacing: 1.4;
        }

        .type_caption {
          role: caption;
          text_color: token(muted_text);
        }

        .type_helper {
          role: helper;
          text_color: token(muted_text);
        }

        .type_nav {
          role: nav;
          text_color: #1f2937;
        }

        .type_button_primary {
          background_color: token(primary);
          border_color: token(primary);
          border_width: 1;
          label_type_role: button_label;
          label_text_color: #ffffff;
        }

        .type_button_secondary {
          background_color: #ffffff;
          border_color: token(border);
          border_width: 1;
          label_type_role: button_label;
          label_text_color: #1f2937;
        }

        .type_input_shell {
          background_color: #ffffffd8;
          border_color: token(border);
          border_width: 1;
        }
    """

    nav = bui.Row(
        bui.Text("ButterflyUI", type_role="title", color=INK),
        bui.Row(
            bui.Text("Type roles", class_name="type_nav"),
            bui.Text("Inputs", class_name="type_nav"),
            bui.Text("Buttons", class_name="type_nav"),
            bui.Text("Docs", class_name="type_nav"),
            spacing=24,
        ),
        bui.Button("Open docs", class_name="type_button_secondary rounded-full px-5 py-3"),
        alignment="space_between",
    )

    hero = _panel(
        bui.Text("Typography-first Styling", class_name="type_kicker"),
        bui.Text(
            "Named type roles keep headings, body text, button labels, captions, and helpers on the same token model.",
            type_role="display_hero",
            align="left",
            class_name="max-w-5xl",
            color=INK,
        ),
        bui.Text(
            "This example uses the Styling engine directly: role declarations in the stylesheet, utility classes, and explicit type_role assignments on controls.",
            type_role="body_lg",
            color=MUTED,
            class_name="max-w-3xl",
        ),
        bui.Row(
            bui.Button(
                "Launch workspace",
                class_name="type_button_primary rounded-full px-7 py-4 shadow-xl",
            ),
            bui.Button(
                "Inspect roles",
                class_name="type_button_secondary rounded-full px-7 py-4 shadow-lg",
            ),
            spacing=14,
        ),
        class_name="type_shell rounded-3xl px-8 py-8 shadow-xl",
    )

    role_grid = bui.GridView(
        controls=[
            _panel(
                bui.Text("Display hero", type_role="caption", color=MUTED),
                bui.Text("Aurora systems", type_role="display"),
                bui.Text("Large editorial hero role for the strongest page title.", class_name="type_helper"),
            ),
            _panel(
                bui.Text("Headline", type_role="caption", color=MUTED),
                bui.Text("Command center", type_role="headline"),
                bui.Text("Dense section heading for cards and major subsections.", class_name="type_helper"),
            ),
            _panel(
                bui.Text("Body", type_role="caption", color=MUTED),
                bui.Text("Body text stays readable and consistent across controls.", type_role="body"),
                bui.Text("Helper", type_role="helper"),
            ),
            _panel(
                bui.Text("Caption and overline", type_role="caption", color=MUTED),
                bui.Text("SYSTEM STATUS", class_name="type_kicker"),
                bui.Text("Quiet metadata and labels inherit the same typography tokens.", type_role="caption"),
            ),
        ],
        columns=2,
        spacing=18,
        run_spacing=18,
        shrink_wrap=True,
        scrollable=False,
    )

    input_panel = _panel(
        bui.Text("Inputs and helper text", type_role="heading"),
        bui.Text(
            "Labels, values, placeholders, and helpers now resolve through the same named type roles.",
            class_name="type_helper",
        ),
        bui.TextField(
            label="Project name",
            placeholder="Genesis shell",
            helper_text="Uses input, caption, and helper type roles together.",
            value="Genesis Studio",
            style=bui.Style(
                slots={
                    "label": {"type_role": "caption"},
                    "placeholder": {"type_role": "helper"},
                    "helper": {"type_role": "helper"},
                    "field": {"type_role": "input"},
                }
            ),
            class_name="type_input_shell rounded-2xl",
        ),
        bui.Select(
            label="Density",
            helper_text="Select inherits the same input type tokens.",
            value="comfortable",
            options=[
                bui.Option("comfortable", "Comfortable"),
                bui.Option("compact", "Compact"),
                bui.Option("tight", "Tight"),
            ],
            style=bui.Style(
                slots={
                    "label": {"type_role": "caption"},
                    "placeholder": {"type_role": "helper"},
                    "helper": {"type_role": "helper"},
                    "field": {"type_role": "input"},
                }
            ),
            class_name="type_input_shell rounded-2xl",
        ),
    )

    content = bui.ScrollView(
        bui.Column(
            bui.Container(
                bui.Column(
                    nav,
                    hero,
                    role_grid,
                    input_panel,
                    spacing=22,
                ),
                max_width=1280,
                alignment="center",
            ),
            spacing=0,
        ),
        padding={"x": 24, "top": 18, "bottom": 30},
    )
    page.root = content
    return content


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run the ButterflyUI typography roles example."
    )
    parser.add_argument(
        "--target",
        choices=("desktop", "web"),
        default="desktop",
        help="Runtime target.",
    )
    args = parser.parse_args()

    if args.target == "web":
        bui.run_web(build_page)
        return
    bui.run_desktop(build_page)


if __name__ == "__main__":
    main()
