from __future__ import annotations

import inspect
from collections.abc import Iterable, Mapping, Sequence
from dataclasses import dataclass
from typing import Any

from ._shared import merge_props
from ._umbrella_runtime import _normalize_events, _normalize_state


@dataclass(frozen=True)
class UmbrellaSubmoduleSpec:
    token: str
    canonical_module: str
    class_name: str
    control_type: str
    events: tuple[str, ...]


def _pascal(token: str) -> str:
    parts = [part for part in token.replace("-", "_").split("_") if part]
    if not parts:
        return "Module"
    return "".join(part[:1].upper() + part[1:] for part in parts)


def _coerce_mapping(value: Any) -> dict[str, Any]:
    if isinstance(value, Mapping):
        return dict(value)
    return {}


def build_submodule_specs(
    *,
    control_prefix: str,
    modules: Sequence[str],
    aliases: Mapping[str, str] | None = None,
    events: Sequence[str] | None = None,
) -> dict[str, UmbrellaSubmoduleSpec]:
    alias_map = dict(aliases or {})
    normalized_events = tuple(sorted({str(event).strip() for event in (events or ()) if str(event).strip()}))

    tokens: list[str] = list(dict.fromkeys(str(module).strip() for module in modules if str(module).strip()))
    for alias in alias_map:
        normalized_alias = str(alias).strip()
        if normalized_alias and normalized_alias not in tokens:
            tokens.append(normalized_alias)

    out: dict[str, UmbrellaSubmoduleSpec] = {}
    used_class_names: set[str] = set()
    for token in tokens:
        canonical_module = alias_map.get(token, token)
        class_name = _pascal(token)
        if class_name in used_class_names:
            class_name = f"{class_name}Module"
        used_class_names.add(class_name)
        # Use canonical module token for control type so aliases always map to active runtime modules.
        control_type = f"{control_prefix}_{canonical_module}"
        out[token] = UmbrellaSubmoduleSpec(
            token=token,
            canonical_module=canonical_module,
            class_name=class_name,
            control_type=control_type,
            events=normalized_events,
        )
    return out


def build_submodule_class(
    *,
    umbrella_cls: type[Any],
    control_prefix: str,
    spec: UmbrellaSubmoduleSpec,
    module_path: str,
) -> type[Any]:
    module_token = spec.token
    canonical_module = spec.canonical_module
    class_name = spec.class_name
    supported_events = tuple(spec.events)
    supports_children = any(
        parameter.kind == inspect.Parameter.VAR_POSITIONAL
        for parameter in inspect.signature(umbrella_cls.__init__).parameters.values()
    )

    class _UmbrellaSubmodule(umbrella_cls):
        def __init__(
            self,
            *children: Any,
            payload: Mapping[str, Any] | None = None,
            module_payload: Mapping[str, Any] | None = None,
            events: Iterable[str] | None = None,
            state: str | None = None,
            custom_layout: bool | None = None,
            host_layout: str | None = None,
            manifest: Mapping[str, Any] | None = None,
            registries: Mapping[str, Any] | None = None,
            modules: Mapping[str, Any] | None = None,
            props: Mapping[str, Any] | None = None,
            style: Mapping[str, Any] | None = None,
            strict: bool = False,
            **kwargs: Any,
        ) -> None:
            kwargs.pop("module", None)
            kwargs.pop("module_id", None)

            merged_payload = _coerce_mapping(module_payload)
            merged_payload.update(_coerce_mapping(payload))

            token_payload = kwargs.pop(module_token, None)
            merged_payload.update(_coerce_mapping(token_payload))
            if canonical_module != module_token:
                canonical_payload = kwargs.pop(canonical_module, None)
                merged_payload.update(_coerce_mapping(canonical_payload))

            merged_modules: dict[str, Any] = {}
            if isinstance(modules, Mapping):
                for key, value in modules.items():
                    key_token = str(key).strip().lower().replace("-", "_")
                    if not key_token:
                        continue
                    if isinstance(value, Mapping):
                        merged_modules[key_token] = dict(value)
                    elif value is not None:
                        merged_modules[key_token] = value

            existing_module_payload = _coerce_mapping(merged_modules.get(canonical_module))
            existing_module_payload.update(merged_payload)
            merged_modules[canonical_module] = existing_module_payload

            normalized_events = _normalize_events(events)
            if (
                normalized_events is None
                and "events" not in kwargs
                and not _coerce_mapping(props).get("events")
                and supported_events
            ):
                normalized_events = list(supported_events)

            merged_manifest = dict(manifest or kwargs.pop("manifest", {}) or {})
            merged_registries = dict(registries or kwargs.pop("registries", {}) or {})

            merged = merge_props(
                props,
                module=canonical_module,
                module_id=module_token,
                state=_normalize_state(state) if state is not None else None,
                custom_layout=custom_layout,
                layout=host_layout,
                events=normalized_events,
                manifest=merged_manifest,
                registries=merged_registries,
                modules=merged_modules,
                **kwargs,
            )

            resolved_payload = _coerce_mapping(merged.get(canonical_module))
            resolved_payload.update(existing_module_payload)
            merged[canonical_module] = resolved_payload

            merged_modules_from_props = _coerce_mapping(merged.get("modules"))
            merged_section = _coerce_mapping(merged_modules_from_props.get(canonical_module))
            merged_section.update(resolved_payload)
            merged_modules_from_props[canonical_module] = merged_section
            merged["modules"] = merged_modules_from_props

            if supports_children:
                super().__init__(  # type: ignore[misc]
                    *children,
                    props=merged,
                    style=style,
                    strict=strict,
                )
                return

            if children:
                raise TypeError(
                    f"{umbrella_cls.__name__}.{class_name} does not accept positional children. "
                    "Pass runtime payload via keyword props/payload instead."
                )
            super().__init__(  # type: ignore[misc]
                props=merged,
                style=style,
                strict=strict,
            )

        def set_payload(self, session: Any, payload: Mapping[str, Any] | None = None, **kwargs: Any) -> dict[str, Any]:
            update_payload = _coerce_mapping(payload)
            if kwargs:
                update_payload.update(dict(kwargs))
            set_module = getattr(self, "set_module", None)
            if not callable(set_module):
                return {"ok": False, "error": "set_module is not supported by umbrella host"}
            return set_module(session, canonical_module, update_payload)

    _UmbrellaSubmodule.control_type = spec.control_type
    _UmbrellaSubmodule.umbrella = control_prefix
    _UmbrellaSubmodule.module = canonical_module
    _UmbrellaSubmodule.module_id = module_token
    _UmbrellaSubmodule.canonical_module = canonical_module
    _UmbrellaSubmodule.supported_events = supported_events
    _UmbrellaSubmodule.__name__ = class_name
    _UmbrellaSubmodule.__qualname__ = class_name
    _UmbrellaSubmodule.__module__ = module_path
    _UmbrellaSubmodule.__doc__ = (
        f"{umbrella_cls.__name__} submodule control for '{module_token}' "
        f"(canonical module '{canonical_module}')."
    )
    return _UmbrellaSubmodule
