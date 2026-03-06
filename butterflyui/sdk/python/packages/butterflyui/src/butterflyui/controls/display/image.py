from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Image"]

@butterfly_control('image', positional_fields=('src',))
class Image(LayoutControl):
    """
    Network or asset image display.

    Renders a Flutter ``Image`` widget from the URL or asset path
    given in ``src``.  Additional sizing, fit, and alignment options
    can be passed through ``props`` or ``**kwargs``.

    Example:

    ```python
    import butterflyui as bui

    img = bui.Image(src="https://example.com/photo.jpg")
    ```
    """

    src: str | None = None
    """
    Source URI, file path, or asset reference rendered by the control.
    """

    fit: Any | None = None
    """
    Fit value forwarded to the `image` runtime control.
    """

    cache: Any | None = None
    """
    Cache value forwarded to the `image` runtime control.
    """

    placeholder: Any | None = None
    """
    Hint text shown when the control has no value.
    """
