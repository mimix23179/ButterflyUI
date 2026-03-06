from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Accordion"]

@butterfly_control('accordion', field_aliases={'controls': 'children'})
class Accordion(LayoutControl, MultiChildControl):
    """
    Collapsible accordion that shows or hides sections of content.

    The runtime renders an expandable list where each section can be opened and
    closed independently. ``sections`` supplies inline content specs; children
    may also be passed as positional arguments. ``index`` (alias ``expanded``)
    controls which section(s) are open. ``multiple`` allows several sections to
    be expanded simultaneously.

    Example:

    ```python
    import butterflyui as bui

    bui.Accordion(
        sections=[{"title": "Section A", "body": "Content A"}],
        multiple=False,
        events=["change"],
    )
    ```
    """

    sections: list[Mapping[str, Any]] | None = None
    """
    List of section spec mappings, each with a ``title`` and content.
    """

    labels: list[str] | None = None
    """
    Optional list of plain-string section titles.
    """

    index: int | list[int] | None = None
    """
    Index or list of indices of the currently expanded section(s).
    Alias for ``expanded``.
    """

    expanded: int | list[int] | None = None
    """
    Backward-compatible alias for ``index``. When both fields are provided, ``index`` takes precedence and this alias is kept only for compatibility.
    """

    multiple: bool | None = None
    """
    When ``True`` more than one section may be open at the same time.
    """

    allow_empty: bool | None = None
    """
    When ``True`` all sections may be collapsed simultaneously.
    """

    dense: bool | None = None
    """
    Reduces section header height and padding.
    """

    show_dividers: bool | None = None
    """
    Adds horizontal dividers between sections.
    """

    spacing: float | None = None
    """
    Vertical gap between sections in logical pixels.
    """

    accent_color: Any | None = None
    """
    Accent color value forwarded to the `accordion` runtime control.
    """

    allowEmpty: Any | None = None
    """
    Allowempty value forwarded to the `accordion` runtime control.
    """

    body_color: Any | None = None
    """
    Body color value forwarded to the `accordion` runtime control.
    """

    body_padding: Any | None = None
    """
    Body padding value forwarded to the `accordion` runtime control.
    """

    content_padding: Any | None = None
    """
    Content padding value forwarded to the `accordion` runtime control.
    """

    divider_color: Any | None = None
    """
    Divider color value forwarded to the `accordion` runtime control.
    """

    glass_blur: Any | None = None
    """
    Glass blur value forwarded to the `accordion` runtime control.
    """

    glass_opacity: Any | None = None
    """
    Glass opacity value forwarded to the `accordion` runtime control.
    """

    header_bg: Any | None = None
    """
    Header bg value forwarded to the `accordion` runtime control.
    """

    header_color: Any | None = None
    """
    Header color value forwarded to the `accordion` runtime control.
    """

    header_padding: Any | None = None
    """
    Header padding value forwarded to the `accordion` runtime control.
    """

    def set_expanded(self, session: Any, index: int | list[int]) -> dict[str, Any]:
        return self.invoke(session, "set_expanded", {"index": index, "expanded": index})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
