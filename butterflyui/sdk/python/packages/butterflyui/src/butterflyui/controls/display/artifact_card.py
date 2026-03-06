from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ArtifactCard"]

@butterfly_control('artifact_card')
class ArtifactCard(LayoutControl):
    """
    Structured output card for displaying generated artifacts.

    Renders a Material ``Card`` with a bold title, body message, and optional
    action button.  When ``clickable`` is enabled the entire card is wrapped
    in an ``InkWell`` that emits a ``"tap"`` event.  The action button is a
    ``TextButton`` that emits ``"action"`` when pressed.  Child controls
    are placed below the message text inside the card body.

    Use ``set_content`` to update the title and message programmatically
    after the card is created, and ``emit`` to fire arbitrary custom events.

    Example:

    ```python
    import butterflyui as bui

    card = bui.ArtifactCard(
        title="Analysis Complete",
        message="3 issues found in your code.",
        action_label="View Details",
        clickable=True,
    )
    ```
    """

    title: str | None = None
    """
    Bold heading text displayed at the top of the card.
    """

    message: str | None = None
    """
    Body text rendered beneath the title.
    """

    label: str | None = None
    """
    Optional short label displayed alongside the title.
    """

    action_label: str | None = None
    """
    Text for the action ``TextButton`` at the bottom. When present the button emits ``"action"`` on click.
    """

    clickable: bool | None = None
    """
    Controls whether the whole card is wrapped in an ``InkWell`` that emits ``"tap"`` on press. Set it to ``False`` to disable this behavior.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `artifact_card` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `artifact_card` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `artifact_card` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `artifact_card` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `artifact_card` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `artifact_card` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `artifact_card` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `artifact_card` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `artifact_card` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `artifact_card` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `artifact_card` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `artifact_card` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `artifact_card` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `artifact_card` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `artifact_card` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `artifact_card` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `artifact_card` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `artifact_card` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `artifact_card` runtime control.
    """

    def set_content(self, session: Any, *, title: str | None = None, message: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if title is not None:
            payload["title"] = title
        if message is not None:
            payload["message"] = message
        return self.invoke(session, "set_content", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
