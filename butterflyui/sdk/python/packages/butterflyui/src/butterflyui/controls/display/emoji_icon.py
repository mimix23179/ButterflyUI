from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["EmojiIcon"]

class EmojiIcon(Component):
    """Emoji character rendered as a tappable icon.

    Displays a single emoji character at a configurable ``size``.  The
    emoji resolves from ``emoji``, falling back to ``fallback`` when
    the value is empty.  An optional coloured ``background`` circle is
    drawn behind the glyph using ``BorderRadius`` from ``radius``.

    When ``enabled`` is ``True`` (default) and the control has an ID,
    tapping emits a ``"select"`` event with the resolved emoji and
    label.  Use ``set_emoji`` to swap the emoji character at runtime.

    Example::

        import butterflyui as bui

        icon = bui.EmojiIcon(
            emoji="\U0001f680",
            label="Rocket",
            size=28,
            background="#1e293b",
        )

    Args:
        emoji: 
            Emoji character or string to display.
        label: 
            Accessible tooltip shown on hover.
        size: 
            Font size of the emoji in logical pixels.
        color: 
            Foreground colour applied to the emoji text.
        fallback: 
            Fallback emoji used when ``emoji`` is empty (defaults to ``"\U0001f600"``).
        variant: 
            Visual variant key forwarded to the runtime.
        background: 
            Background fill colour drawn behind the emoji.
        radius: 
            Corner radius for the background shape.
        padding: 
            Padding between the background edge and the emoji.
        enabled: 
            If ``True`` (default) the emoji emits tap events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "emoji_icon"

    def __init__(
        self,
        emoji: str | None = None,
        *,
        label: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        fallback: str | None = None,
        variant: str | None = None,
        background: Any | None = None,
        radius: float | None = None,
        padding: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            emoji=emoji,
            label=label,
            size=size,
            color=color,
            fallback=fallback,
            variant=variant,
            background=background,
            radius=radius,
            padding=padding,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_emoji(self, session: Any, emoji: str) -> dict[str, Any]:
        return self.invoke(session, "set_emoji", {"emoji": emoji})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
