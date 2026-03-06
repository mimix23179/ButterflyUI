from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["PreviewSurface"]

@butterfly_control('preview_surface', field_aliases={'content': 'child'})
class PreviewSurface(OverlayControl):
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

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    source: str | None = None
    """
    URL or asset path of the content to preview.
    """

    loading: bool | None = None
    """
    When ``True`` a loading spinner is shown in place of the content.
    """

    title: str | None = None
    """
    Heading text displayed in the preview panel header.
    """

    subtitle: str | None = None
    """
    Secondary text shown below the title.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `preview_surface` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `preview_surface` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `preview_surface` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `preview_surface` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `preview_surface` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `preview_surface` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `preview_surface` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `preview_surface` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `preview_surface` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `preview_surface` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `preview_surface` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `preview_surface` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `preview_surface` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `preview_surface` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `preview_surface` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `preview_surface` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `preview_surface` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `preview_surface` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `preview_surface` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
