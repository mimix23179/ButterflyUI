from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["HtmlView"]

@butterfly_control('html_view', field_aliases={'content': 'child'}, positional_fields=('value',))
class HtmlView(LayoutControl, SingleChildControl):
    """
    Embedded HTML renderer backed by a platform WebView.

    Displays arbitrary HTML inside a ``WebView`` widget.  Content can
    be supplied inline via ``value`` / ``html`` / ``text``, or loaded
    from a local file using ``html_file``.  When ``html_file`` is set
    the runtime converts the path to a ``file://`` URL and derives a
    ``base_url`` from its parent directory so relative assets resolve
    correctly.

    Use ``get_value`` to retrieve the current HTML string,
    ``set_value`` to replace it, and ``load_file`` to swap in a new
    file path at runtime.

    Example:

    ```python
    import butterflyui as bui

    view = bui.HtmlView(
        value="<h2>Report</h2><p>Details here...</p>",
    )
    ```
    """

    value: str | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    html: str | None = None
    """
    Backward-compatible alias for ``value``. When both fields are provided, ``value`` takes precedence and this alias is kept only for compatibility.
    """

    text: str | None = None
    """
    Backward-compatible alias for ``value``. When both fields are provided, ``value`` takes precedence and this alias is kept only for compatibility.
    """

    html_file: str | None = None
    """
    Local file path to an ``.html`` file.  Converted to a ``file://`` URL at runtime.
    """

    base_url: str | None = None
    """
    Explicit base URL for resolving relative paths inside the HTML.  Defaults to the directory of ``html_file``.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def load_file(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "load_file", {"path": path})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
