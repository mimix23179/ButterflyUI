from __future__ import annotations

from typing import Any

from .base_control import BaseControl

__all__ = ["Control", "Component"]


class Control(BaseControl):
    """
    Common props shared by most renderable ButterflyUI controls.
    """

    key: str | None = None
    """
    Stable application-defined identifier used to distinguish this control
    across updates.
    """

    visible: bool = True
    """
    Whether the control should be rendered by the Flutter client.
    """

    enabled: bool | None = None
    """
    Whether the control should accept interaction and appear enabled.
    """

    tooltip: str | None = None
    """
    Hover or long-press help text shown by the runtime.
    """

    semantics: Any = None
    """
    Accessibility metadata forwarded to the client.
    """


Component = Control
