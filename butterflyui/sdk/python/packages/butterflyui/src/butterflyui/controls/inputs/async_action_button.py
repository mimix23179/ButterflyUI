from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .button import Button

__all__ = ["AsyncActionButton"]

class AsyncActionButton(Button):
    """Button with built-in asynchronous busy/loading behavior.
    
    ``AsyncActionButton`` extends :class:`Button` by synchronizing ``busy`` and
    ``loading`` state flags and exposing helpers to toggle busy state through
    runtime invocations. This is useful for long-running actions such as remote
    API calls, background jobs, and multi-step workflows.
    
    While busy, the renderer can show a spinner and optional ``busy_label``;
    when ``disabled_while_busy`` is enabled, presses are ignored until the
    operation completes.
    
    ```python
    import butterflyui as bui
    
    save_btn = bui.AsyncActionButton(
        "Save",
        action_id="save_document",
        busy_label="Saving...",
        disabled_while_busy=True,
    )
    ```
    
    Args:
        label:
            Button text. ``text`` takes precedence when both are set.
        text:
            Button text alias for ``label``.
        value:
            Arbitrary payload emitted with click events.
        variant:
            Optional visual variant (for example ``"filled"`` or ``"outlined"``).
        busy:
            Controls whether the control should render its busy or in-progress state instead of its idle presentation.
        loading:
            Backward-compatible alias for ``busy``. When both fields are provided, ``busy`` takes precedence and this alias is kept only for compatibility.
        disabled_while_busy:
            If ``True``, disables interaction while busy.
        busy_label:
            Replacement label text shown while the control is in its busy state.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        action:
            Declarative action descriptor fired on press.
        action_id:
            Registered action ID to dispatch on press.
        action_event:
            Event name forwarded to the action dispatcher.
        action_payload:
            Extra payload mapping for action dispatch.
        actions:
            Action descriptor list executed on press.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
        **kwargs:
            Extra runtime props forwarded to the renderer.
    """


    label: str | None = None
    """
    Button text. ``text`` takes precedence when both are set.
    """

    text: str | None = None
    """
    Button text alias for ``label``.
    """

    value: Any | None = None
    """
    Arbitrary payload emitted with click events.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    action: Any | None = None
    """
    Declarative action descriptor fired on press.
    """

    action_id: str | None = None
    """
    Registered action ID to dispatch on press.
    """

    action_event: str | None = None
    """
    Event name forwarded to the action dispatcher.
    """

    action_payload: Mapping[str, Any] | None = None
    """
    Extra payload mapping for action dispatch.
    """

    actions: list[Any] | None = None
    """
    Action descriptor list executed on press.
    """


    busy: bool | None = None
    """
    Controls whether the control should render its busy or in-progress state instead of its idle presentation.
    """

    loading: bool | None = None
    """
    Backward-compatible alias for ``busy``. When both fields are provided, ``busy`` takes precedence and this alias is kept only for compatibility.
    """

    disabled_while_busy: bool | None = None
    """
    If ``True``, disables interaction while busy.
    """

    busy_label: str | None = None
    """
    Replacement label text shown while the control is in its busy state.
    """
    control_type = "async_action_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        variant: str | None = None,
        busy: bool | None = None,
        loading: bool | None = None,
        disabled_while_busy: bool | None = None,
        busy_label: str | None = None,
        events: list[str] | None = None,
        action: Any | None = None,
        action_id: str | None = None,
        action_event: str | None = None,
        action_payload: Mapping[str, Any] | None = None,
        actions: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        busy=busy if busy is not None else loading,
                        loading=loading if loading is not None else busy,
                        disabled_while_busy=disabled_while_busy,
                        busy_label=busy_label,
                    )
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant=variant,
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=action_payload,
            actions=actions,
            props=merged,
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_busy(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_busy", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

