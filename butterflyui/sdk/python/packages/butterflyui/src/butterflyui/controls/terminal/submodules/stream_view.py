from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import TerminalSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = 'stream_view'


class StreamView(TerminalSubmodule):
    """Terminal submodule host control for `stream_view`."""

    control_type = 'terminal_stream_view'
    umbrella = 'terminal'
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN

    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))
    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))
    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))
    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))

    def __init__(
        self,
        payload: Mapping[str, object] | None = None,
        props: Mapping[str, object] | None = None,
        style: Mapping[str, object] | None = None,
        strict: bool = False,
        auto_scroll: bool | None = None,
        border_width: int | float | None = None,
        clear_on_submit: bool | None = None,
        command: str | None = None,
        commands: list[object] | None = None,
        cwd: str | None = None,
        engine: str | None = None,
        env: Mapping[str, object] | None = None,
        exit_code: int | None = None,
        filters: object | None = None,
        font_family: str | None = None,
        font_size: int | float | None = None,
        history: list[object] | None = None,
        input: str | None = None,
        line_height: int | float | None = None,
        lines: list[object] | None = None,
        max_lines: int | None = None,
        output: str | None = None,
        raw_text: str | None = None,
        read_only: bool | None = None,
        show_input: bool | None = None,
        status: str | None = None,
        strip_ansi: bool | None = None,
        webview_engine: str | None = None,
        wrap_lines: bool | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if auto_scroll is not None:
            resolved_payload['auto_scroll'] = auto_scroll
        if border_width is not None:
            resolved_payload['border_width'] = border_width
        if clear_on_submit is not None:
            resolved_payload['clear_on_submit'] = clear_on_submit
        if command is not None:
            resolved_payload['command'] = command
        if commands is not None:
            resolved_payload['commands'] = commands
        if cwd is not None:
            resolved_payload['cwd'] = cwd
        if engine is not None:
            resolved_payload['engine'] = engine
        if env is not None:
            resolved_payload['env'] = env
        if exit_code is not None:
            resolved_payload['exit_code'] = exit_code
        if filters is not None:
            resolved_payload['filters'] = filters
        if font_family is not None:
            resolved_payload['font_family'] = font_family
        if font_size is not None:
            resolved_payload['font_size'] = font_size
        if history is not None:
            resolved_payload['history'] = history
        if input is not None:
            resolved_payload['input'] = input
        if line_height is not None:
            resolved_payload['line_height'] = line_height
        if lines is not None:
            resolved_payload['lines'] = lines
        if max_lines is not None:
            resolved_payload['max_lines'] = max_lines
        if output is not None:
            resolved_payload['output'] = output
        if raw_text is not None:
            resolved_payload['raw_text'] = raw_text
        if read_only is not None:
            resolved_payload['read_only'] = read_only
        if show_input is not None:
            resolved_payload['show_input'] = show_input
        if status is not None:
            resolved_payload['status'] = status
        if strip_ansi is not None:
            resolved_payload['strip_ansi'] = strip_ansi
        if webview_engine is not None:
            resolved_payload['webview_engine'] = webview_engine
        if wrap_lines is not None:
            resolved_payload['wrap_lines'] = wrap_lines
        super().__init__(
            payload=resolved_payload,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_module_props(self, session: object, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        update_payload = dict(payload or {})
        if kwargs:
            update_payload.update(kwargs)
        return self.set_payload(session, update_payload)

    def emit_module_event(self, session: object, event: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.emit_event(session, event, payload, **kwargs)

    def run_module_action(self, session: object, action: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.run_action(session, action, payload, **kwargs)

    def contract(self) -> dict[str, object]:
        return self.describe_contract()


__all__ = ['StreamView']
