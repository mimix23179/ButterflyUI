from __future__ import annotations

import copy
from dataclasses import dataclass, field
from typing import TYPE_CHECKING, Any
from collections.abc import Mapping

from .._shared import merge_props
from ._helpers import (
    _merge_dicts,
    _normalize_candy_module,
    _snapshot_control_value,
)
from .tokens import CandyTheme, CandyTokens

if TYPE_CHECKING:
    from .candy import Candy, CandyScope


@dataclass
class CandyComponentSpec:
    """
    Reusable custom Candy component template.
    """

    module: str = "container"
    """
    Runtime module identifier used when the spec instantiates a ``Candy`` control.
    """
    props: dict[str, Any] = field(default_factory=dict)
    """
    Base prop payload merged into the instantiated control.
    """
    style: dict[str, Any] = field(default_factory=dict)
    """
    Local style mapping applied during instantiation.
    """
    children: list[Any] = field(default_factory=list)
    """
    Snapshotted child payloads stored by the reusable component spec.
    """
    scope_tokens: dict[str, Any] | None = None
    """
    Optional token overrides injected if the spec wraps itself in ``CandyScope``.
    """
    scope_theme: dict[str, Any] | None = None
    """
    Optional theme payload injected when scope wrapping is enabled.
    """
    scope_brightness: str | None = None
    """
    Optional brightness override used by the generated ``CandyScope``.
    """
    strict: bool = False
    """
    Enables stricter validation on the instantiated control payload.
    """

    def add_children(self, *children: Any) -> "CandyComponentSpec":
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
    ) -> "Candy | CandyScope":
        from .candy import Candy, CandyScope

        resolved_module = _normalize_candy_module(module or self.module) or "container"
        merged_props = _merge_dicts(self.props, props)
        merged_style = _merge_dicts(self.style, style)
        runtime_children = copy.deepcopy(self.children)
        if children:
            runtime_children.extend(children)

        control = Candy(
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
                self.scope_tokens is not None
                or self.scope_theme is not None
                or self.scope_brightness is not None
            )
        )
        if not should_wrap_scope:
            return control
        return CandyScope(
            control,
            tokens=copy.deepcopy(self.scope_tokens) if self.scope_tokens is not None else None,
            theme=copy.deepcopy(self.scope_theme) if self.scope_theme is not None else None,
            brightness=self.scope_brightness,
        )


def candy_component(
    *children: Any,
    module: str = "container",
    props: Mapping[str, Any] | None = None,
    style: Mapping[str, Any] | None = None,
    scope_tokens: CandyTokens | Mapping[str, Any] | None = None,
    scope_theme: CandyTheme | Mapping[str, Any] | None = None,
    scope_brightness: str | None = None,
    strict: bool = False,
    **kwargs: Any,
) -> CandyComponentSpec:
    resolved_tokens: dict[str, Any] | None = None
    if isinstance(scope_tokens, CandyTokens):
        resolved_tokens = scope_tokens.to_json()
    elif isinstance(scope_tokens, Mapping):
        resolved_tokens = dict(scope_tokens)

    resolved_theme: dict[str, Any] | None = None
    if isinstance(scope_theme, CandyTheme):
        resolved_theme = scope_theme.to_json()
    elif isinstance(scope_theme, Mapping):
        resolved_theme = dict(scope_theme)

    merged_props = merge_props(props, **kwargs)
    spec = CandyComponentSpec(
        module=_normalize_candy_module(module) or "container",
        props=dict(merged_props),
        style=dict(style) if style is not None else {},
        scope_tokens=resolved_tokens,
        scope_theme=resolved_theme,
        scope_brightness=scope_brightness,
        strict=strict,
    )
    spec.add_children(*children)
    return spec
