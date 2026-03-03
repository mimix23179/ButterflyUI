from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .view_stack import ViewStack

__all__ = ["PageView"]


class PageView(ViewStack):
    """
    Paged container that shows one child at a time by active index.

    ``PageView`` wraps ``ViewStack`` and serializes as
    ``control_type="page_view"`` so the renderer can dispatch to the
    dedicated page-view builder.  It supports index-based page switching with
    optional animated transitions and optional off-screen state retention.

    Invoke helpers such as ``set_index()`` and ``get_state()`` are inherited
    from ``ViewStack``.

    ```python
    import butterflyui as bui

    bui.PageView(
        bui.Text("Overview"),
        bui.Text("Details"),
        index=0,
        animate=True,
        duration_ms=240,
        events=["change"],
    )
    ```

    Args:
        index:
            Zero-based index of the visible page.
        animate:
            If ``True``, page changes animate instead of switching instantly.
        duration_ms:
            Transition duration in milliseconds.
        keep_alive:
            If ``True``, keeps non-visible pages mounted.
        events:
            Runtime event names that should be emitted to Python.
    """

    control_type = "page_view"

    def __init__(
        self,
        *children: Any,
        index: int | None = None,
        animate: bool | None = None,
        duration_ms: int | None = None,
        keep_alive: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            index=index,
            animate=animate,
            duration_ms=duration_ms,
            keep_alive=keep_alive,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
