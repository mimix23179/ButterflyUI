from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "tree"


class Tree(CodeEditorSubmodule):
    """CodeEditor submodule host control for `tree`."""

    control_type = "code_editor_tree"
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
        collapsed: list[object] | None = None,
        depth: int | None = None,
        expanded: list[object] | None = None,
        filter: str | None = None,
        flatten: bool | None = None,
        nodes: list[object] | None = None,
        path: str | None = None,
        root: object | None = None,
        selection: Mapping[str, object] | None = None,
        show_hidden: bool | None = None,
        sort: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if collapsed is not None:
            resolved_payload["collapsed"] = collapsed
        if depth is not None:
            resolved_payload["depth"] = depth
        if expanded is not None:
            resolved_payload["expanded"] = expanded
        if filter is not None:
            resolved_payload["filter"] = filter
        if flatten is not None:
            resolved_payload["flatten"] = flatten
        if nodes is not None:
            resolved_payload["nodes"] = nodes
        if path is not None:
            resolved_payload["path"] = path
        if root is not None:
            resolved_payload["root"] = root
        if selection is not None:
            resolved_payload["selection"] = selection
        if show_hidden is not None:
            resolved_payload["show_hidden"] = show_hidden
        if sort is not None:
            resolved_payload["sort"] = sort
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


__all__ = ["Tree"]
