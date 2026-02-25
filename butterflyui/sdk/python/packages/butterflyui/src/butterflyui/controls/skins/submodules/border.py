from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import SkinsSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = 'border'


class Border(SkinsSubmodule):
    """Skins submodule host control for `border`."""

    control_type = 'skins_border'
    umbrella = 'skins'
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
        bgcolor: str | int | None = None,
        blend_mode: str | None = None,
        color: str | int | None = None,
        elevation: int | float | None = None,
        height: int | float | str | None = None,
        intensity: int | float | None = None,
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
        theme: Mapping[str, object] | None = None,
        token_map: Mapping[str, object] | None = None,
        token_overrides: Mapping[str, object] | None = None,
        tokens: Mapping[str, object] | None = None,
        width: int | float | str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if bgcolor is not None:
            resolved_payload['bgcolor'] = bgcolor
        if blend_mode is not None:
            resolved_payload['blend_mode'] = blend_mode
        if color is not None:
            resolved_payload['color'] = color
        if elevation is not None:
            resolved_payload['elevation'] = elevation
        if height is not None:
            resolved_payload['height'] = height
        if intensity is not None:
            resolved_payload['intensity'] = intensity
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


__all__ = ['Border']
