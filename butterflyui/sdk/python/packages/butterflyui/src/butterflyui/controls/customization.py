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
    "BrushPanel",
    "CropBox",
    "CurveEditor",
    "GuidesManager",
    "HistoryStack",
    "HistogramOverlay",
    "HistogramView",
    "InfoBar",
    "LayerMaskEditor",
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


class CropBox(Component):
    control_type = "crop_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        rect: Mapping[str, Any] | None = None,
        shade_color: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            rect=dict(rect) if rect is not None else None,
            shade_color=shade_color,
            border_color=border_color,
            border_width=border_width,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_rect(self, session: Any, rect: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_rect", {"rect": dict(rect)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class CurveEditor(Component):
    control_type = "curve_editor"

    def __init__(
        self,
        *,
        points: list[Mapping[str, Any]] | None = None,
        color: Any | None = None,
        show_grid: bool | None = None,
        show_points: bool | None = None,
        allow_add: bool | None = None,
        allow_remove: bool | None = None,
        line_width: float | None = None,
        point_size: float | None = None,
        height: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            points=[dict(point) for point in (points or [])],
            color=color,
            show_grid=show_grid,
            show_points=show_points,
            allow_add=allow_add,
            allow_remove=allow_remove,
            line_width=line_width,
            point_size=point_size,
            height=height,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_points(self, session: Any, points: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_points", {"points": [dict(point) for point in points]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class BrushPanel(Component):
    control_type = "brush_panel"

    def __init__(
        self,
        *,
        size: float | None = None,
        hardness: float | None = None,
        opacity: float | None = None,
        flow: float | None = None,
        spacing: float | None = None,
        color: Any | None = None,
        blend_mode: str | None = None,
        pressure_enabled: bool | None = None,
        smoothing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            size=size,
            hardness=hardness,
            opacity=opacity,
            flow=flow,
            spacing=spacing,
            color=color,
            blend_mode=blend_mode,
            pressure_enabled=pressure_enabled,
            smoothing=smoothing,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_value(self, session: Any, key: str, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"key": key, "value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class HistogramView(Component):
    control_type = "histogram_view"

    def __init__(
        self,
        *,
        bins: list[float] | None = None,
        channels: list[Mapping[str, Any]] | None = None,
        domain: list[float] | None = None,
        normalized: bool | None = None,
        show_grid: bool | None = None,
        compact: bool | None = None,
        height: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            bins=bins,
            channels=[dict(channel) for channel in (channels or [])],
            domain=domain,
            normalized=normalized,
            show_grid=show_grid,
            compact=compact,
            height=height,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class HistogramOverlay(Component):
    control_type = "histogram_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        bins: list[float] | None = None,
        channels: list[Mapping[str, Any]] | None = None,
        opacity: float | None = None,
        blend_mode: str | None = None,
        compact: bool | None = None,
        show_grid: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            bins=bins,
            channels=[dict(channel) for channel in (channels or [])],
            opacity=opacity,
            blend_mode=blend_mode,
            compact=compact,
            show_grid=show_grid,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class GuidesManager(Component):
    control_type = "guides_manager"

    def __init__(
        self,
        *,
        guides_x: list[float] | None = None,
        guides_y: list[float] | None = None,
        snap_tolerance: float | None = None,
        visible: bool | None = None,
        locked: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            guides_x=guides_x,
            guides_y=guides_y,
            snap_tolerance=snap_tolerance,
            visible=visible,
            locked=locked,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_guides(self, session: Any, guides_x: list[float], guides_y: list[float]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_guides",
            {"guides_x": [float(v) for v in guides_x], "guides_y": [float(v) for v in guides_y]},
        )

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class HistoryStack(Component):
    control_type = "history_stack"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        selected_index: int | None = None,
        compact: bool | None = None,
        show_preview: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected_id=selected_id,
            selected_index=selected_index,
            compact=compact,
            show_preview=show_preview,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class LayerMaskEditor(Component):
    control_type = "layer_mask_editor"

    def __init__(
        self,
        child: Any | None = None,
        *,
        value: Any | None = None,
        mask: Any | None = None,
        brush_size: float | None = None,
        hardness: float | None = None,
        opacity: float | None = None,
        feather: float | None = None,
        invert: bool | None = None,
        show_alpha: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            mask=mask,
            brush_size=brush_size,
            hardness=hardness,
            opacity=opacity,
            feather=feather,
            invert=invert,
            show_alpha=show_alpha,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class InfoBar(Component):
    control_type = "info_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        text: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            text=text,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
