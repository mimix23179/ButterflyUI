from __future__ import annotations

from typing import Any

__all__ = ["StyleProps"]


class StyleProps:
    """Shared ButterflyUI style-system, tokens, and palette props."""

    style_pack: Any = None
    """
    Named or structured style pack applied by the runtime.
    """

    pack: Any = None
    """
    Alias for a style pack or recipe bundle.
    """

    token_overrides: Any = None
    """
    Token override mapping merged into the active style pipeline.
    """

    style_tokens: Any = None
    """
    Explicit style token mapping consumed by the runtime.
    """

    style_slots: Any = None
    """
    Slot-specific style overrides applied by the runtime.
    """

    classes: Any = None
    """
    Recipe or class tokens applied to the control.
    """

    state: str | None = None
    """
    State token forwarded to the runtime styling pipeline.
    """

    variant: Any = None
    """
    Visual variant token used by the runtime.
    """

    tone: str | None = None
    """
    Visual tone token applied by the runtime.
    """

    size: Any = None
    """
    Size token or explicit size value for the control.
    """

    density: Any = None
    """
    Density token applied by the runtime.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the runtime.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the runtime.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the runtime.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the runtime.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the runtime.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the runtime.
    """

    background: Any | None = None
    """
    Background value forwarded to the runtime.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim or backdrop color value forwarded to the runtime.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the runtime.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the runtime.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the runtime.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the runtime.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the runtime.
    """

    decorate_icon: Any | None = None
    """
    Icon decoration descriptor forwarded to the runtime.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the runtime.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the runtime.
    """

    auto_contrast: Any | None = None
    """
    Auto-contrast flag or configuration forwarded to the runtime.
    """

    min_contrast: Any | None = None
    """
    Minimum contrast value forwarded to the runtime.
    """
