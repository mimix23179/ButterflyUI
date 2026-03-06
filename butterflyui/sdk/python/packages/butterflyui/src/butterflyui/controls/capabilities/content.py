from __future__ import annotations

from typing import Any

__all__ = [
    "ChildProps",
    "ItemsProps",
    "LeadingProps",
    "LeadingTrailingProps",
    "MultiChildProps",
    "SingleChildProps",
    "SubtitleProps",
    "TitleProps",
    "TrailingProps",
    "TitleSubtitleProps",
]


class ChildProps:
    """Shared direct-child slot prop."""

    child: Any = None
    """
    Primary child control rendered inside this control.
    """


class SingleChildProps:
    """Shared `content` slot prop for single-child controls."""

    content: Any = None
    """
    Primary child control rendered inside this control.
    """


class MultiChildProps:
    """Shared `controls` slot prop for multi-child controls."""

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """


class LeadingTrailingProps:
    """Shared leading and trailing slot props."""

    leading: Any = None
    """
    Leading visual or child node rendered by the control.
    """

    trailing: Any = None
    """
    Trailing visual or child node rendered by the control.
    """


class LeadingProps:
    """Shared leading slot prop."""

    leading: Any = None
    """
    Leading visual or child node rendered by the control.
    """


class TrailingProps:
    """Shared trailing slot prop."""

    trailing: Any = None
    """
    Trailing visual or child node rendered by the control.
    """


class TitleSubtitleProps:
    """Shared title and subtitle props."""

    title: Any = None
    """
    Title text or node rendered by the control.
    """

    subtitle: Any = None
    """
    Secondary text or node rendered by the control.
    """


class TitleProps:
    """Shared title prop."""

    title: Any = None
    """
    Title text or node rendered by the control.
    """


class SubtitleProps:
    """Shared subtitle prop."""

    subtitle: Any = None
    """
    Secondary text or node rendered by the control.
    """


class ItemsProps:
    """Shared item collection prop for item-driven controls."""

    items: list[Any] | None = None
    """
    Structured item descriptors consumed by the control.
    """
