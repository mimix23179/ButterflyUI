from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .wrap import Wrap

__all__ = ["ResponsiveRow"]


class ResponsiveRow(Wrap):
    """
    Horizontal flow layout that automatically wraps children onto new lines.

    ``ResponsiveRow`` is a first-class ``Wrap`` wrapper that always uses
    ``direction="horizontal"`` and serializes as
    ``control_type="responsive_row"``.

    This makes it useful for responsive toolbars, chip groups, and card
    clusters where content should flow naturally as width changes.

    ```python
    import butterflyui as bui

    bui.ResponsiveRow(
        *[bui.Chip(label=f"Tag {i}") for i in range(12)],
        spacing=8,
        run_spacing=8,
        alignment="start",
    )
    ```

    Args:
        spacing:
            Gap between children within the same row.
        run_spacing:
            Vertical gap between wrapped rows.
        alignment:
            Main-axis alignment of children inside each row.
        run_alignment:
            Alignment of wrapped rows along the cross axis.
        cross_axis:
            Cross-axis alignment of children within each row.
    """

    control_type = "responsive_row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        run_spacing: float | None = None,
        alignment: str | None = None,
        run_alignment: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            spacing=spacing,
            run_spacing=run_spacing,
            alignment=alignment,
            run_alignment=run_alignment,
            cross_axis=cross_axis,
            direction="horizontal",
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
