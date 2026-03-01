from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Persona"]

class Persona(Component):
    """Rich identity tile with avatar, name, and status.

    Renders a user-identity card composed of a ``CircleAvatar``
    (with auto-derived initials from ``name``), a title, and an
    optional subtitle and status line.  Supports three layouts:
    ``"tile"`` (default ``ListTile``), ``"row"`` (horizontal
    ``Row``), and ``"custom"`` (renders only the ``content`` slot).

    Tapping the persona emits ``"click"`` with name, subtitle, and
    status.  Use ``set_props`` to update fields at runtime and
    ``get_state`` to read back the current display values.

    Example::

        import butterflyui as bui

        persona = bui.Persona(
            name="Ada Lovelace",
            subtitle="Engineer",
            status="online",
            avatar_color="#334155",
        )

    Args:
        name: 
            Display name used for the title and initials derivation.
        subtitle: 
            Secondary text below the name.
        avatar: 
            Image URL or asset path for the avatar circle.
        status: 
            Presence string (e.g. ``"online"``, ``"away"``).
        initials: 
            Explicit initials overriding the auto-derived value.
        layout: 
            Layout mode — ``"tile"`` (default ``ListTile``), ``"row"``, or ``"custom"``.
        show_avatar: 
            If ``False`` the avatar circle is hidden.
        avatar_color: 
            Background colour for the fallback initials avatar.
        leading: 
            Slot widget rendered in the leading position of the ``ListTile`` or ``Row``.
        title_widget: 
            Custom widget replacing the default title text.
        subtitle_widget: 
            Custom widget replacing the default subtitle.
        trailing: 
            Slot widget rendered at the trailing end.
        content: 
            Custom body widget used when ``layout`` is ``"custom"``.
        dense: 
            If ``True`` reduces vertical padding.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "persona"

    def __init__(
        self,
        name: str | None = None,
        *,
        subtitle: str | None = None,
        avatar: str | None = None,
        status: str | None = None,
        initials: str | None = None,
        layout: str | None = None,
        show_avatar: bool | None = None,
        avatar_color: Any | None = None,
        leading: Any | None = None,
        title_widget: Any | None = None,
        subtitle_widget: Any | None = None,
        trailing: Any | None = None,
        content: Any | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            name=name,
            subtitle=subtitle,
            avatar=avatar,
            status=status,
            initials=initials,
            layout=layout,
            show_avatar=show_avatar,
            avatar_color=avatar_color,
            leading=leading,
            title_widget=title_widget,
            subtitle_widget=subtitle_widget,
            trailing=trailing,
            content=content,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, 'set_props', props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, 'get_state', {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
