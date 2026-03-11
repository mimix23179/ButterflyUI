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


SURFACE = "#0B1020"
PANEL = "#131B34"
TEXT = "#F8FAFC"
MUTED = "#98A2B3"
PRIMARY = "#6D5DFB"
CYAN = "#4CC9F0"
LIME = "#C7F36B"


def _stat_card(label: str, value: str, trend: str, class_name: str = "") -> bui.Control:
    return bui.Surface(
        bui.Column(
            bui.Text(label, type_role="caption", color=MUTED),
            bui.Text(value, type_role="headline", color=TEXT),
            bui.Text(trend, type_role="helper", color="#74E08C"),
            spacing=6,
        ),
        class_name=f"db_stat rounded-3xl px-6 py-5 {class_name}".strip(),
        radius=24,
    )


def build_page(page: bui.Page) -> bui.Control:
    page.title = "ButterflyUI Styling Dashboard"
    page.bgcolor = SURFACE
    page.stylesheet = """
        :root {
          --background: #0b1020;
          --surface: #131b34;
          --surface_alt: #1a2342;
          --text: #f8fafc;
          --muted_text: #98a2b3;
          --border: #ffffff12;
          --primary: #6d5dfb;
          --secondary: #4cc9f0;
          --radius_md: 18;
          --radius_lg: 24;
          --space_md: 16;
          --space_lg: 24;
        }

        .db_shell { background_color: #0f1530e8; border_color: token(border); border_width: 1; }
        .db_sidebar { background_color: #0e1730ee; border_color: token(border); border_width: 1; }
        .db_panel { background_color: token(surface); border_color: token(border); border_width: 1; shadow: 0 14 32 #0000002f; }
        .db_stat { background_color: token(surface_alt); border_color: token(border); border_width: 1; }
        .db_kicker { role: overline; text_color: #7dd3fc; }
        .db_nav { role: nav; text_color: #dbe4ff; }
        Button.db_primary {
          background_color: token(primary);
          border_color: token(primary);
          border_width: 1;
          label_text_color: #ffffff;
          label_type_role: button_label;
        }
        Button.db_secondary {
          background_color: #ffffff10;
          border_color: token(border);
          border_width: 1;
          label_text_color: token(text);
          label_type_role: button_label;
        }
    """

    scene = [
        bui.GradientWash(
            bui.LinearGradient(
                colors=["#0B1020", "#101936", "#0B1020"],
                begin="top_left",
                end="bottom_right",
            ),
            opacity=0.96,
        ),
        bui.OrbitField(
            count=64,
            radius=0.34,
            band_width=0.22,
            marker_size=3.2,
            swirl=0.42,
            palette=[PRIMARY, CYAN, "#FF7AC6", LIME],
            opacity=0.44,
            region=bui.SceneRegion(x=0.58, y=0.08, width=0.35, height=0.42),
            mask=bui.SceneMask(type="oval"),
        ),
    ]

    sidebar = bui.Surface(
        bui.Column(
            bui.Text("Nebula Ops", type_role="title", color=TEXT),
            bui.Text("Live workspace", type_role="helper", color=MUTED),
            bui.Divider(),
            bui.Text("Overview", class_name="db_nav"),
            bui.Text("Traffic", class_name="db_nav"),
            bui.Text("Alerts", class_name="db_nav"),
            bui.Text("Deployments", class_name="db_nav"),
            spacing=12,
        ),
        class_name="db_sidebar rounded-3xl px-5 py-5",
        radius=24,
        width=260,
    )

    body = bui.Column(
        bui.Row(
            bui.Column(
                bui.Text("Operations dashboard", class_name="db_kicker"),
                bui.Text("Track live systems with Styling-first panels.", type_role="display"),
                bui.Text(
                    "Tokens, slots, and authored scene layers make the shell coherent without one-off paint.",
                    type_role="body_lg",
                    color=MUTED,
                    class_name="max-w-2xl",
                ),
                spacing=8,
            ),
            bui.Row(
                bui.Button("Create report", class_name="db_primary rounded-full px-6 py-4"),
                bui.Button("Export", class_name="db_secondary rounded-full px-6 py-4"),
                spacing=12,
            ),
            alignment="space_between",
        ),
        bui.Wrap(
            _stat_card("Requests", "4.2M", "+12.4% vs yesterday"),
            _stat_card("Latency", "42ms", "steady across clusters"),
            _stat_card("Availability", "99.98%", "green across regions"),
            spacing=16,
            run_spacing=16,
        ),
        bui.Row(
            bui.Surface(
                bui.Column(
                    bui.Text("Traffic overview", type_role="headline", color=TEXT),
                    bui.Text("Scene layers stay behind cards while Styling owns the shell.", type_role="helper", color=MUTED),
                    bui.Container(height=280),
                    spacing=10,
                ),
                class_name="db_panel rounded-3xl px-6 py-6",
                radius=24,
                expand=True,
            ),
            bui.Surface(
                bui.Column(
                    bui.Text("Alerts", type_role="headline", color=TEXT),
                    bui.Text("3 high priority incidents", type_role="helper", color=MUTED),
                    bui.Column(
                        bui.Text("Edge router jitter", color=TEXT),
                        bui.Text("Storage cluster rebalance", color=TEXT),
                        bui.Text("Model cache warming", color=TEXT),
                        spacing=10,
                    ),
                    spacing=12,
                ),
                class_name="db_panel rounded-3xl px-6 py-6",
                radius=24,
                width=320,
            ),
            spacing=18,
        ),
        spacing=18,
    )

    root = bui.ScrollView(
        bui.Surface(
            bui.Row(
                sidebar,
                bui.Container(body, expand=True),
                spacing=18,
            ),
            class_name="db_shell rounded-3xl px-5 py-5",
            radius=28,
            style=bui.Style(
                background_layers=scene,
                max_width=1360,
                margin={"x": "auto"},
                overflow="hidden",
            ),
        ),
        padding={"x": 24, "top": 24, "bottom": 24},
    )
    page.root = root
    return root


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run the ButterflyUI Styling dashboard example."
    )
    parser.add_argument("--target", choices=("desktop", "web"), default="desktop")
    args = parser.parse_args()
    if args.target == "web":
        bui.run_web(build_page)
        return
    bui.run_desktop(build_page)


if __name__ == "__main__":
    main()
