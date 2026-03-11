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


def _pane(title: str, body: str, class_name: str = "") -> bui.Control:
    return bui.Surface(
        bui.Column(
            bui.Text(title, type_role="title"),
            bui.Text(body, type_role="helper"),
            spacing=8,
        ),
        class_name=f"tool_panel rounded-2xl px-4 py-4 {class_name}".strip(),
        radius=20,
    )


def build_page(page: bui.Page) -> bui.Control:
    page.title = "ButterflyUI Dense Desktop Tool"
    page.bgcolor = "#0D1117"
    page.stylesheet = """
        :root {
          --background: #0d1117;
          --surface: #111827;
          --surface_alt: #182235;
          --text: #e5eefc;
          --muted_text: #90a1bc;
          --border: #ffffff16;
          --primary: #4f46e5;
          --radius_md: 16;
          --radius_lg: 20;
        }

        .tool_shell { background_color: #0f1522; border_color: token(border); border_width: 1; }
        .tool_sidebar { background_color: #0f1b2e; border_color: token(border); border_width: 1; }
        .tool_panel { background_color: token(surface); border_color: token(border); border_width: 1; }
        .tool_tab { background_color: #ffffff08; border_color: token(border); border_width: 1; }
        .tool_tab_active { background_color: token(primary); border_color: token(primary); label_text_color: #ffffff; }
        .tool_button { background_color: #ffffff0b; border_color: token(border); border_width: 1; label_text_color: token(text); }
    """

    shell = bui.ScrollView(
        bui.Surface(
            bui.Column(
                bui.Row(
                    bui.Text("Aurora Forge", type_role="title"),
                    bui.Row(
                        bui.Button("Run", class_name="tool_button rounded-xl px-4 py-3"),
                        bui.Button("Ship", class_name="tool_tab_active rounded-xl px-4 py-3"),
                        spacing=10,
                    ),
                    alignment="space_between",
                ),
                bui.Row(
                    bui.Surface(
                        bui.Column(
                            bui.Text("Workspace", type_role="caption"),
                            bui.Text("Explorer", type_role="body"),
                            bui.Text("Search", type_role="body"),
                            bui.Text("Tokens", type_role="body"),
                            bui.Text("Settings", type_role="body"),
                            spacing=10,
                        ),
                        class_name="tool_sidebar rounded-2xl px-4 py-4",
                        radius=18,
                        width=220,
                    ),
                    bui.Column(
                        bui.Row(
                            bui.Surface(bui.Text("app.py"), class_name="tool_tab_active rounded-xl px-4 py-3"),
                            bui.Surface(bui.Text("theme.tokens"), class_name="tool_tab rounded-xl px-4 py-3"),
                            bui.Surface(bui.Text("preview"), class_name="tool_tab rounded-xl px-4 py-3"),
                            spacing=10,
                        ),
                        bui.Row(
                            _pane(
                                "Editor",
                                "Dense control shells still go through the same Styling token model.",
                                class_name="min-h-80",
                            ),
                            bui.Column(
                                _pane("Inspector", "Spacing, border, and type role controls."),
                                _pane("Console", "Build pipeline and runtime logs."),
                                spacing=12,
                            ),
                            spacing=12,
                        ),
                        _pane("Status dock", "Messages, warnings, and task output stay compact and consistent."),
                        spacing=12,
                        expand=True,
                    ),
                    spacing=12,
                ),
                spacing=12,
            ),
            class_name="tool_shell rounded-3xl px-5 py-5",
            radius=24,
            style=bui.Style(max_width=1380, margin={"x": "auto"}),
        ),
        padding={"x": 20, "top": 20, "bottom": 20},
    )
    page.root = shell
    return shell


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run the ButterflyUI dense desktop tool example."
    )
    parser.add_argument("--target", choices=("desktop", "web"), default="desktop")
    args = parser.parse_args()
    if args.target == "web":
        bui.run_web(build_page)
        return
    bui.run_desktop(build_page)


if __name__ == "__main__":
    main()
