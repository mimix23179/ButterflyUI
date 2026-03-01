from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PreviewSurface"]

class PreviewSurface(Component):
    """Surface that renders a live or static preview of external content.

    Displays a preview frame inside the Flutter widget tree with optional
    loading state and descriptive labels.

    Example:
        ```python
        surface = PreviewSurface(source="https://example.com", title="Preview")
        ```

    Args:
        source: URL or identifier of the content to preview.
        loading: Whether the preview is in a loading state.
        title: Title label displayed with the preview.
        subtitle: Subtitle label displayed below the title.
        events: Flutter client events to subscribe to.
    """

    control_type = "preview_surface"

    def __init__(
        self,
        child: Any | None = None,
        *,
        source: str | None = None,
        loading: bool | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            source=source,
            loading=loading,
            title=title,
            subtitle=subtitle,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
