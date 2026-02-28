from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component


class CandyScope(Component):
    """
    CandyScope wraps child components and applies Candy design tokens and theme.
    
    This is the scope wrapper that enables the `ui.Candy(Button)` pattern,
    where a component class is wrapped in a CandyScope to apply candy styling.
    
    Example:
        ui.Candy(Button) -> CandyScope with Button as child
    """
    control_type = "candy_scope"

    def __init__(
        self,
        *children: Any,
        tokens: Mapping[str, Any] | None = None,
        theme: Mapping[str, Any] | None = None,
        brightness: str | None = None,
        radius: Mapping[str, Any] | None = None,
        colors: Mapping[str, Any] | None = None,
        typography: Mapping[str, Any] | None = None,
        spacing: Mapping[str, Any] | None = None,
        elevation: Mapping[str, Any] | None = None,
        motion: Mapping[str, Any] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        scope_props: dict[str, Any] = {}
        
        if tokens is not None:
            scope_props["tokens"] = dict(tokens)
        if theme is not None:
            scope_props["theme"] = dict(theme)
        if brightness is not None:
            scope_props["brightness"] = str(brightness)
        if radius is not None:
            scope_props["radius"] = dict(radius)
        if colors is not None:
            scope_props["colors"] = dict(colors)
        if typography is not None:
            scope_props["typography"] = dict(typography)
        if spacing is not None:
            scope_props["spacing"] = dict(spacing)
        if elevation is not None:
            scope_props["elevation"] = dict(elevation)
        if motion is not None:
            scope_props["motion"] = dict(motion)
        
        # Merge with any additional kwargs
        scope_props.update(kwargs)
        
        merged_props = dict(props) if props else {}
        merged_props.update(scope_props)

        super().__init__(
            *children,
            child=child,
            props=merged_props,
            style=style,
            strict=strict,
        )


class Candy(CandyScope):
    """Alias for CandyScope for backward compatibility."""
    pass
