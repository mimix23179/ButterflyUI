from __future__ import annotations

import argparse

import butterflyui as bui


def build_page(page: bui.Page) -> None:
    page.title = "ButterflyUI Test App"
    page.padding = 16
    page.bgcolor = "#0B1220"

    form_panel = bui.Container(
        bui.Column(
            bui.Text("Basic Components", size=24, weight="700", color="#E5E7EB"),
            bui.Text(
                "Simple smoke-test screen for core controls.",
                size=13,
                color="#9CA3AF",
            ),
            bui.Row(
                bui.FilledButton("Primary", icon="rocket_launch", action_id="primary_action"),
                bui.OutlinedButton("Outlined", icon="tune", action_id="outlined_action"),
                bui.IconButton(icon="settings", tooltip="Settings", color="#93C5FD"),
                spacing=10,
            ),
            bui.TextField(label="Name", placeholder="Type your name"),
            bui.Row(
                bui.Checkbox(value=True, label="Enable notifications"),
                bui.Switch(value=False, label="Dark mode", inline=True),
                spacing=14,
            ),
            bui.Row(
                bui.Icon(icon="palette", size=18, color="#67E8F9"),
                bui.Color(value="#67E8F9", label="Accent", show_label=True, show_hex=True, size=18),
                spacing=10,
            ),
            bui.Slider(value=35, min=0, max=100, divisions=20, label="Volume"),
            bui.ProgressBar(value=0.65, label="Build progress", stroke_width=8),
            spacing=12,
        ),
        padding=16,
        bgcolor="#111827",
        border_color="#374151",
        border_width=1,
        radius=12,
        transparency=0.05,
    )

    root = bui.Column(
        bui.Text("ButterflyUI", size=32, weight="700", color="#F9FAFB"),
        bui.Text("Local test app", size=14, color="#9CA3AF"),
        form_panel,
        spacing=14,
    )

    page.set_root(root)
    page.update()


def main() -> int:
    parser = argparse.ArgumentParser(description="Run ButterflyUI basic test app")
    parser.add_argument("--target", choices=("desktop", "web"), default="desktop")
    args = parser.parse_args()
    return bui.run(build_page, target=args.target)


if __name__ == "__main__":
    raise SystemExit(main())
