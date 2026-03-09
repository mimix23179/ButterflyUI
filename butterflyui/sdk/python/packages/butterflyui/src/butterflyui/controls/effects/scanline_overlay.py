from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ScanlineOverlay"]

@butterfly_control('scanline_overlay', field_aliases={'content': 'child'})
class ScanlineOverlay(EffectControl):
    """
    CRT-style horizontal scanline overlay rendered on top of the
    child content.

    The Flutter runtime paints evenly-spaced horizontal lines using a
    custom ``ButterflyUIScanlineOverlay`` widget.  Line spacing,
    thickness, opacity, and colour are all configurable at creation
    time and can be updated at runtime via the ``set_style()`` invoke
    method.

    Example:

    ```python
    import butterflyui as bui

    crt = bui.ScanlineOverlay(
        bui.Image(src="retro.png"),
        spacing=6,
        thickness=1,
        opacity=0.18,
        color="#00ff00",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    spacing: float | None = None
    """
    Vertical distance between scanlines in logical pixels
    (``1`` – ``256``).  Defaults to ``6``.
    """

    thickness: float | None = None
    """
    Stroke thickness of each scanline (``0.5`` –
    ``32``).  Defaults to ``1``.
    """

    line_thickness: Any | None = None
    """
    Line thickness value forwarded to the `scanline_overlay` runtime control.
    """

    angle: Any | None = None
    """
    Angle value forwarded to the `scanline_overlay` runtime control.
    """

    speed: Any | None = None
    """
    Speed value forwarded to the `scanline_overlay` runtime control.
    """

    blend_mode: Any | None = None
    """
    Blend mode value forwarded to the `scanline_overlay` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

