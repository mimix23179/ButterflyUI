from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BlobField"]

@butterfly_control('blob_field')
class BlobField(LayoutControl):
    """
    Paints a field of random organic blobs on a ``CustomPaint`` canvas.

    Each blob is a filled circle with a Gaussian blur mask, producing soft,
    lava-lamp-like shapes. The seed and count control the deterministic
    layout; `progress` (``0.0``–``1.0``) controls how much of the field is
    drawn.

    ```python
    import butterflyui as bui

    bui.BlobField(
        count=16,
        seed=42,
        color="#8b5cf6",
        opacity=0.35,
    )
    ```
    """

    count: int | None = None
    """
    Number of blobs to generate. Defaults to ``12``.
    """

    seed: int | None = None
    """
    Random seed controlling blob positions and sizes. Defaults to ``7``. Change it to produce a new random layout.
    """

    color: Any | None = None
    """
    Primary colour for the blobs (hex string or colour object). Defaults to ``"#8b5cf6"`` (violet).
    """

    colors: list[Any] | None = None
    """
    Optional list of colours. When provided, each blob picks from this palette.
    """

    background: Any | None = None
    """
    Colour painted behind the blob field.
    """

    min_radius: float | None = None
    """
    Minimum blob radius as a fraction of the canvas size. Defaults to ``0.05``.
    """

    max_radius: float | None = None
    """
    Maximum blob radius as a fraction of the canvas size. Defaults to ``0.2``.
    """

    speed: float | None = None
    """
    Animation speed multiplier for blob motion.
    """

    blur_sigma: float | None = None
    """
    Gaussian blur sigma applied to each blob’s mask filter. Higher values produce softer edges.
    """

    loop: bool | None = None
    """
    If ``True``, the animation loops continuously.
    """

    play: bool | None = None
    """
    Backward-compatible alias for ``playing``. When both fields are provided, ``playing`` takes precedence and this alias is kept only for compatibility.
    """

    playing: bool | None = None
    """
    Controls whether any animation is running.
    """

    autoplay: bool | None = None
    """
    If ``True``, the animation starts automatically on mount.
    """

    progress: float | None = None
    """
    Draw progress from ``0.0`` (nothing) to ``1.0`` (full field). Defaults to ``1.0``.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `blob_field` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `blob_field` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `blob_field` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `blob_field` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `blob_field` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `blob_field` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `blob_field` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `blob_field` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `blob_field` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `blob_field` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `blob_field` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `blob_field` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `blob_field` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `blob_field` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `blob_field` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `blob_field` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `blob_field` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `blob_field` runtime control.
    """

    def regenerate(self, session: Any, seed: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if seed is not None:
            payload["seed"] = seed
        return self.invoke(session, "regenerate", payload)

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})

    def set_progress(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"value": float(value)})

    def set_playing(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_playing", {"value": bool(value)})
