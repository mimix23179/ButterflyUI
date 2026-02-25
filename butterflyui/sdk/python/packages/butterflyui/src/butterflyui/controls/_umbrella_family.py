from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ._shared import Component, merge_props


def _pascal(token: str) -> str:
    parts = [part for part in token.replace("-", "_").split("_") if part]
    if not parts:
        return "Module"
    return "".join(part[:1].upper() + part[1:] for part in parts)


def build_module_components(
    *,
    umbrella_name: str,
    control_prefix: str,
    modules: Iterable[str],
    aliases: Mapping[str, str] | None = None,
) -> dict[str, type[Component]]:
    alias_map = dict(aliases or {})
    seen_names: set[str] = set()
    out: dict[str, type[Component]] = {}

    tokens = list(dict.fromkeys(str(module).strip() for module in modules if str(module).strip()))
    for alias in alias_map:
        alias_token = str(alias).strip()
        if alias_token and alias_token not in tokens:
            tokens.append(alias_token)

    for token in tokens:
        canonical = alias_map.get(token, token)
        class_name = f"{umbrella_name}{_pascal(token)}"
        if class_name in seen_names:
            class_name = f"{class_name}Module"
        seen_names.add(class_name)

        control_type = f"{control_prefix}_{token}"
        module_token = token
        canonical_token = canonical

        class _UmbrellaModule(Component):
            def __init__(
                self,
                *children: Any,
                props: Mapping[str, Any] | None = None,
                style: Mapping[str, Any] | None = None,
                strict: bool = False,
                _canonical_module: str = canonical_token,
                _module_token: str = module_token,
                **kwargs: Any,
            ) -> None:
                merged = merge_props(
                    props,
                    module=_canonical_module,
                    module_id=_module_token,
                    **kwargs,
                )
                super().__init__(
                    *children,
                    props=merged,
                    style=style,
                    strict=strict,
                )

        _UmbrellaModule.control_type = control_type
        _UmbrellaModule.umbrella = control_prefix
        _UmbrellaModule.module = module_token
        _UmbrellaModule.canonical_module = canonical_token
        _UmbrellaModule.__name__ = class_name
        _UmbrellaModule.__qualname__ = class_name
        _UmbrellaModule.__doc__ = (
            f"{umbrella_name} module control for '{module_token}' "
            f"(canonical module '{canonical_token}')."
        )
        out[token] = _UmbrellaModule

    return out


def attach_module_family(
    umbrella_cls: type[Any],
    module_components: Mapping[str, type[Component]],
) -> type[Any]:
    namespace_attrs: dict[str, Any] = {}
    for token, component_cls in module_components.items():
        pascal = _pascal(token)
        namespace_attrs[token] = component_cls
        namespace_attrs[pascal] = component_cls
        setattr(umbrella_cls, token, component_cls)
        setattr(umbrella_cls, pascal, component_cls)

    family_name = f"{umbrella_cls.__name__}Modules"
    family_cls = type(family_name, (), namespace_attrs)
    setattr(umbrella_cls, "Modules", family_cls)
    setattr(umbrella_cls, "modules", family_cls)
    return family_cls
