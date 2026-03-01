from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PreviewSurface"]

class PreviewSurface(Component):
    """
    Overlay surface for displaying a live or static content preview.

    The runtime renders a floating preview pane. ``source`` provides a
    URL or asset path for an image or media preview. ``loading`` shows a
    loading indicator while content fetches. ``title`` and ``subtitle``
    label the preview panel header.

    ```python
    import butterflyui as bui

    bui.PreviewSurface(
        source="https://example.com/thumbnail.png",
        title="Image Preview",
        loading=False,
        events=["close"],
    )
    ```

    Args:
        source:
            URL or asset path of the content to preview.
        loading:
            When ``True`` a loading spinner is shown in place of the content.
        title:
            Heading text displayed in the preview panel header.
        subtitle:
            Secondary text shown below the title.
        events:
            List of event names the Flutter runtime should emit to Python.
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
