from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Iterable, Mapping
from typing import Any

from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["CandySchemaError", "CandyTheme", "Candy"]

CANDY_SCHEMA_VERSION = 2

CANDY_MODULES = {
    "button",
    "card",
    "column",
    "container",
    "row",
    "stack",
    "surface",
    "wrap",
    "align",
    "center",
    "spacer",
    "aspect_ratio",
    "overflow_box",
    "fitted_box",
    "effects",
    "particles",
    "border",
    "shadow",
    "outline",
    "gradient",
    "animation",
    "transition",
    "canvas",
    "clip",
    "decorated_box",
    "badge",
    "avatar",
    "icon",
    "text",
    "motion",
    "page",
}

CANDY_STATES = {
    "idle",
    "hover",
    "pressed",
    "focused",
    "disabled",
    "selected",
    "loading",
}

CANDY_EVENTS = {
    "change",
    "state_change",
    "module_change",
    "click",
    "tap",
    "double_tap",
    "long_press",
    "hover_enter",
    "hover_exit",
    "hover_move",
    "focus",
    "blur",
    "focus_change",
    "animation_start",
    "animation_end",
    "transition_start",
    "transition_end",
    "gesture_pan_start",
    "gesture_pan_update",
    "gesture_pan_end",
    "gesture_scale_start",
    "gesture_scale_update",
    "gesture_scale_end",
}

CANDY_REGISTRY_ROLE_ALIASES = {
    "module": "module_registry",
    "modules": "module_registry",
    "foundation": "foundation_registry",
    "foundations": "foundation_registry",
    "interaction": "interaction_registry",
    "interactions": "interaction_registry",
    "motion_pack": "motion_registry",
    "motion": "motion_registry",
    "motions": "motion_registry",
    "effect": "effect_registry",
    "effects_pack": "effect_registry",
    "effects": "effect_registry",
    "recipe": "recipe_registry",
    "recipes": "recipe_registry",
    "provider": "provider_registry",
    "providers": "provider_registry",
    "command": "command_registry",
    "commands": "command_registry",
    "module_registry": "module_registry",
    "foundation_registry": "foundation_registry",
    "interaction_registry": "interaction_registry",
    "motion_registry": "motion_registry",
    "effect_registry": "effect_registry",
    "recipe_registry": "recipe_registry",
    "provider_registry": "provider_registry",
    "command_registry": "command_registry",
}

CANDY_REGISTRY_MANIFEST_LISTS = {
    "module_registry": "enabled_modules",
    "foundation_registry": "enabled_foundations",
    "interaction_registry": "enabled_interactions",
    "motion_registry": "enabled_motion",
    "effect_registry": "enabled_effects",
    "recipe_registry": "enabled_recipes",
    "command_registry": "enabled_commands",
}


class CandySchemaError(ValueError):
    pass


@dataclass
class CandyTheme:
    brightness: str = "light"
    colors: dict[str, Any] = field(default_factory=dict)
    typography: dict[str, Any] = field(default_factory=dict)
    radii: dict[str, Any] = field(default_factory=dict)
    spacing: dict[str, Any] = field(default_factory=dict)
    elevation: dict[str, Any] = field(default_factory=dict)
    motion: dict[str, Any] = field(default_factory=dict)
    button: dict[str, Any] = field(default_factory=dict)
    card: dict[str, Any] = field(default_factory=dict)
    effects: dict[str, Any] = field(default_factory=dict)
    ui: dict[str, Any] = field(default_factory=dict)
    webview: dict[str, Any] = field(default_factory=dict)

    def to_json(self) -> dict[str, Any]:
        return {
            "brightness": self.brightness,
            "theme": {"brightness": self.brightness},
            "colors": self.colors,
            "typography": self.typography,
            "radii": self.radii,
            "spacing": self.spacing,
            "elevation": self.elevation,
            "motion": self.motion,
            "button": self.button,
            "card": self.card,
            "effects": self.effects,
            "ui": self.ui,
            "webview": self.webview,
        }


def _normalize_token(value: str | None) -> str:
    if value is None:
        return ""
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _normalize_module(value: str | None) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return normalized


def _normalize_state(value: str | None) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return normalized


def _normalize_events(values: Iterable[Any] | None) -> list[str] | None:
    if values is None:
        return None
    out: list[str] = []
    for entry in values:
        name = _normalize_token(str(entry))
        if not name:
            continue
        if name not in out:
            out.append(name)
    return out


def _as_mapping(value: Any) -> Mapping[str, Any] | None:
    if isinstance(value, Mapping):
        return value
    return None


def _normalize_registry_role(
    value: str | None,
    aliases: Mapping[str, str],
) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return aliases.get(normalized, f"{normalized}_registry")


def _register_runtime_module(
    props: dict[str, Any],
    *,
    role: str,
    module_id: str,
    definition: Mapping[str, Any] | None,
) -> dict[str, Any]:
    normalized_role = _normalize_registry_role(role, CANDY_REGISTRY_ROLE_ALIASES)
    normalized_module = _normalize_module(module_id)
    if normalized_module is None:
        normalized_module = _normalize_token(module_id)
    if not normalized_role or not normalized_module:
        return {"ok": False, "error": "role and module_id are required"}

    registries = dict(props.get("registries") or {})
    role_registry = dict(registries.get(normalized_role) or {})
    role_registry[normalized_module] = dict(definition or {})
    registries[normalized_role] = role_registry
    props["registries"] = registries

    manifest = dict(props.get("manifest") or {})
    enabled_modules = _normalize_events(manifest.get("enabled_modules")) or []
    if normalized_module in CANDY_MODULES and normalized_module not in enabled_modules:
        enabled_modules.append(normalized_module)
    manifest["enabled_modules"] = enabled_modules

    list_key = CANDY_REGISTRY_MANIFEST_LISTS.get(normalized_role)
    if list_key:
        values = _normalize_events(manifest.get(list_key)) or []
        if normalized_module not in values:
            values.append(normalized_module)
        manifest[list_key] = values
    props["manifest"] = manifest

    if normalized_module in CANDY_MODULES:
        modules = dict(props.get("modules") or {})
        modules.setdefault(normalized_module, {})
        props["modules"] = modules
        props.setdefault(normalized_module, modules[normalized_module])

    return {
        "ok": True,
        "role": normalized_role,
        "module_id": normalized_module,
        "definition": dict(definition or {}),
    }


@dataclass
class CandyTokens:
    """Design tokens for Candy."""
    _data: dict[str, Any] = field(default_factory=dict)

    def __init__(self, data: dict[str, Any] | None = None, **kwargs: Any) -> None:
        self._data = dict(data or {})
        self._data.update(kwargs)

    def to_json(self) -> dict[str, Any]:
        return self._data

    def __setitem__(self, key: str, value: Any) -> None:
        self._data[key] = value

    def __getitem__(self, key: str) -> Any:
        return self._data[key]


class Candy(Component):
    control_type = "candy"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        variant: str | None = None,
        events: Iterable[str] | None = None,
        theme: Mapping[str, Any] | CandyTheme | None = None,
        tokens: Mapping[str, Any] | None = None,
        token_overrides: Mapping[str, Any] | None = None,
        modules: Mapping[str, Any] | None = None,
        slots: Mapping[str, Any] | None = None,
        semantics: Mapping[str, Any] | None = None,
        accessibility: Mapping[str, Any] | None = None,
        interaction: Mapping[str, Any] | None = None,
        performance: Mapping[str, Any] | None = None,
        quality: str | None = None,
        cache: bool | None = None,
        button: Mapping[str, Any] | None = None,
        card: Mapping[str, Any] | None = None,
        column: Mapping[str, Any] | None = None,
        container: Mapping[str, Any] | None = None,
        row: Mapping[str, Any] | None = None,
        stack: Mapping[str, Any] | None = None,
        surface: Mapping[str, Any] | None = None,
        wrap: Mapping[str, Any] | None = None,
        align: Mapping[str, Any] | None = None,
        center: Mapping[str, Any] | None = None,
        spacer: Mapping[str, Any] | None = None,
        aspect_ratio: Mapping[str, Any] | None = None,
        overflow_box: Mapping[str, Any] | None = None,
        fitted_box: Mapping[str, Any] | None = None,
        effects: Mapping[str, Any] | None = None,
        particles: Mapping[str, Any] | None = None,
        border: Mapping[str, Any] | None = None,
        shadow: Mapping[str, Any] | None = None,
        outline: Mapping[str, Any] | None = None,
        gradient: Mapping[str, Any] | None = None,
        animation: Mapping[str, Any] | None = None,
        transition: Mapping[str, Any] | None = None,
        canvas: Mapping[str, Any] | None = None,
        clip: Mapping[str, Any] | None = None,
        decorated_box: Mapping[str, Any] | None = None,
        badge: Mapping[str, Any] | None = None,
        avatar: Mapping[str, Any] | None = None,
        icon: Mapping[str, Any] | None = None,
        text: Mapping[str, Any] | None = None,
        motion: Mapping[str, Any] | None = None,
        schema_version: int = CANDY_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_module = _normalize_module(module)
        resolved_state = _normalize_state(state)
        resolved_events = _normalize_events(events)
        theme_payload = theme.to_json() if isinstance(theme, CandyTheme) else dict(theme or {})

        module_map: dict[str, Any] = {
            "button": button,
            "card": card,
            "column": column,
            "container": container,
            "row": row,
            "stack": stack,
            "surface": surface,
            "wrap": wrap,
            "align": align,
            "center": center,
            "spacer": spacer,
            "aspect_ratio": aspect_ratio,
            "overflow_box": overflow_box,
            "fitted_box": fitted_box,
            "effects": effects,
            "particles": particles,
            "border": border,
            "shadow": shadow,
            "outline": outline,
            "gradient": gradient,
            "animation": animation,
            "transition": transition,
            "canvas": canvas,
            "clip": clip,
            "decorated_box": decorated_box,
            "badge": badge,
            "avatar": avatar,
            "icon": icon,
            "text": text,
            "motion": motion,
        }

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, value in modules.items():
                normalized = _normalize_token(str(key))
                if value is not None:
                    merged_modules[normalized] = value
        for key, value in module_map.items():
            if value is not None:
                merged_modules[key] = value

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=resolved_module,
            state=resolved_state,
            custom_layout=custom_layout,
            layout=layout,
            manifest=dict(kwargs.pop("manifest", {}) or {}),
            registries=dict(kwargs.pop("registries", {}) or {}),
            variant=variant,
            events=resolved_events,
            theme=theme_payload,
            tokens=tokens,
            token_overrides=token_overrides,
            modules=merged_modules,
            slots=slots,
            semantics=semantics,
            accessibility=accessibility,
            interaction=interaction,
            performance=performance,
            quality=quality,
            cache=cache,
            **merged_modules,
            **kwargs,
        )
        self._validate_props(merged, strict=strict)
        self._strict_contract = strict
        super().__init__(*children, props=merged, style=style, strict=strict)

    def __call__(
        self,
        component_class: type,
        *args: Any,
        tokens: Mapping[str, Any] | None = None,
        theme: Mapping[str, Any] | CandyTheme | None = None,
        brightness: str | None = None,
        radius: Mapping[str, Any] | None = None,
        colors: Mapping[str, Any] | None = None,
        typography: Mapping[str, Any] | None = None,
        spacing: Mapping[str, Any] | None = None,
        elevation: Mapping[str, Any] | None = None,
        motion: Mapping[str, Any] | None = None,
        **kwargs: Any,
    ):
        """
        Wrap a component class in a CandyScope to apply Candy styling.
        
        This enables the `ui.Candy(Button)` pattern where a component class
        is wrapped in a CandyScope to apply candy tokens and theme.
        
        Args:
            component_class: The component class to wrap (e.g., Button, Card)
            *args: Positional arguments to pass to the component constructor
            tokens: Candy design tokens
            theme: Theme configuration
            brightness: 'light' or 'dark'
            radius: Border radius tokens
            colors: Color overrides
            typography: Typography tokens
            spacing: Spacing tokens
            elevation: Elevation/shadow tokens
            motion: Motion/animation tokens
            **kwargs: Additional arguments to pass to the component constructor
        
        Returns:
            CandyScope: A scope wrapper containing the instantiated component
        
        Example:
            ui.Candy(Button, variant='primary')  # Returns CandyScope wrapping Button instance
        """
        # Import here to avoid circular imports
        from .candy_scope import CandyScope
        
        # Instantiate the component class with the provided args/kwargs
        component = component_class(*args, **kwargs) if args or kwargs else component_class()
        
        # Wrap in CandyScope and return
        return CandyScope(
            child=component,
            tokens=tokens,
            theme=theme,
            brightness=brightness,
            radius=radius,
            colors=colors,
            typography=typography,
            spacing=spacing,
            elevation=elevation,
            motion=motion,
        )

    @staticmethod
    def _validate_props(props: Mapping[str, Any], *, strict: bool) -> None:
        try:
            ensure_valid_props("candy", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise CandySchemaError("\n".join(exc.errors)) from exc

        module = _normalize_module(str(props.get("module") or ""))
        if module and module not in CANDY_MODULES and strict:
            raise CandySchemaError(
                f"Unknown candy module '{module}'. Allowed: {sorted(CANDY_MODULES)}"
            )

        state = _normalize_state(str(props.get("state") or ""))
        if state and state not in CANDY_STATES and strict:
            raise CandySchemaError(
                f"Unknown candy state '{state}'. Allowed: {sorted(CANDY_STATES)}"
            )

        events = props.get("events")
        if isinstance(events, Iterable) and not isinstance(events, (str, bytes, Mapping)):
            for event in events:
                name = _normalize_token(str(event))
                if name and name not in CANDY_EVENTS and strict:
                    raise CandySchemaError(
                        f"Unknown candy event '{name}'. Allowed: {sorted(CANDY_EVENTS)}"
                    )

    def set_module(
        self,
        session: Any,
        module: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        normalized = _normalize_module(module)
        if normalized is None:
            return {"ok": False, "error": "module must be non-empty"}
        if normalized not in CANDY_MODULES:
            return {
                "ok": False,
                "error": f"Unknown candy module '{normalized}'. Allowed: {sorted(CANDY_MODULES)}",
            }
        args: dict[str, Any] = {
            "module": normalized,
            "payload": dict(payload or {}),
        }
        self.props["module"] = normalized
        modules = dict(_as_mapping(self.props.get("modules")) or {})
        modules[normalized] = dict(payload or {})
        self.props["modules"] = modules
        self.props[normalized] = dict(payload or {})
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_module", args)

    def update_module(self, session: Any, module: str, **payload: Any) -> dict[str, Any]:
        return self.set_module(session, module, payload)

    def set_state(self, session: Any, state: str) -> dict[str, Any]:
        normalized = _normalize_state(state)
        if normalized is None:
            return {"ok": False, "error": "state must be non-empty"}
        if normalized not in CANDY_STATES:
            return {
                "ok": False,
                "error": f"Unknown candy state '{normalized}'. Allowed: {sorted(CANDY_STATES)}",
            }
        self.props["state"] = normalized
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_state", {"state": normalized})

    def set_tokens(self, session: Any, tokens: Mapping[str, Any]) -> dict[str, Any]:
        payload = dict(tokens)
        self.props["tokens"] = payload
        return self.invoke(session, "set_tokens", {"tokens": payload})

    def set_token_overrides(
        self,
        session: Any,
        token_overrides: Mapping[str, Any],
    ) -> dict[str, Any]:
        payload = dict(token_overrides)
        self.props["token_overrides"] = payload
        return self.invoke(session, "set_token_overrides", {"token_overrides": payload})

    def set_theme(
        self,
        session: Any,
        theme: Mapping[str, Any] | CandyTheme,
    ) -> dict[str, Any]:
        payload = theme.to_json() if isinstance(theme, CandyTheme) else dict(theme)
        self.props["theme"] = payload
        return self.invoke(session, "set_theme", {"theme": payload})

    def set_slots(
        self,
        session: Any,
        slots: Mapping[str, Any],
    ) -> dict[str, Any]:
        payload = dict(slots)
        self.props["slots"] = payload
        return self.invoke(session, "set_slots", {"slots": payload})

    def set_accessibility(
        self,
        session: Any,
        accessibility: Mapping[str, Any],
    ) -> dict[str, Any]:
        payload = dict(accessibility)
        self.props["accessibility"] = payload
        return self.invoke(session, "set_accessibility", {"accessibility": payload})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        if "module" in props:
            props["module"] = _normalize_module(props.get("module"))
            if props["module"] and props["module"] not in CANDY_MODULES:
                return {
                    "ok": False,
                    "error": f"Unknown candy module '{props['module']}'. Allowed: {sorted(CANDY_MODULES)}",
                }
        if "state" in props:
            props["state"] = _normalize_state(props.get("state"))
            if props["state"] and props["state"] not in CANDY_STATES:
                return {
                    "ok": False,
                    "error": f"Unknown candy state '{props['state']}'. Allowed: {sorted(CANDY_STATES)}",
                }
        if "events" in props and isinstance(props.get("events"), Iterable):
            props["events"] = _normalize_events(props.get("events"))
            for event in props["events"] or []:
                if event not in CANDY_EVENTS:
                    return {
                        "ok": False,
                        "error": f"Unknown candy event '{event}'. Allowed: {sorted(CANDY_EVENTS)}",
                    }

        if "modules" in props and isinstance(props.get("modules"), Mapping):
            normalized_modules: dict[str, Any] = {}
            for key, value in dict(props["modules"]).items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in CANDY_MODULES and value is not None:
                    normalized_modules[normalized] = value
            props["modules"] = normalized_modules

        next_props = dict(self.props)
        next_props.update({k: v for k, v in props.items() if v is not None})
        self._validate_props(next_props, strict=self._strict_contract)
        self.props.update({k: v for k, v in props.items() if v is not None})
        return self.invoke(session, "set_props", {"props": props})

    def set_manifest(self, session: Any, manifest: Mapping[str, Any]) -> dict[str, Any]:
        manifest_payload = dict(manifest or {})
        current_manifest = dict(self.props.get("manifest") or {})
        current_manifest.update(manifest_payload)
        self.props["manifest"] = current_manifest
        return self.invoke(session, "set_manifest", {"manifest": manifest_payload})

    def register_module(
        self,
        session: Any,
        *,
        role: str,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        result = _register_runtime_module(
            self.props,
            role=role,
            module_id=module_id,
            definition=definition,
        )
        if result.get("ok") is not True:
            return result
        return self.invoke(
            session,
            "register_module",
            {
                "role": result["role"],
                "module_id": result["module_id"],
                "definition": dict(definition or {}),
            },
        )

    def register_foundation(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="foundation",
            module_id=module_id,
            definition=definition,
        )

    def register_interaction(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="interaction",
            module_id=module_id,
            definition=definition,
        )

    def register_motion(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="motion",
            module_id=module_id,
            definition=definition,
        )

    def register_effect(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="effect",
            module_id=module_id,
            definition=definition,
        )

    def register_recipe(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="recipe",
            module_id=module_id,
            definition=definition,
        )

    def register_provider(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="provider",
            module_id=module_id,
            definition=definition,
        )

    def register_command(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="command",
            module_id=module_id,
            definition=definition,
        )

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        normalized_event = _normalize_token(event)
        if normalized_event not in CANDY_EVENTS:
            return {
                "ok": False,
                "error": f"Unknown candy event '{normalized_event}'. Allowed: {sorted(CANDY_EVENTS)}",
            }
        return self.invoke(
            session,
            "emit",
            {
                "event": normalized_event,
                "payload": dict(payload or {}),
            },
        )

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)

    def click(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "click", {"payload": dict(payload or {})})

    def tap(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "tap", {"payload": dict(payload or {})})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def play_motion(self, session: Any, *, key: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if key:
            payload["key"] = key
        return self.invoke(session, "play_motion", payload)

    def pause_motion(self, session: Any, *, key: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if key:
            payload["key"] = key
        return self.invoke(session, "pause_motion", payload)

