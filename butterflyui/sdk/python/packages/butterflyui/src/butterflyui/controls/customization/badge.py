from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Badge"]

@butterfly_control('badge', positional_fields=('label',))
class Badge(LayoutControl):
    """
    Displays a compact label, count, or status indicator.

    The runtime colours the badge according to `severity` (``"success"``,
    ``"warning"``, ``"error"``) or uses explicit `bgcolor` / `color`
    overrides. When `dot` is ``True`` an empty dot indicator is shown
    instead of text. The optional `pulse` flag adds a scale animation.

    If `clickable` is ``True``, a ``"click"`` event is emitted with the
    current display value.

    ```python
    import butterflyui as bui

    bui.Badge("New", severity="success", pulse=True)
    ```
    """

    label: str | None = None
    """
    Display text. Resolved from `text` when ``None``.
    """

    text: str | None = None
    """
    Backward-compatible alias for ``label``. When both fields are provided, ``label`` takes precedence and this alias is kept only for compatibility.
    """

    value: Any | None = None
    """
    Arbitrary value exposed to event payloads and the ``get_value`` / ``set_value`` invoke methods.
    """

    severity: str | None = None
    """
    Semantic severity controlling the theme colour scheme. One of ``"success"``, ``"warning"`` / ``"warn"``, ``"error"`` / ``"danger"``. Defaults to the primary colour.
    """

    dot: bool | None = None
    """
    If ``True``, renders a small coloured dot instead of text.
    """

    pulse: bool | None = None
    """
    If ``True``, the badge animates with a subtle pulse (scale tween).
    """

    count: int | None = None
    """
    When set, overrides the display text with this integer count.
    """

    clickable: bool | None = None
    """
    If ``True``, the badge becomes tappable and emits a ``"click"`` event with the current display value.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})
