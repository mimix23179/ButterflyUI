from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Badge"]

@butterfly_control('badge', positional_fields=('label',))
class Badge(LayoutControl):
    """
    Displays a compact label, count, or status indicator.

    The runtime colours the badge according to `severity` (``"success"``,
    ``"warning"``, ``"error"``) or uses explicit `bgcolor` / `color`
    overrides. When `dot` is ``True`` an empty dot indicator is shown
    instead of text. The optional `pulse` flag adds a scale animation.

    If `clickable` is ``True``, a ``"click"`` event is emitted with the
    current display value.

    ```python
    import butterflyui as bui

    bui.Badge("New", severity="success", pulse=True)
    ```
    """

    label: str | None = None
    """
    Display text. Resolved from `text` when ``None``.
    """

    text: str | None = None
    """
    Backward-compatible alias for ``label``. When both fields are provided, ``label`` takes precedence and this alias is kept only for compatibility.
    """

    value: Any | None = None
    """
    Arbitrary value exposed to event payloads and the ``get_value`` / ``set_value`` invoke methods.
    """

    color: Any | None = None
    """
    Foreground (text) colour. Overrides the severity-derived colour.
    """

    bgcolor: Any | None = None
    """
    Background colour. Overrides the severity-derived background.
    """

    text_color: Any | None = None
    """
    Backward-compatible alias for ``color``. When both fields are provided, ``color`` takes precedence and this alias is kept only for compatibility.
    """

    severity: str | None = None
    """
    Semantic severity controlling the theme colour scheme. One of ``"success"``, ``"warning"`` / ``"warn"``, ``"error"`` / ``"danger"``. Defaults to the primary colour.
    """

    dot: bool | None = None
    """
    If ``True``, renders a small coloured dot instead of text.
    """

    pulse: bool | None = None
    """
    If ``True``, the badge animates with a subtle pulse (scale tween).
    """

    count: int | None = None
    """
    When set, overrides the display text with this integer count.
    """

    radius: float | None = None
    """
    Corner radius of the badge container. Defaults to a large pill shape (``999``) or fully round for dots.
    """

    clickable: bool | None = None
    """
    If ``True``, the badge becomes tappable and emits a ``"click"`` event with the current display value.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `badge` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `badge` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `badge` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `badge` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `badge` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `badge` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `badge` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `badge` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `badge` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `badge` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `badge` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `badge` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `badge` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `badge` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `badge` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `badge` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `badge` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `badge` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})
