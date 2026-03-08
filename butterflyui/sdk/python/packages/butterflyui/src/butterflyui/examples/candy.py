from __future__ import annotations

import argparse

import butterflyui as bui


INK = "#F8FBFF"
TEXT = "#D9E6FF"
MUTED = "#9DB0D9"
CYAN = "#41C8FF"
VIOLET = "#715DFF"
EMERALD = "#37D39A"
GOLD = "#F6C76A"


def _gradient(*colors: str) -> bui.LinearGradient:
    return bui.LinearGradient(colors=list(colors), begin="top_left", end="bottom_right")


def _shadow(color: str, *, dx: float = 0, dy: float = 16, blur: float = 36) -> bui.BoxShadow:
    return bui.BoxShadow(color=color, offset=(dx, dy), blur=blur)


def _glow(color: str, *, blur: float = 28, spread: float = 1.4, opacity: float = 0.2) -> dict[str, object]:
    return {
        "type": "glow",
        "color": color,
        "blur": blur,
        "spread": spread,
        "opacity": opacity,
    }


def _section(title: str, subtitle: str, content: bui.Control) -> bui.Control:
    return bui.Surface(
        bui.Column(
            bui.Text(title, size=22, weight="700", color=INK),
            bui.Text(subtitle, size=12, color=MUTED),
            content,
            spacing=14,
        ),
        padding=22,
        bgcolor="#0D1630",
        gradient=_gradient("#121F3A", "#14284A"),
        shadow=[_shadow("#060E1988"), _shadow("#263A7A2C", dy=0, blur=22)],
        radius=28,
        effects=[_glow("#3B82F61A", blur=22, spread=0.6, opacity=0.1)],
    )


def _chip(label: str, *, bgcolor: str, color: str = "#FFFFFF") -> bui.Control:
    return bui.Surface(
        bui.Text(label, size=11, weight="700", color=color),
        padding={"x": 10, "y": 6},
        bgcolor=bgcolor,
        radius=999,
        shadow=_shadow("#06101B28", dy=6, blur=14),
    )


def build_page() -> bui.Control:
    galaxy_scene = bui.CandyScene().add_layers(
        bui.CandyLayer(
            "nebula",
            color="#1C1048",
            accent_color="#52CFFF",
            opacity=0.86,
            density=0.84,
            intensity=0.96,
        ),
        bui.CandyLayer(
            "starfield",
            color="#FFFFFF",
            accent_color="#89E8FF",
            opacity=0.92,
            density=0.75,
            speed=0.2,
        ),
    )
    matrix_scene = bui.CandyScene().add_layers(
        bui.CandyLayer(
            "matrix_rain",
            color="#33FFAD",
            accent_color="#D4FFE8",
            opacity=0.9,
            density=0.96,
            speed=0.85,
        )
    )

    workspace = bui.CandyScope(
        bui.Surface(
            bui.Column(
                bui.Row(
                    bui.Text("Creative workspace", size=22, weight="800", color=INK),
                    _chip("Candy enhances layout", bgcolor="#1C2E58"),
                    spacing=10,
                ),
                bui.Text(
                    "This is ordinary ButterflyUI layout with Candy layered on top for motion, atmosphere, and interaction polish.",
                    size=13,
                    color=TEXT,
                ),
                bui.TextField(
                    value="Search scenes, presets, actors, and layers",
                    label="Workspace command",
                    helper_text="Candy should feel like cinematic polish, not a replacement for your real UI structure.",
                    radius=16,
                ),
                bui.Row(
                    bui.Button(
                        text="Create scene",
                        variant="filled",
                        radius=16,
                        gradient=_gradient("#5D56FF", "#7E63FF"),
                        shadow=_shadow("#6A5EFF44", dy=10, blur=20),
                    ),
                    bui.Button(
                        text="Preview layer",
                        variant="outlined",
                        radius=16,
                        bgcolor="#11203D",
                        color=INK,
                        shadow=_shadow("#4FC6FF22", dy=8, blur=18),
                    ),
                    bui.Button(text="Inspect actor", variant="text", radius=16),
                    spacing=10,
                ),
                bui.Row(
                    _chip("ambient: galaxy", bgcolor="#1A2752"),
                    _chip("reactive: hover tilt", bgcolor="#1D3450"),
                    _chip("decor: shimmer glow", bgcolor="#35224B"),
                    spacing=10,
                ),
                spacing=14,
            ),
            padding=22,
            bgcolor="#091326",
            gradient=_gradient("#0E1A33", "#12264A"),
            shadow=[_shadow("#040A146E"), _shadow("#49C9FF1E", dy=0, blur=28)],
            effects=[_glow(CYAN, blur=32, spread=1.6, opacity=0.14)],
            radius=24,
        ),
        scene=galaxy_scene,
        preset="galaxy",
        ambient=["vignette"],
        reactive=["hover_tilt", "magnetic_pull"],
        decor=["shimmer_glow"],
        actor={
            "label": "Nova",
            "icon": "auto_awesome",
            "alignment": "top_right",
            "bgcolor": "#102341",
            "color": "#F8FBFF",
        },
        target="surface",
        mode="enhance",
    )

    diagnostics = bui.CandyScope(
        bui.Surface(
            bui.Column(
                bui.Row(
                    bui.Text("Matrix diagnostics", size=20, weight="800", color=INK),
                    _chip("native painter scene", bgcolor="#163B32", color="#DFFFF3"),
                    spacing=10,
                ),
                bui.Text(
                    "CandyScene can carry explicit layer definitions, not just presets. This uses a hand-authored matrix rain layer behind a status panel.",
                    size=12,
                    color=TEXT,
                ),
                bui.Row(
                    bui.Surface(
                        bui.Text("Render load: 23%", size=13, weight="700", color=INK),
                        padding=14,
                        bgcolor="#10223A",
                        shadow=_shadow("#36D39920", dy=8, blur=18),
                        radius=16,
                    ),
                    bui.Surface(
                        bui.Text("Scene fps: 60", size=13, weight="700", color=INK),
                        padding=14,
                        bgcolor="#10223A",
                        shadow=_shadow("#57C7FF1E", dy=8, blur=18),
                        radius=16,
                    ),
                    spacing=12,
                ),
                spacing=14,
            ),
            padding=22,
            bgcolor="#08111F",
            shadow=[_shadow("#06101994"), _shadow("#34D3991F", dy=0, blur=26)],
            radius=24,
        ),
        scene=matrix_scene,
        preset="matrix_rain",
        decor=["glow"],
        mode="enhance",
        target="surface",
    )

    candy_bridge = bui.Candy(
        bui.Text("Low-level Candy bridge", size=16, weight="700", color=INK),
        bui.Text(
            "Candy stays usable directly when you want one enhanced runtime node instead of a whole scope.",
            size=12,
            color=TEXT,
        ),
        module="column",
        spacing=10,
        padding=18,
        radius=20,
        bgcolor="#0E1C36",
        scene_layers=[
            {"type": "nebula", "color": "#20104D", "accent_color": CYAN, "opacity": 0.72},
        ],
        reactive=["glow"],
        decor=["shimmer_glow"],
        effects=[_glow(VIOLET, blur=24, spread=1.2, opacity=0.12)],
        shadow=[_shadow("#050D177A"), _shadow("#5D5BFF22", dy=0, blur=22)],
    )

    return bui.ScrollView(
        bui.Column(
            _section(
                "Candy Example",
                "Candy enhances controls and layouts with cinematic scene layers, reactive polish, and decorative actors.",
                workspace,
            ),
            _section(
                "Explicit Scene Layers",
                "Use CandyScene and CandyLayer when you want direct control over the visual stack instead of relying only on presets.",
                diagnostics,
            ),
            _section(
                "Low-Level Bridge",
                "The main Candy control still exists for direct runtime-module usage.",
                candy_bridge,
            ),
            spacing=18,
        ),
        expand=True,
        padding=20,
        spacing=20,
        bgcolor="#060D1C",
    )


def main(page: bui.Page) -> None:
    page.title = "ButterflyUI Candy Example"
    page.style_pack = "base"
    page.set_root(build_page())
    page.update()


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run the ButterflyUI Candy example.")
    parser.add_argument(
        "--target",
        default="desktop",
        choices=["desktop", "web"],
        help="Runtime target.",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = _parse_args()
    bui.app(main, target=args.target)
