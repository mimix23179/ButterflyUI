from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .divider import Divider

__all__ = ["VerticalDivider"]


class VerticalDivider(Divider):
    """
    Vertical line separator for splitting content in horizontal layouts.

    ``VerticalDivider`` is a dedicated wrapper around ``Divider`` that always
    sets ``vertical=True`` and serializes as
    ``control_type="vertical_divider"``.

    Use it between panels, tool groups, or side-by-side cards where a visual
    separator is needed without introducing additional layout controls.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.VerticalDivider(thickness=1.5, indent=8, end_indent=8),
        bui.Text("Right"),
    )
    ```

    Args:
        thickness:
            Line thickness in logical pixels.
        indent:
            Leading inset before the divider starts.
        end_indent:
            Trailing inset before the divider ends.
        color:
            Divider color value passed to the runtime.
    """

    control_type = "vertical_divider"

    def __init__(
        self,
        *,
        thickness: float | None = None,
        indent: float | None = None,
        end_indent: float | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            vertical=True,
            thickness=thickness,
            indent=indent,
            end_indent=end_indent,
            color=color,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
