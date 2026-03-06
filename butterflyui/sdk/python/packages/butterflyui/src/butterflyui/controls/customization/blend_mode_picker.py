from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..items_control import ItemsControl
__all__ = ["BlendModePicker"]

@butterfly_control('blend_mode_picker', positional_fields=('value',))
class BlendModePicker(LayoutControl, ItemsControl):
    """
    Dropdown selector for choosing a compositing blend mode.

    Renders a ``DropdownButtonFormField`` in the runtime with an optional
    live preview that demonstrates the selected mode by blending a pair of
    sample colours.

    The default options list is ``srcOver``, ``multiply``, ``screen``,
    ``overlay``, and ``plus``. Override with `options`.

    ```python
    import butterflyui as bui

    bui.BlendModePicker(
        value="multiply",
        preview=True,
        sample={"base": "#ff0000", "overlay": "#0000ff"},
    )
    ```
    """

    value: str | None = None
    """
    Currently selected blend mode string, e.g. ``"multiply"`` or ``"screen"``. Emitted in ``"change"`` events.
    """

    options: list[Any] | None = None
    """
    List of blend-mode strings offered in the dropdown. Defaults to ``["srcOver", "multiply", "screen", "overlay", "plus"]``.
    """

    label: str | None = None
    """
    Label text displayed above the dropdown field. Defaults to ``"Blend Mode"``.
    """

    preview: bool | None = None
    """
    If ``True``, a small colour swatch preview of the selected blend mode is rendered below the dropdown.
    """

    sample: Mapping[str, Any] | None = None
    """
    Dict with ``"base"`` and ``"overlay"`` colour strings used by the blend-mode preview swatch.
    """

    dense: bool | None = None
    """
    If ``True``, renders the dropdown in a compact, dense layout.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})
