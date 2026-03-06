from __future__ import annotations

import copy
import json
from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from pathlib import Path
from typing import Any

from .._shared import Component, merge_props

__all__ = [
    "Skins",
    "SkinsScope",
    "SkinsTokens",
    "SkinsPresets",
    "SkinsComponentSpec",
    "create_skin",
    "register_skin",
    "remove_skin",
    "get_skin",
    "list_skins",
    "list_custom_skins",
    "export_skin_registry",
    "load_skin_registry",
    "skins_from_candy_tokens",
    "create_skin_from_candy",
    "skins_component",
    "skins_row",
    "skins_column",
    "skins_container",
    "skins_card",
    "skins_transition",
]


_CUSTOM_SKINS: dict[str, dict[str, Any]] = {}


def _normalize_skin_name(value: Any | None) -> str:
    if value is None:
        return ""
    return str(value).strip().lower().replace("-", "_").replace(" ", "_")


def _snapshot_control_value(value: Any) -> Any:
    from ...core.control import coerce_json_value

    return coerce_json_value(value)


def _coerce_tokens_map(tokens: SkinsTokens | Mapping[str, Any] | Any | None) -> dict[str, Any]:
    if tokens is None:
        return {}
    if isinstance(tokens, SkinsTokens):
        return tokens.to_json()
    if isinstance(tokens, Mapping):
        return dict(tokens)
    if hasattr(tokens, "to_json"):
        try:
            payload = tokens.to_json()
            if isinstance(payload, Mapping):
                return dict(payload)
        except Exception:
            return {}
    return {}


def _merge_dicts(
    left: Mapping[str, Any] | None,
    right: Mapping[str, Any] | None,
) -> dict[str, Any]:
    merged: dict[str, Any] = {}
    if left:
        merged.update(dict(left))
    if right:
        merged.update(dict(right))
    return merged


def _normalize_skins_module(value: Any | None) -> str | None:
    if value is None:
        return None
    normalized = str(value).strip().lower().replace("-", "_").replace(" ", "_")
    aliases = {
        "skins": "container",
        "layout": "container",
        "surface": "container",
        "box": "container",
        "alignment": "align",
        "btn": "button",
        "decorated_box": "decorated",
        "decoratedbox": "decorated",
        "selector": "column",
        "preset": "card",
        "create_skin": "card",
        "edit_skin": "card",
        "delete_skin": "button",
        "apply": "button",
        "clear": "button",
        "token_mapper": "container",
        "token_schema": "container",
        "token_validator": "container",
        "token_exporters": "container",
        "token_exporter": "container",
        "token_pipeline": "container",
        "colors": "gradient",
        "fonts": "container",
        "icons": "container",
        "background": "decorated",
        "shadow": "border",
        "outline": "border",
        "materials": "decorated",
        "shaders": "effects",
        "interaction": "button",
        "responsive": "container",
        "editor": "column",
        "effect_editor": "effects",
        "particle_editor": "particles",
        "shader_editor": "effects",
        "material_editor": "decorated",
        "icon_editor": "container",
        "font_editor": "container",
        "color_editor": "gradient",
        "background_editor": "decorated",
        "border_editor": "border",
        "shadow_editor": "border",
        "outline_editor": "border",
    }
    return aliases.get(normalized, normalized)


def _raw_skins_module_key(value: Any | None) -> str:
    if value is None:
        return ""
    return str(value).strip().lower().replace("-", "_").replace(" ", "_")


def _bridge_skins_module_props(
    source_module: str,
    module: str | None,
    raw_props: Mapping[str, Any],
) -> dict[str, Any]:
    bridged = dict(raw_props)
    if module:
        bridged["module"] = module

    if module == "button" and bridged.get("text") is None and bridged.get("label") is not None:
        bridged["text"] = bridged.get("label")
    if module == "decorated" and bridged.get("bgcolor") is None and bridged.get("background") is not None:
        bridged["bgcolor"] = bridged.get("background")

    if source_module == "selector":
        bridged.setdefault("spacing", 8)
    elif source_module in {"preset", "create_skin", "edit_skin"}:
        bridged.setdefault("padding", {"all": 12})
        bridged.setdefault("radius", 12)
    elif source_module == "apply":
        bridged.setdefault("text", "Apply Skin")
        bridged.setdefault("variant", "filled")
    elif source_module == "clear":
        bridged.setdefault("text", "Clear")
        bridged.setdefault("variant", "outlined")
    elif source_module == "delete_skin":
        bridged.setdefault("text", "Delete Skin")
        bridged.setdefault("variant", "outlined")
    elif source_module in {"color_editor", "colors"}:
        if (
            bridged.get("gradient") is None
            and bridged.get("bgcolor") is None
            and bridged.get("background") is None
        ):
            bridged["gradient"] = {"colors": ["#6366F1", "#8B5CF6"]}
    return bridged


@dataclass
class SkinsTokens:
    """
    Serializable token map for the Skins system.

    ``SkinsTokens`` stores the resolved visual identity data used by
    ``SkinsScope`` and ``Skins`` controls. Typical sections include
    ``background``, ``surface``, ``text``, ``radius``, ``spacing``, and
    ``effects``.

    Use ``from_dict`` to construct from an existing mapping and ``to_json``
    when preparing data for runtime serialization.

    ```python
    import butterflyui as bui

    tokens = bui.SkinsTokens.from_dict({
        "background": "#1A1A2E",
        "primary": "#7B68EE",
        "radius": {"sm": 8, "md": 16},
    })
    ```
    """

    data: dict[str, Any] = field(default_factory=dict)
    """
    Raw mapping payload stored by this helper type and forwarded to the runtime after JSON-safe normalization.
    """

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "SkinsTokens":
        return SkinsTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


class SkinsPresets:
    """
    Factory for built-in skin token presets.

    Each static method returns a ``SkinsTokens`` instance ready to pass to
    ``SkinsScope(tokens=...)``.

    Available presets:
    - ``default()``: neutral light base
    - ``shadow()``: dark blue/purple profile
    - ``fire()``: warm red/orange profile
    - ``earth()``: muted earthy profile
    - ``gaming()``: neon cyber profile
    """

    @staticmethod
    def default() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#FAFAFA",
                "surface": "#F5F5F5",
                "surfaceAlt": "#EEEEEE",
                "text": "#1A1A1A",
                "mutedText": "#666666",
                "border": "#E0E0E0",
                "primary": "#6366F1",
                "secondary": "#8B5CF6",
                "radius": {"sm": 6, "md": 12, "lg": 18},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 18},
            }
        )

    @staticmethod
    def shadow() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A2E",
                "surface": "#16213E",
                "surfaceAlt": "#0F3460",
                "text": "#EAEAEA",
                "mutedText": "#A0A0A0",
                "border": "#2D2D44",
                "primary": "#7B68EE",
                "secondary": "#9370DB",
                "radius": {"sm": 8, "md": 16, "lg": 24},
                "spacing": {"xs": 4, "sm": 8, "md": 16, "lg": 24},
                "effects": {"glassBlur": 20},
            }
        )

    @staticmethod
    def fire() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A0A0A",
                "surface": "#2D1515",
                "surfaceAlt": "#4A1C1C",
                "text": "#FFE4D6",
                "mutedText": "#CC9988",
                "border": "#5C2020",
                "primary": "#FF4500",
                "secondary": "#FF6347",
                "radius": {"sm": 4, "md": 8, "lg": 16},
                "spacing": {"xs": 2, "sm": 6, "md": 10, "lg": 18},
                "effects": {"glassBlur": 10},
            }
        )

    @staticmethod
    def earth() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A14",
                "surface": "#2D2D1F",
                "surfaceAlt": "#3D3D2A",
                "text": "#E8E4D6",
                "mutedText": "#A8A490",
                "border": "#4A4A35",
                "primary": "#8B7355",
                "secondary": "#A0826D",
                "radius": {"sm": 2, "md": 6, "lg": 12},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 15},
            }
        )

    @staticmethod
    def gaming() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#0D0D1A",
                "surface": "#151525",
                "surfaceAlt": "#1E1E30",
                "text": "#00FF88",
                "mutedText": "#00AA55",
                "border": "#2A2A40",
                "primary": "#00FF88",
                "secondary": "#00DDFF",
                "radius": {"sm": 2, "md": 4, "lg": 8},
                "spacing": {"xs": 2, "sm": 4, "md": 8, "lg": 16},
                "effects": {"glassBlur": 25},
            }
        )


def _resolve_preset_tokens(name: str) -> SkinsTokens | None:
    normalized = _normalize_skin_name(name)
    if not normalized:
        return None
    if normalized == "default":
        return SkinsPresets.default()
    if normalized == "shadow":
        return SkinsPresets.shadow()
    if normalized == "fire":
        return SkinsPresets.fire()
    if normalized == "earth":
        return SkinsPresets.earth()
    if normalized in {"gaming", "cyber"}:
        return SkinsPresets.gaming()
    return None


def list_custom_skins() -> list[str]:
    """
    List user-registered custom skin names.
    """

    return sorted(_CUSTOM_SKINS.keys())


def list_skins() -> list[str]:
    """
    List all known skins: built-in presets and registered custom skins.
    """

    names = ["default", "shadow", "fire", "earth", "gaming"]
    for name in list_custom_skins():
        if name not in names:
            names.append(name)
    return names


def get_skin(name: str) -> SkinsTokens | None:
    """
    Return skin tokens by name from custom registry or built-in presets.
    """

    normalized = _normalize_skin_name(name)
    custom = _CUSTOM_SKINS.get(normalized)
    if custom is not None:
        payload = custom.get("tokens")
        if isinstance(payload, Mapping):
            return SkinsTokens(dict(payload))
    return _resolve_preset_tokens(normalized)


def register_skin(
    name: str,
    tokens: SkinsTokens | Mapping[str, Any] | Any,
    *,
    metadata: Mapping[str, Any] | None = None,
) -> dict[str, Any]:
    """
    Register or replace a custom skin in the Python-side skin registry.

    Registered skins can be activated by name via ``SkinsScope(skin=...)``.
    The wrapper injects the token payload so Dart receives renderable values.
    """

    normalized = _normalize_skin_name(name)
    if not normalized:
        raise ValueError("Skin name must not be empty.")
    token_map = _coerce_tokens_map(tokens)
    if not token_map:
        raise ValueError("Skin tokens are required when registering a custom skin.")
    spec: dict[str, Any] = {"name": normalized, "tokens": token_map}
    if metadata:
        spec["metadata"] = dict(metadata)
    _CUSTOM_SKINS[normalized] = spec
    return copy.deepcopy(spec)


def remove_skin(name: str) -> bool:
    """
    Remove a custom skin from the registry. Returns ``True`` if removed.
    """

    normalized = _normalize_skin_name(name)
    if normalized in _CUSTOM_SKINS:
        del _CUSTOM_SKINS[normalized]
        return True
    return False


def create_skin(
    name: str,
    *,
    base: str | None = None,
    tokens: SkinsTokens | Mapping[str, Any] | Any | None = None,
    overrides: Mapping[str, Any] | None = None,
    metadata: Mapping[str, Any] | None = None,
    register: bool = True,
) -> SkinsTokens:
    """
    Build a custom skin token set and optionally register it.

    ``base`` can reference a built-in preset or another registered custom skin.
    ``tokens`` and ``overrides`` are merged on top of the base in that order.
    """

    merged: dict[str, Any] = {}
    if base:
        base_tokens = get_skin(base)
        if base_tokens is None:
            raise ValueError(f"Unknown base skin '{base}'.")
        merged.update(base_tokens.to_json())
    merged.update(_coerce_tokens_map(tokens))
    if overrides:
        merged.update(dict(overrides))
    if register:
        register_skin(name, merged, metadata=metadata)
    return SkinsTokens(merged)


def export_skin_registry(
    path: str | Path | None = None,
    *,
    include_presets: bool = False,
) -> dict[str, Any]:
    """
    Export skin registry content as a serializable mapping.

    If ``path`` is provided, JSON is written to disk and the payload is still
    returned.
    """

    payload: dict[str, Any] = {}
    if include_presets:
        for preset in ("default", "shadow", "fire", "earth", "gaming"):
            resolved = get_skin(preset)
            if resolved is not None:
                payload[preset] = {"name": preset, "tokens": resolved.to_json()}
    for name, spec in _CUSTOM_SKINS.items():
        payload[name] = copy.deepcopy(spec)
    if path is not None:
        output = Path(path).expanduser()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(payload, indent=2, ensure_ascii=True), encoding="utf-8")
    return payload


def load_skin_registry(
    source: str | Path | Mapping[str, Any],
    *,
    clear_existing: bool = False,
) -> dict[str, dict[str, Any]]:
    """
    Import custom skin specs from a JSON file path or mapping payload.
    """

    raw: Mapping[str, Any]
    if isinstance(source, Mapping):
        raw = source
    else:
        path = Path(source).expanduser()
        loaded = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(loaded, Mapping):
            raise ValueError("Skin registry file must contain a JSON object.")
        raw = loaded

    if clear_existing:
        _CUSTOM_SKINS.clear()

    for key, value in raw.items():
        name = _normalize_skin_name(key)
        if not name:
            continue
        if isinstance(value, Mapping) and "tokens" in value:
            tokens_payload = value.get("tokens")
            metadata = value.get("metadata")
        else:
            tokens_payload = value
            metadata = None
        if not isinstance(tokens_payload, Mapping):
            continue
        register_skin(name, tokens_payload, metadata=metadata if isinstance(metadata, Mapping) else None)
    return {name: copy.deepcopy(spec) for name, spec in _CUSTOM_SKINS.items()}


def skins_from_candy_tokens(
    tokens: Mapping[str, Any] | Any,
    *,
    overrides: Mapping[str, Any] | None = None,
) -> SkinsTokens:
    """
    Convert Candy token/theme payloads into Skins-compatible token buckets.

    This enables workflows where users author style packs in Candy and then
    reuse those design tokens as Skins identities.
    """

    if hasattr(tokens, "to_json"):
        raw_candidate = tokens.to_json()
    else:
        raw_candidate = tokens
    raw = dict(raw_candidate) if isinstance(raw_candidate, Mapping) else {}

    colors = raw.get("colors")
    if isinstance(colors, Mapping):
        color_map = dict(colors)
    else:
        color_map = {}

    radii = raw.get("radii")
    if not isinstance(radii, Mapping):
        radii = raw.get("radius") if isinstance(raw.get("radius"), Mapping) else {}
    spacing = raw.get("spacing") if isinstance(raw.get("spacing"), Mapping) else {}
    effects = raw.get("effects") if isinstance(raw.get("effects"), Mapping) else {}

    result: dict[str, Any] = {
        "background": color_map.get("background") or raw.get("background"),
        "surface": color_map.get("surface") or raw.get("surface"),
        "surfaceAlt": color_map.get("surfaceAlt") or raw.get("surfaceAlt"),
        "text": color_map.get("text") or raw.get("text"),
        "mutedText": color_map.get("mutedText") or raw.get("mutedText"),
        "border": color_map.get("border") or raw.get("border"),
        "primary": color_map.get("primary") or raw.get("primary"),
        "secondary": color_map.get("secondary") or raw.get("secondary"),
        "success": color_map.get("success") or raw.get("success"),
        "warning": color_map.get("warning") or raw.get("warning"),
        "info": color_map.get("info") or raw.get("info"),
        "error": color_map.get("error") or raw.get("error"),
        "radius": dict(radii),
        "spacing": dict(spacing),
        "effects": dict(effects),
    }
    result = {key: value for key, value in result.items() if value is not None}
    if overrides:
        result.update(dict(overrides))
    return SkinsTokens(result)


def create_skin_from_candy(
    name: str,
    candy_tokens: Mapping[str, Any] | Any,
    *,
    overrides: Mapping[str, Any] | None = None,
    metadata: Mapping[str, Any] | None = None,
    register: bool = True,
) -> SkinsTokens:
    """
    Convert Candy tokens/theme data into Skins tokens and optionally register.
    """

    converted = skins_from_candy_tokens(candy_tokens, overrides=overrides)
    if register:
        register_skin(name, converted, metadata=metadata)
    return converted


@dataclass
class SkinsComponentSpec:
    """
    Reusable custom component template for Skins-based UI composition.
    """

    module: str = "container"
    """
    Runtime module identifier that tells the umbrella control which Flutter-side implementation to render.
    """
    props: dict[str, Any] = field(default_factory=dict)
    """
    Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
    """
    style: dict[str, Any] = field(default_factory=dict)
    """
    Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
    """
    children: list[Any] = field(default_factory=list)
    """
    Ordered list of child payloads nested inside this reusable component spec.
    """
    scope_skin: str | None = None
    """
    Name of the skin preset automatically applied when this component spec instantiates inside a ``SkinsScope``.
    """
    scope_tokens: dict[str, Any] | None = None
    """
    Token overrides injected into the generated ``SkinsScope`` when this component spec is instantiated.
    """
    scope_brightness: str | None = None
    """
    Brightness override applied when this component spec wraps the instantiated control in a ``SkinsScope``.
    """
    strict: bool = False
    """
    Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """

    def add_children(self, *children: Any) -> "SkinsComponentSpec":
        """
        Append child controls, snapshotted to JSON-safe control payloads.
        """

        for child in children:
            self.children.append(_snapshot_control_value(child))
        return self

    def instantiate(
        self,
        *children: Any,
        module: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool | None = None,
        wrap_scope: bool | None = None,
        child: Any | None = None,
        **kwargs: Any,
    ) -> Skins | SkinsScope:
        """
        Build a ``Skins`` node from this spec with optional overrides.
        """

        resolved_module = _normalize_skins_module(module or self.module) or "container"
        merged_props = _merge_dicts(self.props, props)
        merged_style = _merge_dicts(self.style, style)
        runtime_children = copy.deepcopy(self.children)
        if children:
            runtime_children.extend(children)

        control = Skins(
            *runtime_children,
            module=resolved_module,
            child=child,
            props=merged_props or None,
            style=merged_style or None,
            strict=self.strict if strict is None else bool(strict),
            **kwargs,
        )
        should_wrap_scope = (
            wrap_scope
            if wrap_scope is not None
            else (
                self.scope_skin is not None
                or self.scope_tokens is not None
                or self.scope_brightness is not None
            )
        )
        if not should_wrap_scope:
            return control
        return SkinsScope(
            control,
            skin=self.scope_skin,
            tokens=copy.deepcopy(self.scope_tokens) if self.scope_tokens is not None else None,
            brightness=self.scope_brightness,
        )


def skins_component(
    *children: Any,
    module: str = "container",
    props: Mapping[str, Any] | None = None,
    style: Mapping[str, Any] | None = None,
    scope_skin: str | None = None,
    scope_tokens: SkinsTokens | Mapping[str, Any] | None = None,
    scope_brightness: str | None = None,
    strict: bool = False,
    **kwargs: Any,
) -> SkinsComponentSpec:
    """
    Build a reusable ``SkinsComponentSpec`` from controls and base props.
    """

    resolved_tokens: dict[str, Any] | None = None
    if isinstance(scope_tokens, SkinsTokens):
        resolved_tokens = scope_tokens.to_json()
    elif isinstance(scope_tokens, Mapping):
        resolved_tokens = dict(scope_tokens)

    merged_props = merge_props(props, **kwargs)
    spec = SkinsComponentSpec(
        module=_normalize_skins_module(module) or "container",
        props=dict(merged_props),
        style=dict(style) if style is not None else {},
        scope_skin=_normalize_skin_name(scope_skin) or None,
        scope_tokens=resolved_tokens,
        scope_brightness=scope_brightness,
        strict=strict,
    )
    spec.add_children(*children)
    return spec


class SkinsScope(Component):
    """
    Scope wrapper that provides active skin tokens to descendants.

    ``SkinsScope`` selects and injects the current skin context for nested
    ``Skins`` nodes. You can choose a preset with ``skin=...`` and optionally
    override with ``tokens=...``.

    ``brightness`` controls whether the runtime should treat the scoped skin
    as light or dark for theme-derived defaults.

    Inside the scope, controls can target standard style slots and class-based
    recipes using ``style_slots`` and ``classes`` to keep skin behavior
    consistent across Candy, Display, Bubble, and Gallery nodes.

    ```python
    import butterflyui as bui

    bui.SkinsScope(
        bui.Skins(bui.Text("Styled card"), module="card"),
        skin="shadow",
        brightness="dark",
    )
    ```

    Args:
        skin:
            Named built-in skin preset. Values include ``"default"``,
            ``"shadow"``, ``"fire"``, ``"earth"``, ``"gaming"``.
            Custom names registered through ``register_skin``/``create_skin``
            are also supported.
        tokens:
            Custom ``SkinsTokens`` instance or raw mapping.
        brightness:
            Color mode override. Values: ``"light"``, ``"dark"``.
    """


    skin: str | None = None
    """
    Named built-in skin preset. Values include ``"default"``,
    ``"shadow"``, ``"fire"``, ``"earth"``, ``"gaming"``.
    Custom names registered through ``register_skin``/``create_skin``
    are also supported.
    """

    tokens: SkinsTokens | Mapping[str, Any] | None = None
    """
    Custom ``SkinsTokens`` instance or raw mapping.
    """

    brightness: str | None = None
    """
    Color mode override. Values: ``"light"``, ``"dark"``.
    """


    control_type = "skins_scope"

    def __init__(
        self,
        *children: Any,
        skin: str | None = None,
        tokens: SkinsTokens | Mapping[str, Any] | None = None,
        brightness: str | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_tokens: Mapping[str, Any] | None = None
        if isinstance(tokens, SkinsTokens):
            resolved_tokens = tokens.to_json()
        elif tokens is not None:
            resolved_tokens = dict(tokens)
        normalized_skin = _normalize_skin_name(skin) or None
        if resolved_tokens is None and normalized_skin is not None:
            custom = _CUSTOM_SKINS.get(normalized_skin)
            if custom is not None:
                token_payload = custom.get("tokens")
                if isinstance(token_payload, Mapping):
                    resolved_tokens = dict(token_payload)
        merged = merge_props(
            props,
            skin=normalized_skin,
            tokens=resolved_tokens,
            brightness=brightness,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Skins(Component):
    """Umbrella Skins control that renders skin modules.
    
    ``Skins`` dispatches to one module at a time and is the runtime-facing
    entry point for skin-aware UI composition.
    
    Common module groups:
    - layout: ``row``, ``column``, ``stack``, ``wrap``, ``container``, ``card``
    - decoration: ``gradient``, ``decorated``, ``clip``, ``border``
    - effects/motion: ``effects``, ``particles``, ``animation``, ``transition``
    
    Module aliases are normalized before serialization. For example,
    ``decorated_box`` maps to ``decorated``, ``apply`` maps to ``button``, and
    ``color_editor`` maps to ``gradient``.
    
    The constructor also bridges some common props, for example:
    - ``label`` -> ``text`` for button-like modules
    - ``background`` -> ``bgcolor`` for decorated modules
    
    Skins modules use the same universal decorator contract as the rest of the
    runtime: ``modifiers`` + state modifier keys, ``motion`` + enter/hover/
    press motion keys, and ``effects`` + effect ordering/clipping keys.
    
    ```python
    import butterflyui as bui
    
    bui.Skins(
        bui.Text("Card content"),
        module="card",
        events=["tap"],
    )
    ```
    
    Args:
        module:
            Name of the runtime module to render.
        layout:
            Backward-compatible alias for ``module``. When both fields are provided, ``module`` takes precedence and this alias is kept only for compatibility.
        state:
            Active state name used for state-driven styling.
        states:
            List of all recognized state names for this control.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        **kwargs:
            Additional module-specific props forwarded to runtime.
    """


    module: str | None = None
    """
    Name of the runtime module to render.
    """

    layout: str | None = None
    """
    Backward-compatible alias for ``module``. When both fields are provided, ``module`` takes precedence and this alias is kept only for compatibility.
    """

    state: str | None = None
    """
    Active state name used for state-driven styling.
    """

    states: Iterable[str] | None = None
    """
    List of all recognized state names for this control.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """


    control_type = "skins"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
        layout: str | None = None,
        state: str | None = None,
        states: Iterable[str] | None = None,
        events: list[str] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_layout = _normalize_skins_module(layout)
        raw_module: Any | None = module if module is not None else resolved_layout
        if raw_module is None and isinstance(props, Mapping):
            raw_module = props.get("module", props.get("layout"))
        source_module = _raw_skins_module_key(raw_module)
        resolved_module = _normalize_skins_module(raw_module)

        merged = merge_props(
            props,
            module=resolved_module,
            layout=resolved_layout,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            **kwargs,
        )
        bridged = _bridge_skins_module_props(source_module, resolved_module, merged)
        super().__init__(*children, child=child, props=bridged, style=style, strict=strict)


def skins_row(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="row", **kwargs)


def skins_column(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="column", **kwargs)


def skins_container(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="container", **kwargs)


def skins_card(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="card", **kwargs)


def skins_transition(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="transition", **kwargs)
