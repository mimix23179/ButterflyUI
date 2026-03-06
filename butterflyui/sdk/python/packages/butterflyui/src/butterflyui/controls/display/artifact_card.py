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

    def set_content(self, session: Any, *, title: str | None = None, message: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if title is not None:
            payload["title"] = title
        if message is not None:
            payload["message"] = message
        return self.invoke(session, "set_content", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
