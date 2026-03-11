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


def build_page(page: bui.Page) -> bui.Control:
    page.title = "ButterflyUI Glass UI"
    page.bgcolor = "#08111E"
    page.stylesheet = """
        :root {
          --background: #08111e;
          --surface: #10213acc;
          --surface_alt: #142a46c4;
          --text: #f8fafc;
          --muted_text: #b4c3de;
          --border: #ffffff1c;
          --primary: #8b5cf6;
          --radius_md: 18;
          --radius_lg: 28;
        }

        .glass_shell { background_color: #0f1d3499; border_color: token(border); border_width: 1; backdrop_blur: 16; }
        .glass_card { background_color: token(surface); border_color: token(border); border_width: 1; backdrop_blur: 14; shadow: 0 18 42 #0000003a; }
        .glass_button { background_color: #ffffff12; border_color: token(border); border_width: 1; label_text_color: token(text); }
        .glass_button_primary { background_color: token(primary); border_color: token(primary); label_text_color: #ffffff; }
    """

    scene = [
        bui.GradientWash(
            bui.RadialGradient(
                colors=["#2A4B8D66", "#08111E"],
                center={"x": 0.22, "y": 0.18},
                radius=1.0,
            ),
            opacity=0.9,
        ),
        bui.OrbitField(
            count=56,
            radius=0.28,
            band_width=0.18,
            marker_size=3.8,
            swirl=0.48,
            palette=["#8b5cf6", "#38bdf8", "#ffffff"],
            opacity=0.4,
            region=bui.SceneRegion(x=0.12, y=0.12, width=0.76, height=0.78),
            mask=bui.SceneMask(type="oval"),
        ),
    ]

    content = bui.Column(
        bui.Text("Glass UI surface study", type_role="display_hero", color="#F8FAFC"),
        bui.Text(
            "Backdrop blur, authored scenes, and token-driven surfaces combine into one Styling-first shell.",
            type_role="body_lg",
            color="#C0CEE8",
            class_name="max-w-3xl",
        ),
        bui.Row(
            bui.Button("Open workspace", class_name="glass_button_primary rounded-full px-6 py-4"),
            bui.Button("View tokens", class_name="glass_button rounded-full px-6 py-4"),
            spacing=12,
        ),
        bui.Wrap(
            bui.Surface(
                bui.Column(
                    bui.Text("Layered surfaces", type_role="headline", color="#F8FAFC"),
                    bui.Text(
                        "Cards stay crisp while the authored scene lives beneath them.",
                        type_role="helper",
                        color="#C0CEE8",
                    ),
                    spacing=8,
                ),
                class_name="glass_card rounded-3xl px-6 py-6",
                radius=28,
                width=420,
            ),
            bui.Surface(
                bui.Column(
                    bui.Text("Token-aware", type_role="headline", color="#F8FAFC"),
                    bui.Text(
                        "Colors, borders, radii, and typography all resolve from the same Styling engine.",
                        type_role="helper",
                        color="#C0CEE8",
                    ),
                    spacing=8,
                ),
                class_name="glass_card rounded-3xl px-6 py-6",
                radius=28,
                width=420,
            ),
            spacing=18,
            run_spacing=18,
        ),
        spacing=18,
        alignment="center",
    )

    root = bui.ScrollView(
        bui.Surface(
            bui.Center(
                bui.Container(
                    content,
                    max_width=1180,
                )
            ),
            class_name="glass_shell rounded-3xl px-8 py-8",
            radius=30,
            style=bui.Style(background_layers=scene, overflow="hidden"),
        ),
        padding={"x": 24, "top": 24, "bottom": 24},
    )
    page.root = root
    return root


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the ButterflyUI glass UI example.")
    parser.add_argument("--target", choices=("desktop", "web"), default="desktop")
    args = parser.parse_args()
    if args.target == "web":
        bui.run_web(build_page)
        return
    bui.run_desktop(build_page)


if __name__ == "__main__":
    main()
