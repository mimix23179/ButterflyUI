from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .artifact_card import ArtifactCard

__all__ = ["ResultCard"]

class ResultCard(ArtifactCard):
    """Alias for ``ArtifactCard`` with a distinct control type.

    Extends ``ArtifactCard`` with identical behaviour but registers
    as ``"result_card"`` in the runtime.  Use this variant when the
    semantic intent is to display a result (e.g. a search hit or
    computed output) rather than a generic artifact.

    Example::

        import butterflyui as bui

        card = bui.ResultCard(
            title="Match Found",
            message="2 results in /src",
            action_label="Open",
        )

    Args:
        title: 
            Bold heading at the top of the card.
        message: 
            Body text beneath the title.
        variant: 
            Visual variant key forwarded to the runtime theme.
        label: 
            Optional short label alongside the title.
        action_label: 
            Text for the action button.
        clickable: 
            If ``True`` the entire card emits ``"tap"`` on press.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "result_card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        message: str | None = None,
        variant: str | None = None,
        label: str | None = None,
        action_label: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            title=title,
            message=message,
            variant=variant,
            label=label,
            action_label=action_label,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
