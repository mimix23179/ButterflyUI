from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import SkinsSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = 'delete_skin'


class DeleteSkin(SkinsSubmodule):
    """Skins submodule host control for `delete_skin`."""

    control_type = 'skins_delete_skin'
    umbrella = 'skins'
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN
    module_id = MODULE_TOKEN
    module_version = '1.0.0'
    module_depends_on = ()
    module_contributions = {}

    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))
    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))
    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))
    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))

    def __init__(
        self,
        *children: object,
        payload: Mapping[str, object] | None = None,
        props: Mapping[str, object] | None = None,
        style: Mapping[str, object] | None = None,
        strict: bool = False,
        actions: list[object] | None = None,
        bgcolor: str | int | None = None,
        blend_mode: str | None = None,
        can_apply: bool | None = None,
        can_clear: bool | None = None,
        can_create: bool | None = None,
        can_delete: bool | None = None,
        can_edit: bool | None = None,
        color: str | int | None = None,
        confirm: bool | None = None,
        elevation: int | float | None = None,
        height: int | float | str | None = None,
        intensity: int | float | None = None,
        name: object | None = None,
        opacity: int | float | None = None,
        palette: Mapping[str, object] | None = None,
        presets: list[object] | None = None,
        preview_skin: Mapping[str, object] | None = None,
        radius: int | float | None = None,
        selected_preset: str | None = None,
        selected_skin: str | None = None,
        skin_id: str | None = None,
        skin_name: str | None = None,
        skins: list[object] | None = None,
        status: str | None = None,
        target: str | None = None,
        theme: Mapping[str, object] | None = None,
        token_map: Mapping[str, object] | None = None,
        token_overrides: Mapping[str, object] | None = None,
        tokens: Mapping[str, object] | None = None,
        width: int | float | str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if actions is not None:
            resolved_payload['actions'] = actions
        if bgcolor is not None:
            resolved_payload['bgcolor'] = bgcolor
        if blend_mode is not None:
            resolved_payload['blend_mode'] = blend_mode
        if can_apply is not None:
            resolved_payload['can_apply'] = can_apply
        if can_clear is not None:
            resolved_payload['can_clear'] = can_clear
        if can_create is not None:
            resolved_payload['can_create'] = can_create
        if can_delete is not None:
            resolved_payload['can_delete'] = can_delete
        if can_edit is not None:
            resolved_payload['can_edit'] = can_edit
        if color is not None:
            resolved_payload['color'] = color
        if confirm is not None:
            resolved_payload['confirm'] = confirm
        if elevation is not None:
            resolved_payload['elevation'] = elevation
        if height is not None:
            resolved_payload['height'] = height
        if intensity is not None:
            resolved_payload['intensity'] = intensity
        if name is not None:
            resolved_payload['name'] = name
        if opacity is not None:
            resolved_payload['opacity'] = opacity
        if palette is not None:
            resolved_payload['palette'] = palette
        if presets is not None:
            resolved_payload['presets'] = presets
        if preview_skin is not None:
            resolved_payload['preview_skin'] = preview_skin
        if radius is not None:
            resolved_payload['radius'] = radius
        if selected_preset is not None:
            resolved_payload['selected_preset'] = selected_preset
        if selected_skin is not None:
            resolved_payload['selected_skin'] = selected_skin
        if skin_id is not None:
            resolved_payload['skin_id'] = skin_id
        if skin_name is not None:
            resolved_payload['skin_name'] = skin_name
        if skins is not None:
            resolved_payload['skins'] = skins
        if status is not None:
            resolved_payload['status'] = status
        if target is not None:
            resolved_payload['target'] = target
        if theme is not None:
            resolved_payload['theme'] = theme
        if token_map is not None:
            resolved_payload['token_map'] = token_map
        if token_overrides is not None:
            resolved_payload['token_overrides'] = token_overrides
        if tokens is not None:
            resolved_payload['tokens'] = tokens
        if width is not None:
            resolved_payload['width'] = width
        super().__init__(
            *children,
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


__all__ = ['DeleteSkin']
