from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["MarkdownView"]

@butterfly_control('markdown_view', field_aliases={'content': 'child'}, positional_fields=('value',))
class MarkdownView(LayoutControl, SingleChildControl):
    """
        Rendered Markdown content viewer.

        Displays a Markdown string using ``flutter_markdown_plus``.  When
        ``scrollable`` is ``True`` (default) the content is wrapped in a
        scrollable ``Markdown`` widget; otherwise a non-scrollable
        ``MarkdownBody`` is used.  Setting ``selectable`` allows the user
        to select and copy rendered text.

        Use ``get_value`` to retrieve the current Markdown source and
        ``set_value`` to replace it at runtime.

        Example:

        ```python
        import butterflyui as bui

        view = bui.MarkdownView(
            value="## Features
    - Fast
    - Lightweight",
            selectable=True,
        )
        ```

    """

    scrollable: bool | None = None
    """
    Controls whether overflowing content is wrapped in a scrollable host instead of being laid out at its full intrinsic size.
    """

    value: str | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    text: str | None = None
    """
    Backward-compatible alias for ``value``. When both fields are provided, ``value`` takes precedence and this alias is kept only for compatibility.
    """

    selectable: bool | None = None
    """
    Controls whether rendered text content can be selected and copied by the user.
    """

    use_flutter_markdown: Any | None = None
    """
    Use flutter markdown value forwarded to the `markdown_view` runtime control.
    """
