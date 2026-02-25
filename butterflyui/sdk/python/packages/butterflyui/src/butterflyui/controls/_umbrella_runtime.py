from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

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
        value = _normalize_token(str(entry))
        if value and value not in out:
            out.append(value)
    return out


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
    role_aliases: Mapping[str, str],
    role_manifest_lists: Mapping[str, str],
    allowed_modules: set[str],
    normalize_module: Any,
) -> dict[str, Any]:
    normalized_role = _normalize_registry_role(role, role_aliases)
    normalized_module = normalize_module(module_id)
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
    if normalized_module in allowed_modules and normalized_module not in enabled_modules:
        enabled_modules.append(normalized_module)
    manifest["enabled_modules"] = enabled_modules

    list_key = role_manifest_lists.get(normalized_role)
    if list_key:
        values = _normalize_events(manifest.get(list_key)) or []
        if normalized_module not in values:
            values.append(normalized_module)
        manifest[list_key] = values
    props["manifest"] = manifest

    if normalized_module in allowed_modules:
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


def _normalize_engine(value: Any | None, *, fallback: str | None = None) -> str | None:
    normalized = _normalize_token(None if value is None else str(value))
    if not normalized:
        return fallback
    if normalized in {"xterm_terminal", "terminal_xterm"}:
        return "xterm"
    return normalized
