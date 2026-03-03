from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["AlertDialog"]


class AlertDialog(Component):
    """
    Dialog overlay for alerts, confirms, and modal prompts.

    ``AlertDialog`` is the canonical replacement for legacy ``modal`` control
    APIs. You can provide a fully custom ``child`` node or let the wrapper
    auto-compose a simple title/content/actions body.

    ```python
    import butterflyui as bui

    dialog = bui.AlertDialog(
        title="Delete project?",
        content="This action cannot be undone.",
        actions=["Cancel", "Delete"],
        open=True,
        dismissible=False,
    )
    ```

    Args:
        title:
            Title node or primitive text value.
        content:
            Body node or primitive text value.
        actions:
            Footer action descriptors or primitive labels.
        child:
            Fully custom dialog body control. If provided, auto composition is
            skipped.
        open:
            If ``True``, the dialog is visible.
        dismissible:
            If ``True``, outside taps dismiss the dialog.
        close_on_escape:
            If ``True``, Escape dismisses the dialog.
        trap_focus:
            If ``True``, keyboard focus remains inside the dialog while open.
        duration_ms:
            Open/close transition duration in milliseconds.
        transition:
            Explicit transition descriptor mapping.
        transition_type:
            Named transition preset (for example ``"fade"``, ``"slide"``,
            ``"pop"``, ``"pop_from_rect"``).
        source_rect:
            Optional transition origin rectangle.
        scrim_color:
            Overlay scrim color.
        modal:
            Alias for modal behavior. When set, it drives default
            ``dismissible`` (``modal=True`` implies ``dismissible=False``).
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
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
        dismissible: bool | None = None,
        close_on_escape: bool | None = None,
        trap_focus: bool | None = None,
        duration_ms: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = "fade",
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        scrim_color: Any | None = None,
        modal: bool | None = None,
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
            props=merge_props(
                props,
                open=open,
                dismissible=resolved_dismissible,
                close_on_escape=close_on_escape,
                trap_focus=trap_focus,
                duration_ms=duration_ms,
                transition=transition,
                transition_type=transition_type,
                source_rect=source_rect,
                scrim_color=scrim_color,
                **kwargs,
            ),
            style=style,
            strict=strict,
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

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )

