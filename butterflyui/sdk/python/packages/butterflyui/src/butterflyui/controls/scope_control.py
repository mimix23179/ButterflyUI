from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["ScopeControl"]


class ScopeControl(LayoutControl):
    """
    Shared subtree scope behavior for style and umbrella controls.

    Args:
        classes:
            Space-separated or structured class tokens applied to the subtree.
        state:
            Active scope state used by recipes or conditional styling.
        variant:
            Named or structured variant value applied to descendants.
    """

    classes: Any = None
    """
    Space-separated or structured class tokens applied to the subtree.
    """

    state: str | None = None
    """
    Active scope state used by recipes or conditional styling.
    """

    variant: Any = None
    """
    Named or structured variant value applied to descendants.
    """
