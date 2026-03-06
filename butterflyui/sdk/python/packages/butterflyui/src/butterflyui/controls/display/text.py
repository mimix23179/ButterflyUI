from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Text"]

@butterfly_control('text', field_aliases={'value': 'text'}, positional_fields=('value',))
class Text(LayoutControl):
    """
    Simple text label.

    Renders a Flutter ``Text`` widget from the ``value`` or ``text``
    parameter.  The value is coerced to a string.  Additional
    typographic options (font size, weight, colour, etc.) can be
    passed through ``props`` or ``**kwargs``.

    Example:

    ```python
    import butterflyui as bui

    label = bui.Text("Hello, world!")
    ```
    """

    value: Any = ""
    """
    Text content to display (coerced to ``str``).
    """

    text: str | None = None
    """
    Alias for ``value`` — takes precedence when both are supplied.
    """
