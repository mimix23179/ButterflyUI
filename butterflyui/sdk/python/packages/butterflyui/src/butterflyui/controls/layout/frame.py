from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Frame"]

@butterfly_control('frame', field_aliases={'content': 'child'})
class Frame(LayoutControl):
    """
    Sized and decorated frame with constraints, spacing, and visual styling.

    The runtime renders a container that applies combined width/height
    constraints (including min/max bounds), padding/margin spacing, background
    color, border, corner radius, and clip behaviour. ``alignment`` positions
    the child within the frame.

    ``Frame`` forwards additional style pipeline props through ``**kwargs``,
    including classes/modifiers/motion/effects plus optional ``icon``,
    ``color``, and ``transparency`` hints.

    Example:

    ```python
    import butterflyui as bui

    bui.Frame(
        bui.Text("Content"),
        width=400,
        min_height=100,
        padding=16,
        bgcolor="#FAFAFA",
        radius=8,
        events=["resize"],
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control's content area.
    """

    border_color: Any | None = None
    """
    Border color applied to the outer edge of the rendered control or decorative surface.
    """

    border_width: float | None = None
    """
    Border stroke width in logical pixels.
    """

    radius: float | None = None
    """
    Corner radius in logical pixels.
    """

    clip_behavior: str | None = None
    """
    Anti-aliasing clip mode. Values: ``"hardEdge"``, ``"antiAlias"``,
    ``"antiAliasWithSaveLayer"``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `frame` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `frame` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `frame` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `frame` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `frame` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `frame` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `frame` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `frame` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `frame` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `frame` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `frame` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `frame` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `frame` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `frame` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `frame` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `frame` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `frame` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `frame` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `frame` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
