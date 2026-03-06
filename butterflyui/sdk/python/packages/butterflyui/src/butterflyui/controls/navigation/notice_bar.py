from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["NoticeBar"]

@butterfly_control('notice_bar')
class NoticeBar(LayoutControl):
    """
    Inline banner for status messages, warnings, and lightweight actions.

    ``NoticeBar`` renders a compact horizontal notification strip. ``variant``
    selects semantic tone, ``icon`` prepends a glyph, ``dismissible`` enables
    close interaction, and ``action_label``/``action_id`` define an inline
    command surface.

    The control accepts shared layout hints through ``props`` so notice bars
    can be aligned and clipped consistently in headers/content regions.

    Example:

    ```python
    import butterflyui as bui

    bui.NoticeBar(
        text="Deployment completed successfully.",
        variant="success",
        icon="check_circle",
        dismissible=True,
        action_label="View logs",
        action_id="open_logs",
        events=["dismiss", "action"],
    )
    ```
    """

    dismissible: bool | None = None
    """
    Shows a close action when ``True``.
    """

    text: str | None = None
    """
    Primary text value rendered by the control.
    """

    icon: str | None = None
    """
    Optional leading icon descriptor.
    """

    action_label: str | None = None
    """
    Label text rendered for the control's inline action when that action is available.
    """

    action_id: str | None = None
    """
    Identifier emitted for the inline action.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `notice_bar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `notice_bar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `notice_bar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `notice_bar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `notice_bar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `notice_bar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `notice_bar` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `notice_bar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `notice_bar` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `notice_bar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `notice_bar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `notice_bar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `notice_bar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `notice_bar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `notice_bar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `notice_bar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `notice_bar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `notice_bar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `notice_bar` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `notice_bar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `notice_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `notice_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `notice_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `notice_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `notice_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `notice_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `notice_bar` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `notice_bar` runtime control.
    """

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )
