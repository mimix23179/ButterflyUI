from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .modal import Modal

__all__ = ["AlertDialog"]


class AlertDialog(Modal):
    """
    Structured modal alert dialog with optional auto-composed body.

    ``AlertDialog`` serializes as ``control_type="alert_dialog"`` and maps to
    the modal overlay runtime with alert-friendly defaults.

    Content modes:
    - Provide ``child`` for full custom dialog content.
    - Or provide ``title``/``content``/``actions`` and the wrapper will
      auto-compose a vertical dialog body using ``Text``, ``Column``, and
      ``Row`` controls.

    ``modal`` is a convenience flag that inversely maps to ``dismissible``:
    when ``modal=True``, outside-click dismissal is disabled unless explicitly
    overridden.

    ```python
    import butterflyui as bui

    bui.AlertDialog(
        title="Delete item?",
        content="This action cannot be undone.",
        actions=[
            bui.TextButton("Cancel"),
            bui.TextButton("Delete"),
        ],
        open=True,
        modal=True,
        transition_type="fade",
    )
    ```

    Args:
        title:
            Optional dialog title. Strings/numbers are auto-converted to ``Text``.
        content:
            Optional dialog body content. Strings/numbers are auto-converted to ``Text``.
        actions:
            Optional sequence of footer actions. Primitive values are converted to ``TextButton`` controls.
        child:
            Fully custom dialog body control. If provided, auto-composition is skipped.
        open:
            Whether the dialog is currently shown.
        modal:
            Convenience alias for modal behavior. When set, it drives default ``dismissible``.
        dismissible:
            Whether outside interactions can dismiss the dialog.
        close_on_escape:
            Whether pressing Escape dismisses the dialog.
        trap_focus:
            Whether keyboard focus should remain inside the dialog while open.
        duration_ms:
            Open/close transition duration in milliseconds.
        transition:
            Explicit transition configuration mapping forwarded to the runtime.
        transition_type:
            Named transition preset (for example ``"fade"``, ``"slide"``, ``"pop"``).
        source_rect:
            Optional origin rectangle used by transitions that expand from a source.
    """

    control_type = "alert_dialog"

    def __init__(
        self,
        *,
        title: Any | None = None,
        content: Any | None = None,
        actions: Sequence[Any] | None = None,
        child: Any | None = None,
        open: bool | None = None,
        modal: bool | None = None,
        dismissible: bool | None = None,
        close_on_escape: bool | None = None,
        trap_focus: bool | None = None,
        duration_ms: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = "fade",
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_child = child
        if resolved_child is None:
            resolved_child = self._compose_dialog_body(
                title=title,
                content=content,
                actions=actions,
            )
        resolved_dismissible = dismissible
        if resolved_dismissible is None and modal is not None:
            resolved_dismissible = not bool(modal)
        super().__init__(
            child=resolved_child,
            open=open,
            dismissible=resolved_dismissible,
            close_on_escape=close_on_escape,
            trap_focus=trap_focus,
            duration_ms=duration_ms,
            transition=transition,
            transition_type=transition_type,
            source_rect=source_rect,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )

    @staticmethod
    def _compose_dialog_body(
        *,
        title: Any | None,
        content: Any | None,
        actions: Sequence[Any] | None,
    ) -> Any | None:
        from ..display import Text
        from ..inputs import TextButton
        from ..layout import Column, Row

        def as_control(value: Any, *, is_title: bool = False) -> Any:
            if value is None:
                return None
            if isinstance(value, (str, int, float)):
                return Text(
                    str(value),
                    weight="700" if is_title else None,
                    size=18 if is_title else None,
                )
            return value

        dialog_children: list[Any] = []
        title_control = as_control(title, is_title=True)
        if title_control is not None:
            dialog_children.append(title_control)
        content_control = as_control(content)
        if content_control is not None:
            dialog_children.append(content_control)

        if actions:
            action_controls: list[Any] = []
            for action in actions:
                if isinstance(action, (str, int, float)):
                    action_controls.append(TextButton(str(action)))
                else:
                    action_controls.append(action)
            dialog_children.append(Row(*action_controls, main_axis="end", spacing=8))

        if not dialog_children:
            return None
        return Column(*dialog_children, spacing=12)
