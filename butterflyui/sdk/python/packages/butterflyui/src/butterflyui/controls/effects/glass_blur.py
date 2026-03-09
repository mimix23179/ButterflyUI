from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["GlassBlur"]

@butterfly_control('glass_blur', field_aliases={'content': 'child'})
class GlassBlur(EffectControl):
    """
    Frosted-glass blur panel built from a ``BackdropFilter`` with an
    optional tinted overlay, rounded corners, border glow, and a
    subtle noise texture.

    The Flutter runtime clips the child to a ``ClipRRect``, applies a
    Gaussian ``BackdropFilter`` blur, then paints a semi-transparent
    colour fill, optional border, optional glow ``BoxShadow``, and an
    optional noise overlay via a ``CustomPaint`` painter.

    Example:

    ```python
    import butterflyui as bui

    glass = bui.GlassBlur(
        bui.Text("Hello"),
        blur=14,
        opacity=0.16,
        radius=12,
        border_color="#ffffff40",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    blur: float | None = None
    """
    Gaussian blur sigma applied to the backdrop.
    Defaults to ``14``.
    """

    noise_opacity: float | None = None
    """
    Opacity of the random-dot noise texture overlay (``0.0`` – ``1.0``).
    ``0`` disables the texture.
    """

    border_glow: Any | None = None
    """
    Optional colour for an outer glow
    ``BoxShadow`` rendered behind the panel.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
