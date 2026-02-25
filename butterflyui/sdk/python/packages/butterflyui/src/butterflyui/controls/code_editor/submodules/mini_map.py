from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "mini_map"


class MiniMap(CodeEditorSubmodule):
    """CodeEditor submodule host control for `mini_map`."""

    control_type = "code_editor_mini_map"
    umbrella = "code_editor"
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
        code: str | None = None,
        cursor: Mapping[str, object] | None = None,
        debounce_ms: int | None = None,
        document_uri: str | None = None,
        emit_on_change: bool | None = None,
        engine: str | None = None,
        font_family: str | None = None,
        font_size: int | float | None = None,
        glyph_margin: bool | None = None,
        language: str | None = None,
        line_numbers: bool | None = None,
        read_only: bool | None = None,
        scroll_left: int | float | None = None,
        scroll_top: int | float | None = None,
        selection: Mapping[str, object] | None = None,
        show_gutter: bool | None = None,
        show_minimap: bool | None = None,
        tab_size: int | None = None,
        text: str | None = None,
        theme: str | None = None,
        value: str | None = None,
        viewport: Mapping[str, object] | None = None,
        visible_lines: list[object] | None = None,
        webview_engine: str | None = None,
        word_wrap: bool | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if code is not None:
            resolved_payload["code"] = code
        if cursor is not None:
            resolved_payload["cursor"] = cursor
        if debounce_ms is not None:
            resolved_payload["debounce_ms"] = debounce_ms
        if document_uri is not None:
            resolved_payload["document_uri"] = document_uri
        if emit_on_change is not None:
            resolved_payload["emit_on_change"] = emit_on_change
        if engine is not None:
            resolved_payload["engine"] = engine
        if font_family is not None:
            resolved_payload["font_family"] = font_family
        if font_size is not None:
            resolved_payload["font_size"] = font_size
        if glyph_margin is not None:
            resolved_payload["glyph_margin"] = glyph_margin
        if language is not None:
            resolved_payload["language"] = language
        if line_numbers is not None:
            resolved_payload["line_numbers"] = line_numbers
        if read_only is not None:
            resolved_payload["read_only"] = read_only
        if scroll_left is not None:
            resolved_payload["scroll_left"] = scroll_left
        if scroll_top is not None:
            resolved_payload["scroll_top"] = scroll_top
        if selection is not None:
            resolved_payload["selection"] = selection
        if show_gutter is not None:
            resolved_payload["show_gutter"] = show_gutter
        if show_minimap is not None:
            resolved_payload["show_minimap"] = show_minimap
        if tab_size is not None:
            resolved_payload["tab_size"] = tab_size
        if text is not None:
            resolved_payload["text"] = text
        if theme is not None:
            resolved_payload["theme"] = theme
        if value is not None:
            resolved_payload["value"] = value
        if viewport is not None:
            resolved_payload["viewport"] = viewport
        if visible_lines is not None:
            resolved_payload["visible_lines"] = visible_lines
        if webview_engine is not None:
            resolved_payload["webview_engine"] = webview_engine
        if word_wrap is not None:
            resolved_payload["word_wrap"] = word_wrap
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


__all__ = ["MiniMap"]
