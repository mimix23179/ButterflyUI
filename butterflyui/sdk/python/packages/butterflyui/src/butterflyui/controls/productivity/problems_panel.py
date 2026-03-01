from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ProblemsPanel"]

class ProblemsPanel(Component):
    """
    Read-only panel displaying a list of compiler or linter diagnostics.

    The runtime renders a scrollable list of problem items. Each entry in
    ``problems`` is a mapping describing a diagnostic (severity, message,
    file, line, column, etc.).

    ```python
    import butterflyui as bui

    bui.ProblemsPanel(
        problems=[
            {"severity": "error", "message": "Undefined variable x",
             "file": "main.py", "line": 12},
        ],
    )
    ```

    Args:
        problems:
            List of diagnostic spec mappings. Each entry should include
            at least ``severity`` and ``message``.
    """

    control_type = "problems_panel"

    def __init__(
        self,
        *,
        problems: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, problems=problems, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
