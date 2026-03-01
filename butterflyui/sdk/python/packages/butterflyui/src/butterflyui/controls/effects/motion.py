from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Motion"]

class Motion(Component):
    """Simple animated-opacity-and-scale motion effect driven by
    ``AnimatedOpacity`` and ``AnimatedScale``.

    The Flutter runtime wraps the child in nested ``AnimatedOpacity``
    and ``AnimatedScale`` widgets.  When ``play`` is ``True`` the
    animated properties transition to their target values; when
    ``False`` they reset to their defaults (opacity ``1.0``, scale
    ``1.0``).

    Example::

        import butterflyui as bui

        motion = bui.Motion(
            bui.Text("Zoom"),
            opacity=0.5,
            scale=0.9,
            duration_ms=300,
            play=True,
        )

    Args:
        motion: 
            Reserved — named motion preset.
        to: 
            Target property values mapping (reserved for future
            keyframe support).
        duration_ms: 
            Animation duration in milliseconds.  Defaults to
            ``240``; clamped to ``1 – 600 000``.
        curve: 
            Named easing curve string (reserved; not yet used by
            the runtime).
        play: 
            When ``True`` (default) the animated values transition
            to their targets; ``False`` resets to defaults.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "motion"

    def __init__(
        self,
        child: Any | None = None,
        *,
        motion: Any | None = None,
        from_: Mapping[str, Any] | None = None,
        to: Mapping[str, Any] | None = None,
        duration_ms: int | None = None,
        curve: str | None = None,
        play: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            motion=motion,
            **({"from": dict(from_)} if from_ is not None else {}),
            to=dict(to) if to is not None else None,
            duration_ms=duration_ms,
            curve=curve,
            play=play,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
