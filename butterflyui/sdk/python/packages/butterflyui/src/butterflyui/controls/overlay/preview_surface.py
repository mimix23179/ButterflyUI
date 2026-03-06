from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

from ..single_child_control import SingleChildControl
from ..title_control import TitleControl
from ..subtitle_control import SubtitleControl
__all__ = ["PreviewSurface"]

@butterfly_control('preview_surface', field_aliases={'content': 'child'})
class PreviewSurface(OverlayControl, SingleChildControl, TitleControl, SubtitleControl):
    """
    Overlay surface for displaying a live or static content preview.

    The runtime renders a floating preview pane. ``source`` provides a
    URL or asset path for an image or media preview. ``loading`` shows a
    loading indicator while content fetches. ``title`` and ``subtitle``
    label the preview panel header.

    Example:

    ```python
    import butterflyui as bui

    bui.PreviewSurface(
        source="https://example.com/thumbnail.png",
        title="Image Preview",
        loading=False,
        events=["close"],
    )
    ```
    """

    source: str | None = None
    """
    URL or asset path of the content to preview.
    """

    loading: bool | None = None
    """
    When ``True`` a loading spinner is shown in place of the content.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
