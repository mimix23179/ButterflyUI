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


SURFACE = "#F7F5F1"
INK = "#10131C"
MUTED = "#5F6678"
CYAN = "#3B82F6"
VIOLET = "#6D5DFB"
ROSE = "#F43F5E"
AMBER = "#F59E0B"
LIME = "#C7D84A"


def _shadow(
    color: str,
    *,
    dx: float = 0,
    dy: float = 16,
    blur: float = 36,
    spread: float = 0,
) -> bui.BoxShadow:
    return bui.BoxShadow(color=color, offset=(dx, dy), blur=blur, spread=spread)


def _gradient(*colors: str, begin: str = "top_left", end: str = "bottom_right") -> bui.LinearGradient:
    return bui.LinearGradient(colors=list(colors), begin=begin, end=end)


def _nav_link(label: str) -> bui.Control:
    return bui.Text(
        label,
        size=15,
        weight="500",
        color=INK,
        class_name="nav_link",
    )


def _metric(label: str, value: str) -> bui.Control:
    return bui.Container(
        bui.Column(
            bui.Text(label, size=12, color=MUTED),
            bui.Text(value, size=18, weight="700", color=INK),
            spacing=4,
        ),
        class_name="metric_card rounded-2xl px-4 py-3 shadow-lg",
    )


def _feature_card(title: str, body: str, class_name: str) -> bui.Control:
    return bui.Container(
        bui.Column(
            bui.Text(title, size=22, weight="700", color=INK),
            bui.Text(body, size=14, color=MUTED),
            spacing=10,
        ),
        class_name=class_name,
    )


def _pill_button(label: str, *, dark: bool = False) -> bui.Control:
    if dark:
        return bui.Button(
            label,
            class_name="cta_primary rounded-full px-7 py-4 shadow-xl",
        )
    return bui.Button(
        label,
        class_name="cta_secondary rounded-full px-7 py-4 shadow-lg",
    )


def build_page(page: bui.Page) -> bui.Control:
    page.title = "ButterflyUI Styling Landing Page"
    page.bgcolor = SURFACE
    page.stylesheet = """
        :root {
          --surface: #f7f5f1;
          --background: #f7f5f1;
          --text: #10131c;
          --muted_text: #5f6678;
          --border: #1118271a;
          --primary: #111218;
          --radius_md: 18;
          --radius_lg: 28;
        }

        .nav_link {
          text_color: #20232d;
        }

        .nav_link:hover {
          text_color: #2563eb;
        }

        .glass_card {
          background_color: #ffffffc2;
          border_color: #11182714;
          border_width: 1;
        }

        .metric_card:hover {
          translate_y: -4;
          border_color: #2563eb33;
        }

        .hero_shell {
          background_color: #ffffffe0;
          border_color: #ffffff9a;
          border_width: 1;
          scene_scrim_color: #ffffff;
          scene_scrim_opacity: 0.16;
          scene_opacity: 0.88;
        }

        .hero_badge {
          background_color: #eef35b;
          border_color: #11182712;
          border_width: 1;
          label_text_color: #2b5dd8;
        }

        Button.cta_primary {
          background_color: #111218;
          border_color: #111218;
          border_width: 1;
          label_text_color: #ffffff;
          label_font_size: 17;
          label_font_weight: 700;
        }

        Button.cta_primary:hover {
          translate_y: -1;
        }

        Button.cta_secondary {
          background_color: #ffffffe0;
          border_color: #10131c14;
          border_width: 1;
          label_text_color: #222531;
          label_font_size: 17;
          label_font_weight: 500;
        }

        Button.cta_secondary:hover {
          background_color: #ffffff;
          translate_y: -1;
        }

        .hero_tag_primary {
          background_color: #eef35bcc;
          border_color: #27469022;
          border_width: 1;
        }

        .hero_tag_secondary {
          background_color: #fff7a8cc;
          border_color: #5b21b622;
          border_width: 1;
        }

        .feature_card_primary {
          background_color: #eef35bcc;
          border_color: #11182714;
          border_width: 1;
        }

        .feature_card_secondary {
          background_color: #fff4aacc;
          border_color: #11182714;
          border_width: 1;
        }

        .hero_feature_card {
          radius: 28;
          padding: 24;
        }

        @md #hero_title {
          font_size: 104;
        }

        @lg #hero_title {
          font_size: 118;
          max_width: 1040;
        }
    """

    background_layers = [
        bui.GradientWash(
            bui.RadialGradient(
                colors=["#FFFFFF", "#F7F5F1"],
                center={"x": 0.5, "y": 0.34},
                radius=0.92,
            ),
            opacity=0.98,
        ),
        bui.GradientWash(
            _gradient("#FFFFFF", "#F3F7FF", "#FFF7E8", begin="top_left", end="bottom_right"),
            opacity=0.34,
        ),
        bui.ParticleField(
            count=88,
            density=1.0,
            intensity=0.52,
            speed=0.24,
            center={"x": 0.16, "y": 0.48},
            length=11,
            thickness=1.5,
            rotation=0.22,
            drift=0.12,
            palette=[CYAN, VIOLET, ROSE, AMBER],
            opacity=0.64,
        ),
        bui.ParticleField(
            count=94,
            density=1.0,
            intensity=0.54,
            speed=0.27,
            center={"x": 0.84, "y": 0.43},
            length=11,
            thickness=1.5,
            rotation=1.28,
            drift=0.13,
            palette=[CYAN, VIOLET, ROSE, AMBER],
            opacity=0.66,
        ),
        bui.LineField(
            count=24,
            direction="diagonal",
            length=28,
            thickness=1.0,
            palette=["#11182710", "#3B82F620"],
            opacity=0.18,
        ),
        bui.NoiseField(
            opacity=0.07,
            scale=1.1,
            contrast=0.1,
            color="#D7DCE6",
            accent_color="#FFFFFF",
        ),
    ]

    nav = bui.Row(
        bui.Text("ButterflyUI", size=26, weight="700", color=INK),
        bui.Row(
            _nav_link("Product"),
            _nav_link("Use Cases"),
            _nav_link("Pricing"),
            _nav_link("Blog"),
            _nav_link("Resources"),
            spacing=26,
        ),
        _pill_button("Download", dark=True),
        alignment="space_between",
    )

    hero_content = bui.Column(
        bui.Container(
            bui.Text("Built with ButterflyUI", size=17, weight="600", color="#2B5DD8"),
            class_name="hero_badge rounded-full px-5 py-3 shadow-lg",
        ),
        bui.Container(
            bui.Text(
                "Design polished\ninterfaces with\ndirect Python styling.",
                color=INK,
                align="center",
                id="hero_title",
                class_name="text-display md:text-8xl tracking-tight leading-none font-bold mx-auto",
            ),
            class_name="max-w-6xl mx-auto",
        ),
        bui.Container(
            bui.Text(
                "Compose layouts, layer authored scene fields, and style every surface, button, and input through one Styling system.",
                color=MUTED,
                align="center",
                class_name="text-body md:text-xl leading-relaxed",
            ),
            class_name="max-w-3xl mx-auto",
        ),
        bui.Row(
            _pill_button("Download for Windows", dark=True),
            _pill_button("Explore use cases"),
            class_name="gap-4",
            alignment="center",
        ),
        bui.Row(
            bui.Container(
                bui.Text("No preset required", size=13, weight="600", color="#274690"),
                class_name="hero_tag_primary rounded-full px-4 py-3 shadow-md",
            ),
            bui.Container(
                bui.Text("ParticleField + GradientWash", size=13, weight="600", color="#5B21B6"),
                class_name="hero_tag_secondary rounded-full px-4 py-3 shadow-md",
            ),
            spacing=12,
            alignment="center",
        ),
        bui.Row(
            bui.Container(_metric("Active rules", "14"), class_name="metric_card"),
            bui.Container(_metric("Scene layers", "5"), class_name="metric_card"),
            bui.Container(_metric("Page width", "1320px"), class_name="metric_card"),
            spacing=16,
            alignment="center",
        ),
        bui.Row(
            _feature_card(
                "Author scenes directly",
                "Typed scene layers let you code motion fields and atmospheric washes without named presets.",
                "glass_card feature_card_primary hero_feature_card",
            ),
            _feature_card(
                "CSS-like, Flutter-native",
                "Selectors, utility classes, local Style objects, and real scene layers compose into one system.",
                "glass_card feature_card_secondary hero_feature_card",
            ),
            spacing=18,
        ),
        spacing=24,
        alignment="center",
    )

    hero = bui.Container(
        bui.Column(
            nav,
            bui.Expanded(
                bui.Center(hero_content),
            ),
            spacing=28,
        ),
        class_name="hero_shell rounded-3xl shadow-2xl",
        style=bui.Style(
            background_layers=background_layers,
            min_height=700,
            padding={"x": 48, "top": 28, "bottom": 44},
            overflow="hidden",
        ),
        clip_behavior="anti_alias",
    )

    content = bui.ScrollView(
        bui.Column(
            bui.Container(
                bui.Column(
                    hero,
                    spacing=0,
                ),
                max_width=1360,
                alignment="center",
            ),
            spacing=0,
        ),
        padding={"x": 22, "top": 18, "bottom": 34},
    )
    page.root = content
    return content


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run the ButterflyUI stylesheet landing-page example."
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
