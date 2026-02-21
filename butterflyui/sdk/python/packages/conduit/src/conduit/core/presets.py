from .style import Style, BoxShadow, LinearGradient

__all__ = [
    "TERMINAL_STYLE",
    "SCIFI_STYLE",
    "RETRO_STYLE",
    "COMFY_STYLE",
    "GLASS_STYLE",
]

TERMINAL_STYLE = Style(
    bgcolor="#000000",
    color="#00FF00",
    font_family="Consolas, monospace",
    radius=0,
    border_width=1,
    border_color="#00FF00",
    shadow=None,
)

SCIFI_STYLE = Style(
    bgcolor="#050a14",
    color="#00ffff",
    border_color="#00ffff",
    border_width=1.0,
    radius=2.0,
    shadow=BoxShadow(color="#00ffff", blur=8.0, spread=0.5),
    font_family="Orbitron, sans-serif",
    elevation=0,
)

RETRO_STYLE = Style(
    bgcolor="#ead4aa",
    color="#5c4033",
    border_color="#8b4513",
    border_width=3.0,
    radius=0,
    font_family="Courier New, monospace",
    shadow=BoxShadow(color="#8b4513", offset=(4, 4), blur=0),
)

COMFY_STYLE = Style(
    bgcolor="#fff5f5",
    color="#5e4b56",
    radius=24.0,
    padding=16,
    shadow=BoxShadow(color="#00000010", blur=12, offset=(0, 6)),
    font_family="Nunito, sans-serif",
)

GLASS_STYLE = Style(
    bgcolor="#ffffff20",
    border_color="#ffffff40",
    border_width=1.0,
    radius=16.0,
    blur=16.0,
    shadow=BoxShadow(color="#00000010", blur=16, offset=(0, 8)),
)
