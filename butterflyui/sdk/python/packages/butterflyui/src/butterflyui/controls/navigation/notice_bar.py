from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NoticeBar"]


class NoticeBar(Component):
    """
    Inline banner for status messages, warnings, and lightweight actions.

    ``NoticeBar`` renders a compact horizontal notification strip. ``variant``
    selects semantic tone, ``icon`` prepends a glyph, ``dismissible`` enables
    close interaction, and ``action_label``/``action_id`` define an inline
    command surface.

    The control accepts shared layout hints through ``props`` so notice bars
    can be aligned and clipped consistently in headers/content regions.

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

    Args:
        text:
            Notice message text.
        variant:
            Semantic tone token (for example ``"info"``, ``"success"``,
            ``"warning"``, ``"error"``).
        icon:
            Optional leading icon descriptor.
        dismissible:
            Shows a close action when ``True``.
        action_label:
            Optional inline action label.
        action_id:
            Identifier emitted for the inline action.
        events:
            Runtime events the control may emit.
        props:
            Additional props, including layout/placement hints.
    """


    dismissible: bool | None = None
    """
    Shows a close action when ``True``.
    """


    text: str | None = None
    """
    Notice message text.
    """

    variant: str | None = None
    """
    Semantic tone token (for example ``"info"``, ``"success"``,
    ``"warning"``, ``"error"``).
    """

    icon: str | None = None
    """
    Optional leading icon descriptor.
    """

    action_label: str | None = None
    """
    Optional inline action label.
    """

    action_id: str | None = None
    """
    Identifier emitted for the inline action.
    """

    events: list[str] | None = None
    """
    Runtime events the control may emit.
    """

    control_type = "notice_bar"

    def __init__(
        self,
        *,
        text: str | None = None,
        variant: str | None = None,
        icon: str | None = None,
        dismissible: bool | None = None,
        action_label: str | None = None,
        action_id: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            variant=variant,
            icon=icon,
            dismissible=dismissible,
            action_label=action_label,
            action_id=action_id,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

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
