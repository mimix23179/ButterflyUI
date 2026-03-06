from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["MarkdownView"]

@butterfly_control('markdown_view', field_aliases={'content': 'child'}, positional_fields=('value',))
class MarkdownView(LayoutControl):
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

    content: Any | None = None
    """
    Primary child control rendered inside this control.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `markdown_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `markdown_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `markdown_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `markdown_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `markdown_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `markdown_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `markdown_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `markdown_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `markdown_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `markdown_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `markdown_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `markdown_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `markdown_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `markdown_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `markdown_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `markdown_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `markdown_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `markdown_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `markdown_view` runtime control.
    """
