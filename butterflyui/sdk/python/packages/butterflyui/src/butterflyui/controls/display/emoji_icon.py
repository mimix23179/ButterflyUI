from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["EmojiIcon"]

@butterfly_control('emoji_icon', positional_fields=('emoji',))
class EmojiIcon(LayoutControl):
    """
    Emoji character rendered as a tappable icon.

    Displays a single emoji character at a configurable ``size``.  The
    emoji resolves from ``emoji``, falling back to ``fallback`` when
    the value is empty.  An optional coloured ``background`` circle is
    drawn behind the glyph using ``BorderRadius`` from ``radius``.

    When ``enabled`` is ``True`` (default) and the control has an ID,
    tapping emits a ``"select"`` event with the resolved emoji and
    label.  Use ``set_emoji`` to swap the emoji character at runtime.

    Example:

    ```python
    import butterflyui as bui

    icon = bui.EmojiIcon(
        emoji="🚀",
        label="Rocket",
        size=28,
        background="#1e293b",
    )
    ```
    """

    emoji: str | None = None
    """
    Emoji character or string to display.
    """

    label: str | None = None
    """
    Accessible tooltip shown on hover.
    """

    fallback: str | None = None
    """
    Fallback emoji used when ``emoji`` is empty (defaults to ``"😀"``).
    """

    text: Any | None = None
    """
    Text value rendered by the control.
    """

    fgcolor: Any | None = None
    """
    Fgcolor value forwarded to the `emoji_icon` runtime control.
    """

    outline_width: Any | None = None
    """
    Outline width value forwarded to the `emoji_icon` runtime control.
    """

    stroke_width: Any | None = None
    """
    Stroke width value forwarded to the `emoji_icon` runtime control.
    """

    outline_color: Any | None = None
    """
    Outline color value forwarded to the `emoji_icon` runtime control.
    """

    stroke_color: Any | None = None
    """
    Stroke color value forwarded to the `emoji_icon` runtime control.
    """

    glow_color: Any | None = None
    """
    Glow color value forwarded to the `emoji_icon` runtime control.
    """

    shadow_blur: Any | None = None
    """
    Shadow blur value forwarded to the `emoji_icon` runtime control.
    """

    glow_blur: Any | None = None
    """
    Glow blur value forwarded to the `emoji_icon` runtime control.
    """

    shadow_dx: Any | None = None
    """
    Shadow dx value forwarded to the `emoji_icon` runtime control.
    """

    shadow_dy: Any | None = None
    """
    Shadow dy value forwarded to the `emoji_icon` runtime control.
    """

    bg_color: Any | None = None
    """
    Bg color value forwarded to the `emoji_icon` runtime control.
    """

    content_padding: Any | None = None
    """
    Content padding value forwarded to the `emoji_icon` runtime control.
    """

    inner_padding: Any | None = None
    """
    Inner padding value forwarded to the `emoji_icon` runtime control.
    """

    icon_padding: Any | None = None
    """
    Icon padding value forwarded to the `emoji_icon` runtime control.
    """

    def set_emoji(self, session: Any, emoji: str) -> dict[str, Any]:
        return self.invoke(session, "set_emoji", {"emoji": emoji})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
