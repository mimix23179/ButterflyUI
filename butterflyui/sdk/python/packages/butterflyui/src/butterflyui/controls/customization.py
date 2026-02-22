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
    "ColorPicker",
    "ColorSwatchGrid",
    "ContainerStyle",
    "Gradient",
    "GradientEditor",
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


class ColorPicker(Component):
    control_type = "color_picker"

    def __init__(
        self,
        value: Any | None = None,
        *,
        color: Any | None = None,
        mode: str | None = None,
        picker_mode: str | None = None,
        show_alpha: bool | None = None,
        presets: list[Any] | None = None,
        emit_on_change: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            color=color,
            mode=mode,
            picker_mode=picker_mode,
            show_alpha=show_alpha,
            presets=presets,
            emit_on_change=emit_on_change,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})


class ColorSwatchGrid(Component):
    control_type = "color_swatch_grid"

    def __init__(
        self,
        *children: Any,
        swatches: list[Any] | None = None,
        selected_id: str | None = None,
        selected_index: int | None = None,
        columns: int | None = None,
        size: float | None = None,
        spacing: float | None = None,
        show_labels: bool | None = None,
        show_add: bool | None = None,
        show_remove: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            swatches=swatches,
            selected_id=selected_id,
            selected_index=selected_index,
            columns=columns,
            size=size,
            spacing=spacing,
            show_labels=show_labels,
            show_add=show_add,
            show_remove=show_remove,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_selected(self, session: Any, selected_id: str | None = None, selected_index: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if selected_id is not None:
            payload["selected_id"] = selected_id
        if selected_index is not None:
            payload["selected_index"] = int(selected_index)
        return self.invoke(session, "set_selected", payload)


class ContainerStyle(Component):
    control_type = "container_style"

    def __init__(
        self,
        *children: Any,
        variant: str | None = None,
        bgcolor: Any | None = None,
        color: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        content_padding: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            bgcolor=bgcolor,
            color=color,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            content_padding=content_padding,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)


class Gradient(Component):
    control_type = "gradient"

    def __init__(
        self,
        *children: Any,
        variant: str | None = None,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        center: Any | None = None,
        radius: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        opacity: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            colors=colors,
            stops=stops,
            begin=begin,
            end=end,
            center=center,
            radius=radius,
            start_angle=start_angle,
            end_angle=end_angle,
            opacity=opacity,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})


class GradientEditor(Component):
    control_type = "gradient_editor"

    def __init__(
        self,
        *children: Any,
        stops: list[Any] | None = None,
        angle: float | None = None,
        show_angle: bool | None = None,
        show_add: bool | None = None,
        show_remove: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            stops=stops,
            angle=angle,
            show_angle=show_angle,
            show_add=show_add,
            show_remove=show_remove,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_stops(self, session: Any, stops: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_stops", {"stops": stops})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})
