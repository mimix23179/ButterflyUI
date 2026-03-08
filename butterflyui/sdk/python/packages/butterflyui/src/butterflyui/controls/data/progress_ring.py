from __future__ import annotations

from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ProgressRing"]

@butterfly_control('progress_ring')
class ProgressRing(LayoutControl):
    """
    Circular progress indicator for determinate or indeterminate tasks.

    ``ProgressRing`` sends the canonical ``progress_ring`` control type and pins
    ``variant="circular"`` / ``circular=True`` so the Flutter side always
    renders a ring. Use ``value`` for determinate progress, or set
    ``indeterminate=True`` for an animated spinner-style state.

    ```python
    import butterflyui as bui

    ring = bui.ProgressRing(value=0.72, label="Syncing", stroke_width=6)
    ```
    """

    value: float | None = None
    """
    Progress value for determinate mode.
    """

    indeterminate: bool | None = None
    """
    If ``True``, renders an animated indeterminate ring.
    """

    label: str | None = None
    """
    Optional text label shown with the indicator.
    """

    helper: str | None = None
    """
    Helper text rendered below the ring.
    """

    variant: str | None = None
    """
    Progress style variant such as ``solid``, ``soft``, ``gradient``,
    ``glow``, ``segmented``, or ``dashboard``.
    """

    show_value: bool | None = None
    """
    If ``True``, renders the formatted progress value in the center by default.
    """

    value_template: str | None = None
    """
    Optional template used to format the displayed progress value.
    """

    center_label: str | None = None
    """
    Explicit text rendered in the center of the ring.
    """

    stroke_width: float | None = None
    """
    Thickness of the rendered stroke in logical pixels.
    """

    size: float | None = None
    """
    Square size of the rendered ring in logical pixels.
    """

    segments: int | None = None
    """
    Number of visible segments when ``variant="segmented"``.
    """

    glow: bool | None = None
    """
    Enables a glow treatment around the active ring stroke.
    """

    glow_color: str | None = None
    """
    Optional glow color override.
    """

    gradient: dict[str, Any] | None = None
    """
    Gradient definition used by gradient-based variants.
    """

    start_angle: float | None = None
    """
    Start angle of the rendered arc in degrees.
    """

    sweep_angle: float | None = None
    """
    Sweep angle of the rendered arc in degrees.
    """

    cap: str | None = None
    """
    Stroke cap style such as ``round``, ``square``, or ``butt``.
    """

    animation_duration_ms: int | None = None
    """
    Duration of the indeterminate or animated progress cycle in milliseconds.
    """

    circular: bool | None = None
    """
    Circular value forwarded to the `progress_ring` runtime control.
    """

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
