from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Motion"]


class Motion(Component):
    """
    Interaction-aware motion choreography wrapper.

    ``Motion`` sits above ``Animation`` and focuses on state-driven micro-interactions:
    hover lift, press sink, focus pulse, enter transitions, and shared-axis style
    screen choreography. Use it to declaratively describe *when* movement should
    happen (hover/press/focus/selected/disabled) and *how* values should animate.

    Example:
        ```python
        import butterflyui as bui

        cta = bui.Motion(
            bui.Button("Start"),
            preset="hover_lift_glow",
            states={
                "hover": {"scale": 1.02, "y": -2, "glow_opacity": 0.9},
                "press": {"scale": 0.98, "y": 0},
            },
            duration_ms=180,
            curve="emphasized",
        )
        ```

    Args:
        child:
            Child control to wrap.
        preset:
            Preset choreography name (for example ``hover_lift``, ``press_sink``,
            ``hover_lift_glow``, ``focus_pulse``, ``enter_fade_up``,
            ``shared_axis``).
        motion:
            Legacy motion preset/spec alias.
        states:
            State map for ``hover``, ``press``, ``focus``, ``selected``,
            ``disabled``. Each value is a map of animated props.
        hover:
            Shortcut state map for hover.
        press:
            Shortcut state map for press.
        focus:
            Shortcut state map for focus.
        selected:
            Shortcut state map for selected.
        disabled:
            Shortcut state map for disabled.
        from_:
            Base state map used as animation origin.
        to:
            Base state map used as animation target while ``play=True``.
        duration:
            Named duration token (``short``, ``medium``, ``long``).
        duration_ms:
            Explicit duration in milliseconds.
        curve:
            Easing curve name.
        play:
            Enables/disables playback of base from/to transition.
        interactive:
            Enables hover/press/focus input tracking.
        axis:
            Axis hint used by some presets (x/y/z).
        opacity:
            Shortcut target opacity.
        scale:
            Shortcut target scale.
        x:
            Shortcut target x translation.
        y:
            Shortcut target y translation.
        blur:
            Shortcut target blur.
        glow:
            Glow descriptor merged into active state.
        shadow:
            Shadow descriptor merged into active state.
        events:
            Runtime events emitted from motion host (for example
            ``state_changed``, ``hover``, ``press``, ``focus``).
        props:
            Raw prop overrides merged after typed args.
        style:
            Style map forwarded to renderer style pipeline.
        strict:
            Enables strict validation when supported.
    """

    control_type = "motion"

    def __init__(
        self,
        child: Any | None = None,
        *,
        preset: str | None = None,
        motion: Any | None = None,
        states: Mapping[str, Mapping[str, Any]] | None = None,
        hover: Mapping[str, Any] | None = None,
        press: Mapping[str, Any] | None = None,
        focus: Mapping[str, Any] | None = None,
        selected: Mapping[str, Any] | None = None,
        disabled: Mapping[str, Any] | None = None,
        from_: Mapping[str, Any] | None = None,
        to: Mapping[str, Any] | None = None,
        duration: str | None = None,
        duration_ms: int | None = None,
        curve: str | None = None,
        play: bool | None = None,
        interactive: bool | None = None,
        axis: str | None = None,
        opacity: float | None = None,
        scale: float | None = None,
        x: float | None = None,
        y: float | None = None,
        blur: float | None = None,
        glow: Mapping[str, Any] | None = None,
        shadow: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        state_map: dict[str, Any] = dict(states or {})
        if hover is not None:
            state_map["hover"] = dict(hover)
        if press is not None:
            state_map["press"] = dict(press)
        if focus is not None:
            state_map["focus"] = dict(focus)
        if selected is not None:
            state_map["selected"] = dict(selected)
        if disabled is not None:
            state_map["disabled"] = dict(disabled)

        merged = merge_props(
            props,
            preset=preset,
            motion=motion if motion is not None else preset,
            states=state_map or None,
            **({"from": dict(from_)} if from_ is not None else {}),
            to=dict(to) if to is not None else None,
            duration=duration,
            duration_ms=duration_ms,
            curve=curve,
            play=play,
            interactive=interactive,
            axis=axis,
            opacity=opacity,
            scale=scale,
            x=x,
            y=y,
            blur=blur,
            glow=dict(glow) if glow is not None else None,
            shadow=dict(shadow) if shadow is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

