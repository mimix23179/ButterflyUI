from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimatedGradient",
    "AvatarStack",
    "Badge",
    "BlendModePicker",
    "BlobField",
    "Border",
    "BorderSide",
    "ButtonStyle",
]


class AnimatedGradient(Component):
    control_type = "animated_gradient"

    def __init__(
        self,
        *children: Any,
        colors: list[Any] | None = None,
        duration_ms: int | None = None,
        radius: float | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            duration_ms=duration_ms,
            radius=radius,
            begin=begin,
            end=end,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})


class AvatarStack(Component):
    control_type = "avatar_stack"

    def __init__(
        self,
        *children: Any,
        avatars: list[Any] | None = None,
        size: float | None = None,
        overlap: float | None = None,
        max: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            avatars=avatars,
            size=size,
            overlap=overlap,
            max=max,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_avatars(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_avatars", {})

    def set_avatars(self, session: Any, avatars: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_avatars", {"avatars": avatars})


class Badge(Component):
    control_type = "badge"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        color: Any | None = None,
        bgcolor: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else label
        merged = merge_props(
            props,
            label=resolved,
            text=resolved,
            value=value,
            color=color,
            bgcolor=bgcolor,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})


class BlendModePicker(Component):
    control_type = "blend_mode_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options,
            label=label,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})


class BlobField(Component):
    control_type = "blob_field"

    def __init__(
        self,
        *,
        count: int | None = None,
        seed: int | None = None,
        color: Any | None = None,
        background: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            seed=seed,
            color=color,
            background=background,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def regenerate(self, session: Any, seed: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if seed is not None:
            payload["seed"] = seed
        return self.invoke(session, "regenerate", payload)


class Border(Component):
    control_type = "border"

    def __init__(
        self,
        *children: Any,
        color: Any | None = None,
        width: float | None = None,
        radius: float | None = None,
        side: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            width=width,
            radius=radius,
            side=side,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


class BorderSide(Component):
    control_type = "border_side"

    def __init__(
        self,
        *,
        side: str | None = None,
        color: Any | None = None,
        width: float | None = None,
        length: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            side=side,
            color=color,
            width=width,
            length=length,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


class ButtonStyle(Component):
    control_type = "button_style"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, value=value, options=options, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})
