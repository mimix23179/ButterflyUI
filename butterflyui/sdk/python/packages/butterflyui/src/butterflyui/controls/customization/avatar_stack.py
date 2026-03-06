from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AvatarStack"]

class AvatarStack(Component):
    """Renders a horizontal row of overlapping circular avatar bubbles.
    
    Each avatar shows the first character of its ``label`` (or ``name``) in
    a coloured circle. When there are more avatars than `max`, an overflow
    chip shows the remaining count (e.g. ``"+3"``).
    
    Tapping an individual avatar emits a ``"select"`` event with the
    avatar's ``index``, ``id``, and ``label``.
    
    ```python
    import butterflyui as bui
    
    bui.AvatarStack(
        avatars=[
            {"label": "Alice", "color": "#7c3aed"},
            {"label": "Bob"},
            {"label": "Carol"},
        ],
        size=32,
        overlap=10,
        max=5,
    )
    ```
    
    Args:
        avatars:
            Ordered list of avatar entries rendered by the stack. Each item can be a plain label string or a mapping with avatar metadata such as label, color, text color, and id.
        size:
            Diameter of each avatar circle in logical pixels. Defaults to ``28``.
        overlap:
            Horizontal overlap between adjacent avatars in logical pixels. Defaults to ``8``.
        max:
            Maximum number of avatars to display before showing an overflow indicator. Avatars beyond this count are hidden.
        max_visible:
            Backward-compatible alias for ``max``. When both fields are provided, ``max`` takes precedence and this alias is kept only for compatibility.
        max_count:
            Backward-compatible alias for ``max``. When both fields are provided, ``max`` takes precedence and this alias is kept only for compatibility.
        overflow_label:
            Custom text for the overflow chip. When omitted, the runtime displays ``"+N"`` where ``N`` is the hidden count.
        stack_order:
            Set to ``"reverse"`` to render avatars in reversed stacking order.
        expand_on_hover:
            If ``True``, the stack expands to reveal hidden avatars on hover.
    """


    avatars: list[Any] | None = None
    """
    Ordered list of avatar entries rendered by the stack. Each item can be a plain label string or a mapping with avatar metadata such as label, color, text color, and id.
    """

    size: float | None = None
    """
    Diameter of each avatar circle in logical pixels. Defaults to ``28``.
    """

    overlap: float | None = None
    """
    Horizontal overlap between adjacent avatars in logical pixels. Defaults to ``8``.
    """

    max: int | None = None
    """
    Maximum number of avatars to display before showing an overflow indicator. Avatars beyond this count are hidden.
    """

    max_visible: int | None = None
    """
    Backward-compatible alias for ``max``. When both fields are provided, ``max`` takes precedence and this alias is kept only for compatibility.
    """

    max_count: int | None = None
    """
    Backward-compatible alias for ``max``. When both fields are provided, ``max`` takes precedence and this alias is kept only for compatibility.
    """

    overflow_label: str | None = None
    """
    Custom text for the overflow chip. When omitted, the runtime displays ``"+N"`` where ``N`` is the hidden count.
    """

    stack_order: str | None = None
    """
    Set to ``"reverse"`` to render avatars in reversed stacking order.
    """

    expand_on_hover: bool | None = None
    """
    If ``True``, the stack expands to reveal hidden avatars on hover.
    """
    control_type = "avatar_stack"

    def __init__(
        self,
        *children: Any,
        avatars: list[Any] | None = None,
        size: float | None = None,
        overlap: float | None = None,
        max: int | None = None,
        max_visible: int | None = None,
        max_count: int | None = None,
        overflow_label: str | None = None,
        stack_order: str | None = None,
        expand_on_hover: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_max = max if max is not None else max_visible
        if resolved_max is None:
            resolved_max = max_count
        merged = merge_props(
            props,
            avatars=avatars,
            size=size,
            overlap=overlap,
            max=resolved_max,
            max_visible=resolved_max,
            max_count=resolved_max,
            overflow_label=overflow_label,
            stack_order=stack_order,
            expand_on_hover=expand_on_hover,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_avatars(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_avatars", {})

    def set_avatars(self, session: Any, avatars: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_avatars", {"avatars": avatars})
