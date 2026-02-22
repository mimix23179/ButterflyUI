from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = ["Skins"]


class Skins(Component):
    control_type = "skins"

    def __init__(
        self,
        *children: Any,
        skins: list[Any] | None = None,
        selected_skin: str | None = None,
        presets: list[Any] | None = None,
        value: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        skins_selector: Mapping[str, Any] | None = None,
        skins_preset: Mapping[str, Any] | None = None,
        skins_editor: Mapping[str, Any] | None = None,
        skins_preview: Mapping[str, Any] | None = None,
        skins_apply: Mapping[str, Any] | None = None,
        skins_clear: Mapping[str, Any] | None = None,
        skins_token_mapper: Mapping[str, Any] | None = None,
        create_skin: Mapping[str, Any] | None = None,
        edit_skin: Mapping[str, Any] | None = None,
        delete_skin: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            skins=skins,
            selected_skin=selected_skin,
            presets=presets,
            value=value,
            enabled=enabled,
            events=events,
            skins_selector=skins_selector,
            skins_preset=skins_preset,
            skins_editor=skins_editor,
            skins_preview=skins_preview,
            skins_apply=skins_apply,
            skins_clear=skins_clear,
            skins_token_mapper=skins_token_mapper,
            create_skin=create_skin,
            edit_skin=edit_skin,
            delete_skin=delete_skin,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {
                "event": event,
                "payload": dict(payload or {}),
            },
        )

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)

    def apply(self, session: Any, skin: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if skin is not None:
            payload["skin"] = skin
        return self.invoke(session, "apply", payload)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def create_skin(self, session: Any, name: str, payload: Any | None = None) -> dict[str, Any]:
        args: dict[str, Any] = {"name": name}
        if payload is not None:
            args["payload"] = payload
        return self.invoke(session, "create_skin", args)

    def edit_skin(self, session: Any, name: str, payload: Any | None = None) -> dict[str, Any]:
        args: dict[str, Any] = {"name": name}
        if payload is not None:
            args["payload"] = payload
        return self.invoke(session, "edit_skin", args)

    def delete_skin(self, session: Any, name: str) -> dict[str, Any]:
        return self.invoke(session, "delete_skin", {"name": name})
