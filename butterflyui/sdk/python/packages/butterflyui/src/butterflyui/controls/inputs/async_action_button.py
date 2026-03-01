from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .button import Button

__all__ = ["AsyncActionButton"]

class AsyncActionButton(Button):
    """
    Button that tracks and displays an asynchronous busy state.

    Extends :class:`Button` with a ``busy`` / ``loading`` flag that the
    Flutter runtime uses to show a progress indicator in place of the
    label while an operation is running.  The optional ``busy_label``
    is displayed alongside the spinner when set.  When
    ``disabled_while_busy`` is ``True`` the button ignores taps while
    in the busy state.

    Call :meth:`set_busy` from your Python handler to toggle the state
    imperatively; the Flutter side also mirrors the ``busy``/``loading``
    prop on re-render.

    ```python
    import butterflyui as bui

    btn = bui.AsyncActionButton(
        "Save",
        busy_label="Saving…",
        disabled_while_busy=True,
    )
    ```

    Args:
        label:
            Button text.  Alias ``text`` takes precedence when both are
            supplied.
        text:
            Button text (alias for ``label``).
        value:
            Arbitrary payload emitted with the ``click`` event.
        variant:
            Visual style variant forwarded to the Flutter button builder
            (e.g. ``"filled"``, ``"outlined"``, ``"text"``).
        busy:
            If ``True``, the button renders in its busy/loading state.
            Alias ``loading`` is kept in sync.
        loading:
            Alias for ``busy``.
        disabled_while_busy:
            If ``True``, the button is non-interactive while busy.
        busy_label:
            Text shown next to the loading indicator while busy.
        action:
            Declarative action descriptor dispatched on click.
        action_id:
            ID of a registered server-side action to invoke on click.
        action_event:
            Event name forwarded to the action handler.
        action_payload:
            Extra payload mapping forwarded with the action.
        actions:
            List of action descriptors executed sequentially on click.
        window_action:
            Window-level command triggered on click (e.g.
            ``"minimize"``, ``"maximize"``, ``"close"``).
        window_action_delay_ms:
            Milliseconds to wait before executing ``window_action``.
        events:
            List of event names the Flutter runtime should emit to Python.
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
            props=merge_props(
                props,
                busy=busy if busy is not None else loading,
                loading=loading if loading is not None else busy,
                disabled_while_busy=disabled_while_busy,
                busy_label=busy_label,
            ),
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
