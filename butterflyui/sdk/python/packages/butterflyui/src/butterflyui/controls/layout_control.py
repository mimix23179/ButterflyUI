from __future__ import annotations

from typing import Any

from ._shared import Component

__all__ = ["LayoutControl"]


class LayoutControl(Component):
    """
    Shared layout behavior for visual ButterflyUI controls.
    """

    left: float | None = None
    """
    Absolute left inset used by positioned layouts.
    """

    top: float | None = None
    """
    Absolute top inset used by positioned layouts.
    """

    right: float | None = None
    """
    Absolute right inset used by positioned layouts.
    """

    bottom: float | None = None
    """
    Absolute bottom inset used by positioned layouts.
    """

    width: float | str | None = None
    """
    Fixed width in logical pixels or supported dimension token.
    """

    height: float | str | None = None
    """
    Fixed height in logical pixels or supported dimension token.
    """

    min_width: float | str | None = None
    """
    Minimum allowed width constraint.
    """

    min_height: float | str | None = None
    """
    Minimum allowed height constraint.
    """

    max_width: float | str | None = None
    """
    Maximum allowed width constraint.
    """

    max_height: float | str | None = None
    """
    Maximum allowed height constraint.
    """

    aspect_ratio: float | None = None
    """
    Preferred width-to-height ratio for the control.
    """

    padding: Any | None = None
    """
    Inner spacing between the control boundary and its content.
    """

    margin: Any | None = None
    """
    Outer spacing around the control.
    """

    alignment: Any | None = None
    """
    Alignment of child content within the control's box.
    """

    animation: Any | None = None
    """
    Implicit animation configuration used for layout or style changes.
    """

    opacity: float | None = None
    """
    Opacity multiplier applied to the rendered control.
    """

    flex: int | None = None
    """
    Flex factor used by flex-based parent layouts.
    """

    expand: bool = False
    """
    Whether the control should expand to fill available space.
    """

    x: float | None = None
    """
    Horizontal position alias used by positioned or freeform layouts.
    """

    y: float | None = None
    """
    Vertical position alias used by positioned or freeform layouts.
    """

    z: float | None = None
    """
    Depth or z-position token used by layered renderers.
    """

    z_index: int | None = None
    """
    Paint ordering override for layered layouts.
    """

    anchor: Any | None = None
    """
    Anchor or alignment point used when positioning this control.
    """

    def frame(self, **kwargs: Any) -> "LayoutControl":
        self.patch(**kwargs)
        return self
