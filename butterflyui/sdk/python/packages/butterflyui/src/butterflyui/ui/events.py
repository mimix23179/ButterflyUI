from __future__ import annotations

import asyncio
import inspect
from dataclasses import dataclass
from typing import Any, Callable, Optional

from ..app import ButterflyUISession
from .control import Component
from .queue import Progress, TaskQueue
from .state import State

__all__ = [
    "Update",
    "update",
    "NO_UPDATE",
    "TaskQueue",
    "Progress",
    "bind_event",
    "register_action",
    "get_action",
    "run_action",
]


class _NoUpdateType:
    pass


NO_UPDATE = _NoUpdateType()

# --- Action registry (opt-in helpers) ---

_ACTIONS: dict[str, Callable[..., Any]] = {}


def register_action(name: str, fn: Callable[..., Any]) -> Callable[..., Any]:
    """Register a named action helper."""
    _ACTIONS[str(name)] = fn
    return fn


def get_action(name: str) -> Callable[..., Any] | None:
    """Return a registered action by name."""
    return _ACTIONS.get(str(name))


def run_action(name: str, *args: Any, **kwargs: Any) -> Any:
    """Run a registered action by name."""
    action = get_action(name)
    if action is None:
        raise KeyError(f"Unknown action: {name}")
    return action(*args, **kwargs)


@dataclass(slots=True)
class Update:
    props: dict[str, Any]

    def to_props(self) -> dict[str, Any]:
        return dict(self.props)


def update(**props: Any) -> Update:
    return Update(props)


@dataclass(slots=True)
class _Binding:
    target: Component | State[Any]
    prop: Optional[str] = None


_DEFAULT_PROP: dict[str, str] = {
    "text": "text",
    "markdown": "value",
    "markdown_view": "value",
    "html": "html",
    "html_view": "html",
    "code": "value",
    "code_block": "value",
    "json_view": "value",
    "progress": "value",
    "text_field": "value",
    "text_area": "value",
    "search_box": "value",
    "smart_search_bar": "value",
    "intent_search": "value",
    "path_field": "value",
    "checkbox": "value",
    "switch": "value",
    "slider": "value",
    "numeric_field": "value",
    "select": "value",
    "radio": "value",
    "token": "selected",
    "check_list": "values",
    "multi_pick": "values",
    "filter_chips_bar": "values",
    "toggle_set": "values",
    "search_scope_selector": "scope",
    "tabs": "index",
    "view_stack": "index",
    "image": "src",
    "gallery": "images",
    "audio": "src",
    "video": "src",
    "table": "rows",
    "message_composer": "value",
    "file_picker": "files",
    "directory_picker": "value",
    "log_viewer": "entries",
    "code_buffer": "text",
    "code_document": "text",
    "editor_view": "text",
    "editor_surface": "text",
    "multi_cursor_controller": "cursors",
    "syntax_layer": "tokens",
    "fold_layer": "ranges",
    "semantic_layer": "items",
    "code_category_layer": "items",
    "ownership_marker": "items",
    "virtual_file_system": "nodes",
    "editor_intent_router": "shortcuts",
    "focus_mode_controller": "enabled",
    "control_preset": "props",
    "behavior_mixins": "mixins",
    "gutter": "line_count",
    "symbol_tree": "nodes",
    "outline_view": "nodes",
    "breadcrumb_bar": "items",
    "status_bar": "items",
    "command_palette": "commands",
    "diagnostic_stream": "entries",
    "execution_lane": "entries",
    "preview_surface": "status",
    "native_preview_host": "process_id",
    "state_snapshot": "snapshots",
    "hot_reload_boundary": "enabled",
    "semantic_search": "query",
    "scoped_search_replace": "query",
    "intent_router": "intents",
    "preview_intent_interceptor": "intents",
    "preview_presets": "presets",
    "layout_freeze": "enabled",
    "time_travel_lite": "steps",
    "live_control_picker": "active",
    "preview_error_overlay": "visible",
    "search_everything_panel": "query",
    "state_inspector": "value",
    "intent_panel": "intents",
}


def _normalize_bindings(items: Any, *, for_input: bool) -> list[_Binding]:
    if items is None:
        return []
    if isinstance(items, (Component, State)):
        items = [items]
    elif not isinstance(items, (list, tuple)):
        items = [items]

    out: list[_Binding] = []
    for item in items:
        if isinstance(item, State):
            out.append(_Binding(target=item))
            continue
        if isinstance(item, Component):
            prop = _DEFAULT_PROP.get(item.control_type, "value")
            out.append(_Binding(target=item, prop=prop))
            continue
        if isinstance(item, tuple) and len(item) == 2 and isinstance(item[0], Component):
            out.append(_Binding(target=item[0], prop=str(item[1])))
            continue
        raise TypeError("Inputs/outputs must be Components, State, or (Component, prop) tuples")
    return out


def _resolve_input(
    session: ButterflyUISession,
    binding: _Binding,
    payload: dict[str, Any],
    trigger_id: str,
) -> Any:
    target = binding.target
    if isinstance(target, State):
        return target.value
    prop = binding.prop or "value"
    if target.control_id == trigger_id and prop in payload:
        return payload.get(prop)
    return session.get_value(target, prop=prop)


def _apply_output(session: ButterflyUISession, binding: _Binding, value: Any) -> None:
    if value is NO_UPDATE:
        return
    target = binding.target
    if isinstance(target, State):
        target.set(value)
        return
    if isinstance(value, Update):
        target.patch(session=session, **value.to_props())
        return
    if isinstance(value, dict):
        target.patch(session=session, **value)
        return
    prop = binding.prop or "value"
    target.patch(session=session, **{prop: value})


def _accepts_kwargs(sig: inspect.Signature) -> bool:
    return any(p.kind == p.VAR_KEYWORD for p in sig.parameters.values())


def _call_callback(
    fn: Callable[..., Any],
    args: list[Any],
    *,
    state: State[Any] | None,
    progress: Progress | None,
    event: dict[str, Any],
) -> Any:
    kwargs: dict[str, Any] = {}
    appended_event_positional = False
    try:
        sig = inspect.signature(fn)
        accepts_kwargs = _accepts_kwargs(sig)

        try:
            params = list(sig.parameters.values())
            required_positional = [
                p
                for p in params
                if p.kind in (p.POSITIONAL_ONLY, p.POSITIONAL_OR_KEYWORD)
                and p.default is p.empty
            ]
            accepts_varargs = any(p.kind == p.VAR_POSITIONAL for p in params)
            if not accepts_varargs and len(required_positional) == (len(args) + 1):
                args = [*args, event]
                appended_event_positional = True
        except Exception:
            pass

        if state is not None and (accepts_kwargs or "state" in sig.parameters):
            kwargs["state"] = state
        if progress is not None and (accepts_kwargs or "progress" in sig.parameters):
            kwargs["progress"] = progress
        if not appended_event_positional:
            if accepts_kwargs or "event" in sig.parameters:
                kwargs["event"] = event
            if accepts_kwargs or "evt" in sig.parameters:
                kwargs["evt"] = event
    except (ValueError, TypeError):
        kwargs = {}
    return fn(*args, **kwargs)


def bind_event(
    session: ButterflyUISession,
    control: Component | str,
    event: str,
    fn: Callable[..., Any],
    *,
    inputs: Any = None,
    outputs: Any = None,
    state: State[Any] | None = None,
    progress: Component | Progress | None = None,
    queue: TaskQueue | None = None,
) -> Callable[[dict[str, Any]], Any]:
    """Bind an event callback and return the dispatched wrapper."""

    trigger_id = control.control_id if isinstance(control, Component) else str(control)
    input_bindings = _normalize_bindings(inputs, for_input=True)
    output_bindings = _normalize_bindings(outputs, for_input=False)
    progress_obj: Progress | None = None

    if isinstance(progress, Progress):
        progress_obj = progress
    elif isinstance(progress, Component):
        progress_obj = Progress(session, progress)

    async def _run(msg: dict[str, Any]) -> None:
        payload = msg.get("payload") if isinstance(msg.get("payload"), dict) else {}
        args = [_resolve_input(session, binding, payload, trigger_id) for binding in input_bindings]

        result = _call_callback(fn, args, state=state, progress=progress_obj, event=msg)

        async def _apply_result(value: Any) -> None:
            if not output_bindings:
                return
            if len(output_bindings) == 1:
                _apply_output(session, output_bindings[0], value)
                return
            if not isinstance(value, (list, tuple)):
                value = [value]
            for binding, item in zip(output_bindings, value):
                _apply_output(session, binding, item)

        if inspect.isasyncgen(result):
            async for item in result:
                await _apply_result(item)
        elif inspect.isgenerator(result):
            for item in result:
                await _apply_result(item)
        elif asyncio.iscoroutine(result):
            awaited = await result
            await _apply_result(awaited)
        else:
            await _apply_result(result)

    async def _handler(msg: dict[str, Any]) -> None:
        if queue is None:
            await _run(msg)
        else:
            await queue.run(lambda: _run(msg))

    def _dispatch(msg: dict[str, Any]) -> Any:
        return _handler(msg)

    session.on(trigger_id, event, _dispatch)
    return _dispatch


def wrap_event_handler(fn: Callable[..., Any]) -> Callable[[dict[str, Any]], Any]:
    """Adapt ``fn`` so it will be called with ``event=msg`` when possible.

    Behavior:
    - If ``fn`` accepts an ``event`` or ``evt`` keyword parameter or ``**kwargs``,
      the wrapper calls ``fn(event=msg)``.
    - Otherwise, if ``fn`` has no required positional parameters, the wrapper
      calls ``fn()``.
    - Otherwise the wrapper calls ``fn(msg)``.
    - If ``fn`` returns a coroutine, it will be scheduled with
      ``asyncio.create_task`` (best-effort).
    """
    import inspect
    import asyncio

    try:
        sig = inspect.signature(fn)
        accepts_kwargs = any(p.kind == p.VAR_KEYWORD for p in sig.parameters.values())
        accepts_event_kw = "event" in sig.parameters or "evt" in sig.parameters or accepts_kwargs
        required_positional = [
            p
            for p in sig.parameters.values()
            if p.kind in (p.POSITIONAL_ONLY, p.POSITIONAL_OR_KEYWORD) and p.default is p.empty
        ]
    except Exception:
        accepts_event_kw = False
        required_positional = [None]

    def _wrapped(msg: dict[str, Any]) -> Any:
        try:
            if accepts_event_kw:
                res = fn(event=msg)
            else:
                if not required_positional:
                    res = fn()
                else:
                    res = fn(msg)
            if asyncio.iscoroutine(res):
                asyncio.create_task(res)
        except Exception:
            pass

    return _wrapped


# Register built-in action helpers (best-effort).
try:
    from ..events import overlay as _overlay_actions  # noqa: F401
except Exception:
    pass
