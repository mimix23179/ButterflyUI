from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RouteHost"]

class RouteHost(Component):
    control_type = "route_host"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, route_id=route_id, title=title, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)
