from __future__ import annotations

from typing import Any

__all__ = ["CoreProps"]


class CoreProps:
    """Framework-level control identity, visibility, and event props."""

    id: str | None = None
    """
    Optional runtime prop identifier forwarded alongside the generated control id.
    """

    key: str | None = None
    """
    Stable application-defined identifier used to distinguish this control across updates.
    """

    visible: bool = True
    """
    Whether the control should be rendered by the Flutter client.
    """

    enabled: bool | None = None
    """
    Whether the control should accept interaction and appear enabled.
    """

    disabled: bool | None = None
    """
    Explicit disabled-state flag forwarded to the runtime.
    """

    interactive: bool | None = None
    """
    Whether this control should participate in pointer and keyboard interaction.
    """

    tooltip: str | None = None
    """
    Hover or long-press help text shown by the runtime.
    """

    cursor: str | None = None
    """
    Cursor token requested when a pointer hovers the control.
    """

    semantics: Any = None
    """
    Accessibility metadata forwarded to the client.
    """

    accessibility: Any = None
    """
    Extended accessibility metadata forwarded to the runtime.
    """

    events: list[str] | None = None
    """
    Runtime event names that should be emitted back to Python.
    """

    data: Any = None
    """
    Arbitrary application data attached to the control instance.
    """
