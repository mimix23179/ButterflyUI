from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["ScrollableRow"]

@butterfly_control('scrollable_row', field_aliases={'controls': 'children'})
class ScrollableRow(ScrollableControl):
    """
    Horizontally scrollable row of children.

    The runtime renders a horizontal ``ListView``-backed row. ``spacing`` adds
    a gap between children; ``reverse`` flips the scroll direction.
    ``content_padding`` adds padding around the scrollable area.
    ``initial_offset`` sets the starting scroll position.

    Example:

    ```python
    import butterflyui as bui

    bui.ScrollableRow(
        *[bui.Text(f"Tab {i}") for i in range(10)],
        spacing=4,
        events=["scroll"],
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    spacing: float | None = None
    """
    Horizontal gap between children in logical pixels.
    """

    reverse: bool | None = None
    """
    When ``True`` children are laid out in reverse scroll order.
    """

    content_padding: Any | None = None
    """
    Padding applied around the scrollable content area.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `scrollable_row` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `scrollable_row` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `scrollable_row` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `scrollable_row` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `scrollable_row` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `scrollable_row` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `scrollable_row` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `scrollable_row` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `scrollable_row` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `scrollable_row` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `scrollable_row` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `scrollable_row` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `scrollable_row` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `scrollable_row` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `scrollable_row` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `scrollable_row` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `scrollable_row` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `scrollable_row` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `scrollable_row` runtime control.
    """

    def get_scroll_metrics(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_scroll_metrics", {})

    def scroll_to(
        self,
        session: Any,
        offset: float,
        *,
        animate: bool = True,
        duration_ms: int = 250,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_to",
            {
                "offset": offset,
                "animate": animate,
                "duration_ms": duration_ms,
            },
        )

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})
