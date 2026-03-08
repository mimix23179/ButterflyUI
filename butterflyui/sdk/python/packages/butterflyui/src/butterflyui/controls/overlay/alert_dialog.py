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
    
    The action row accepts normal button controls, so it works directly with
    icon-enabled button variants and declarative action dispatch.

    Example:
    
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
    """


    _butterflyui_doc_only_fields = {"title", "content", "actions", "modal"}

    title: Any | None = None
    """
    Title node or primitive text value.
    """

    content: Any | None = None
    """
    Body node or primitive text value.
    """

    actions: Sequence[Any] | None = None
    """
    Footer action descriptors or primitive labels.
    """

    modal: bool | None = None
    """
    Alias for modal behavior. When set, it drives default
    ``dismissible`` (``modal=True`` implies ``dismissible=False``).
    """

    open: bool | None = None
    """
    If ``True``, the dialog is visible.
    """

    dismissible: bool | None = None
    """
    If ``True``, outside taps dismiss the dialog.
    """


    close_on_escape: bool | None = None
    """
    If ``True``, Escape dismisses the dialog.
    """

    trap_focus: bool | None = None
    """
    If ``True``, keyboard focus remains inside the dialog while open.
    """

    duration_ms: int | None = None
    """
    Open/close transition duration in milliseconds.
    """

    transition: Mapping[str, Any] | None = None
    """
    Explicit transition descriptor mapping.
    """

    transition_type: str | None = 'fade'
    """
    Named transition preset (for example ``"fade"``, ``"slide"``,
    ``"pop"``, ``"pop_from_rect"``).
    """

    source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None
    """
    Optional transition origin rectangle.
    """

    scrim_color: Any | None = None
    """
    Color used for the modal scrim or backdrop behind the overlay.
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

        merged = merge_props(
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
        )
        super().__init__(
            child=resolved_child,
            props=merged,
            style=style,
            strict=strict,
        )
        self.title = title
        self.content = content
        self.actions = list(actions) if actions is not None else None
        self.modal = modal

    @staticmethod
    def _compose_dialog_body(
        *,
        title: Any | None,
        content: Any | None,
        actions: Sequence[Any] | None,
    ) -> Any | None:
        from ..display import Text
        from ..inputs import ElevatedButton, FilledButton, OutlinedButton, TextButton
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

        if actions and any(AlertDialog._requires_composed_action(action) for action in actions):
            action_controls: list[Any] = []
            for action in actions:
                resolved_action = AlertDialog._coerce_action_control(
                    action,
                    text_button=TextButton,
                    outlined_button=OutlinedButton,
                    elevated_button=ElevatedButton,
                    filled_button=FilledButton,
                )
                if resolved_action is not None:
                    action_controls.append(resolved_action)
            dialog_children.append(Row(*action_controls, main_axis="end", spacing=8))

        if not dialog_children:
            return None
        return Column(*dialog_children, spacing=12)

    @staticmethod
    def _requires_composed_action(action: Any) -> bool:
        if isinstance(action, (str, int, float)):
            return False
        if isinstance(action, Mapping):
            return "type" in action or "control_type" in action
        return action is not None

    @staticmethod
    def _coerce_action_control(
        action: Any,
        *,
        text_button: Any,
        outlined_button: Any,
        elevated_button: Any,
        filled_button: Any,
    ) -> Any | None:
        if action is None:
            return None
        if isinstance(action, (str, int, float)):
            return text_button(str(action))
        if isinstance(action, Mapping):
            action_map = dict(action)
            if "type" in action_map or "control_type" in action_map:
                return action

            label = action_map.get("label", action_map.get("text"))
            if label is None:
                return None

            variant = str(action_map.get("variant", "text")).strip().lower()
            button_cls = text_button
            if variant in {"filled", "primary"}:
                button_cls = filled_button
            elif variant in {"elevated", "raised"}:
                button_cls = elevated_button
            elif variant == "outlined":
                button_cls = outlined_button

            return button_cls(
                str(label),
                icon=action_map.get("icon"),
                disabled=action_map.get("enabled") is False,
                action_id=action_map.get("id"),
                value=action_map.get("value"),
            )
        return action

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

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

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)

