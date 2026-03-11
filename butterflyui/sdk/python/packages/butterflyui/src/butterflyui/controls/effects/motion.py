from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Motion"]


class Motion(Component):
    """
    Interaction-aware motion choreography helper.
    
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
    
    ``Motion`` also maps directly to universal cross-control motion props:
    ``motion`` (primary), ``enter_motion``, ``exit_motion``,
    ``hover_motion``, and ``press_motion``.
    """


    _butterflyui_doc_only_fields = {
        "hover",
        "press",
        "focus",
        "selected",
        "disabled",
    }

    hover: Mapping[str, Any] | None = None
    """
    State-specific style map applied while the pointer hovers the control. Use it to override hover-time visual properties such as background, border, elevation, or text color.
    """

    press: Mapping[str, Any] | None = None
    """
    State-specific motion configuration applied while the control is actively pressed.
    """

    focus: Mapping[str, Any] | None = None
    """
    State-specific motion configuration applied while the control has keyboard or accessibility focus.
    """

    selected: Mapping[str, Any] | None = None
    """
    Shortcut state map for selected.
    """

    disabled: Mapping[str, Any] | None = None
    """
    State-specific style map applied when the control is disabled. Use it to tone down interactive styling or replace it with a non-interactive appearance.
    """

    from_: Mapping[str, Any] | None = None
    """
    Base state map used as animation origin.
    """

    preset: str | None = None
    """
    Preset choreography name (for example ``hover_lift``, ``press_sink``,
    ``hover_lift_glow``, ``focus_pulse``, ``enter_fade_up``,
    ``shared_axis``).
    """

    motion: Any | None = None
    """
    Legacy motion preset/spec alias.
    """

    enter_motion: Any | None = None
    """
    Enter transition motion spec for initial mount.
    """

    exit_motion: Any | None = None
    """
    Exit transition motion spec for removal/hide transitions.
    """

    hover_motion: Any | None = None
    """
    Motion spec used for hover-driven interaction.
    """

    press_motion: Any | None = None
    """
    Motion spec used for pressed-state interaction.
    """

    states: Mapping[str, Mapping[str, Any]] | None = None
    """
    State map for ``hover``, ``press``, ``focus``, ``selected``,
    ``disabled``. Each value is a map of animated props.
    """

    to: Mapping[str, Any] | None = None
    """
    Base state map used as animation target while ``play=True``.
    """

    duration: str | None = None
    """
    Named duration token (``short``, ``medium``, ``long``).
    """

    duration_ms: int | None = None
    """
    Explicit duration in milliseconds.
    """

    curve: str | None = None
    """
    Easing curve name or specification used for the motion transition.
    """

    play: bool | None = None
    """
    Enables/disables playback of base from/to transition.
    """

    interactive: bool | None = None
    """
    Enables hover/press/focus input tracking.
    """

    axis: str | None = None
    """
    Axis hint used by some presets (x/y/z).
    """

    opacity: float | None = None
    """
    Opacity value applied while this motion or visual state is active.
    """

    scale: float | None = None
    """
    Scale factor applied while the motion or effect state is active.
    """

    x: float | None = None
    """
    Horizontal offset applied by the active motion or effect state.
    """

    y: float | None = None
    """
    Vertical offset applied by the active motion or effect state.
    """

    blur: float | None = None
    """
    Blur amount applied by the motion or effect step when this state is active.
    """

    glow: Mapping[str, Any] | None = None
    """
    Glow descriptor merged into active state.
    """

    shadow: Mapping[str, Any] | None = None
    """
    Shadow descriptor merged into active state.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "motion"

    def __init__(
        self,
        child: Any | None = None,
        *,
        preset: str | None = None,
        motion: Any | None = None,
        enter_motion: Any | None = None,
        exit_motion: Any | None = None,
        hover_motion: Any | None = None,
        press_motion: Any | None = None,
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
            enter_motion=enter_motion,
            exit_motion=exit_motion,
            hover_motion=hover_motion,
            press_motion=press_motion,
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
        self.hover = dict(hover) if hover is not None else None
        self.press = dict(press) if press is not None else None
        self.focus = dict(focus) if focus is not None else None
        self.selected = dict(selected) if selected is not None else None
        self.disabled = dict(disabled) if disabled is not None else None

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
