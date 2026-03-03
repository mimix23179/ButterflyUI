from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Diff"]


class Diff(Component):
    """Side-by-side or unified text diff viewer."""

    control_type = "diff"

    def __init__(
        self,
        *,
        before: str | None = None,
        after: str | None = None,
        mode: str | None = None,
        compact: bool | None = None,
        show_line_numbers: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                before=before,
                after=after,
                mode=mode,
                compact=compact,
                show_line_numbers=show_line_numbers,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )
