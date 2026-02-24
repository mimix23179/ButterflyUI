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
    "RulerGuides",
    "RulersOverlay",
    "SceneView",
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
        variant: str | None = None,
        kind: str | None = None,
        gradient: str | None = None,
        type: str | None = None,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        duration_ms: int | None = None,
        duration: int | None = None,
        radius: float | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        angle: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        opacity: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        ping_pong: bool | None = None,
        shift: bool | None = None,
        throttle_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            kind=kind,
            gradient=gradient,
            type=type,
            colors=colors,
            stops=stops,
            duration_ms=duration_ms,
            duration=duration,
            radius=radius,
            begin=begin,
            end=end,
            angle=angle,
            start_angle=start_angle,
            end_angle=end_angle,
            opacity=opacity,
            loop=loop,
            autoplay=autoplay,
            play=play,
            playing=playing,
            ping_pong=ping_pong,
            shift=shift,
            throttle_ms=throttle_ms,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})


class AvatarStack(Component):
    control_type = "avatar_stack"

    def __init__(
        self,
        *children: Any,
        avatars: list[Any] | None = None,
        size: float | None = None,
        overlap: float | None = None,
        max: int | None = None,
        max_visible: int | None = None,
        max_count: int | None = None,
        overflow_label: str | None = None,
        stack_order: str | None = None,
        expand_on_hover: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_max = max if max is not None else max_visible
        if resolved_max is None:
            resolved_max = max_count
        merged = merge_props(
            props,
            avatars=avatars,
            size=size,
            overlap=overlap,
            max=resolved_max,
            max_visible=resolved_max,
            max_count=resolved_max,
            overflow_label=overflow_label,
            stack_order=stack_order,
            expand_on_hover=expand_on_hover,
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
        text_color: Any | None = None,
        severity: str | None = None,
        variant: str | None = None,
        dot: bool | None = None,
        pulse: bool | None = None,
        count: int | None = None,
        radius: float | None = None,
        padding: Any | None = None,
        clickable: bool | None = None,
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
            text_color=text_color,
            severity=severity,
            variant=variant,
            dot=dot,
            pulse=pulse,
            count=count,
            radius=radius,
            padding=padding,
            clickable=clickable,
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
        items: list[Any] | None = None,
        label: str | None = None,
        preview: bool | None = None,
        sample: Mapping[str, Any] | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options if options is not None else items,
            items=items,
            label=label,
            preview=preview,
            sample=dict(sample) if sample is not None else None,
            dense=dense,
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
        colors: list[Any] | None = None,
        background: Any | None = None,
        min_radius: float | None = None,
        max_radius: float | None = None,
        speed: float | None = None,
        opacity: float | None = None,
        blur_sigma: float | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        autoplay: bool | None = None,
        progress: float | None = None,
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
            colors=colors,
            background=background,
            min_radius=min_radius,
            max_radius=max_radius,
            speed=speed,
            opacity=opacity,
            blur_sigma=blur_sigma,
            loop=loop,
            play=play,
            playing=playing,
            autoplay=autoplay,
            progress=progress,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def regenerate(self, session: Any, seed: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if seed is not None:
            payload["seed"] = seed
        return self.invoke(session, "regenerate", payload)

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})

    def set_progress(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"value": float(value)})

    def set_playing(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_playing", {"value": bool(value)})


class Border(Component):
    control_type = "border"

    def __init__(
        self,
        *children: Any,
        color: Any | None = None,
        width: float | None = None,
        radius: float | None = None,
        side: str | None = None,
        sides: Mapping[str, Any] | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
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
            sides=dict(sides) if sides is not None else None,
            animated=animated,
            duration_ms=duration_ms,
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
        top: Mapping[str, Any] | None = None,
        right: Mapping[str, Any] | None = None,
        bottom: Mapping[str, Any] | None = None,
        left: Mapping[str, Any] | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
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
            top=dict(top) if top is not None else None,
            right=dict(right) if right is not None else None,
            bottom=dict(bottom) if bottom is not None else None,
            left=dict(left) if left is not None else None,
            animated=animated,
            duration_ms=duration_ms,
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
        items: list[Any] | None = None,
        base: Mapping[str, Any] | None = None,
        hover: Mapping[str, Any] | None = None,
        pressed: Mapping[str, Any] | None = None,
        disabled: Mapping[str, Any] | None = None,
        focus_ring: Mapping[str, Any] | None = None,
        motion_behavior: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options if options is not None else items,
            items=items,
            base=dict(base) if base is not None else None,
            hover=dict(hover) if hover is not None else None,
            pressed=dict(pressed) if pressed is not None else None,
            disabled=dict(disabled) if disabled is not None else None,
            focus_ring=dict(focus_ring) if focus_ring is not None else None,
            motion_behavior=dict(motion_behavior) if motion_behavior is not None else None,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def set_state_style(self, session: Any, state: str, style_props: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state_style", {"state": state, "style": dict(style_props)})


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
        alpha: bool | None = None,
        presets: list[Any] | None = None,
        emit_on_change: bool | None = None,
        show_actions: bool | None = None,
        show_input: bool | None = None,
        show_hex: bool | None = None,
        show_presets: bool | None = None,
        preset_size: float | None = None,
        preset_spacing: float | None = None,
        preview_height: float | None = None,
        input_label: str | None = None,
        input_placeholder: str | None = None,
        commit_text: str | None = None,
        cancel_text: str | None = None,
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
            alpha=alpha,
            presets=presets,
            emit_on_change=emit_on_change,
            show_actions=show_actions,
            show_input=show_input,
            show_hex=show_hex,
            show_presets=show_presets,
            preset_size=preset_size,
            preset_spacing=preset_spacing,
            preview_height=preview_height,
            input_label=input_label,
            input_placeholder=input_placeholder,
            commit_text=commit_text,
            cancel_text=cancel_text,
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
        groups: list[Any] | None = None,
        group_by: str | None = None,
        responsive: bool | None = None,
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
            groups=groups,
            group_by=group_by,
            responsive=responsive,
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
        shape: str | None = None,
        outline_width: float | None = None,
        outline_color: Any | None = None,
        stroke_width: float | None = None,
        stroke_color: Any | None = None,
        shadow_color: Any | None = None,
        shadow_blur: float | None = None,
        shadow_dx: float | None = None,
        shadow_dy: float | None = None,
        glow_color: Any | None = None,
        glow_blur: float | None = None,
        background: Any | None = None,
        bg_color: Any | None = None,
        content_padding: Any | None = None,
        inner_padding: Any | None = None,
        icon_padding: Any | None = None,
        animation: Mapping[str, Any] | None = None,
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
            shape=shape,
            outline_width=outline_width,
            outline_color=outline_color,
            stroke_width=stroke_width,
            stroke_color=stroke_color,
            shadow_color=shadow_color,
            shadow_blur=shadow_blur,
            shadow_dx=shadow_dx,
            shadow_dy=shadow_dy,
            glow_color=glow_color,
            glow_blur=glow_blur,
            background=background,
            bg_color=bg_color,
            content_padding=content_padding,
            inner_padding=inner_padding,
            icon_padding=icon_padding,
            animation=dict(animation) if animation is not None else None,
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
        tile_mode: str | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        center: Any | None = None,
        radius: float | None = None,
        focal: Any | None = None,
        focal_radius: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        start_degrees: float | None = None,
        end_degrees: float | None = None,
        bgcolor: Any | None = None,
        background: Any | None = None,
        background_color: Any | None = None,
        opacity: float | None = None,
        mesh: list[Any] | None = None,
        mesh_points: list[Any] | None = None,
        points: list[Any] | None = None,
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
            tile_mode=tile_mode,
            begin=begin,
            end=end,
            center=center,
            radius=radius,
            focal=focal,
            focal_radius=focal_radius,
            start_angle=start_angle,
            end_angle=end_angle,
            start_degrees=start_degrees,
            end_degrees=end_degrees,
            bgcolor=bgcolor,
            background=background,
            background_color=background_color,
            opacity=opacity,
            mesh=mesh,
            mesh_points=mesh_points,
            points=points,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


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
        live_preview: bool | None = None,
        export_format: str | None = None,
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
            live_preview=live_preview,
            export_format=export_format,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_stops(self, session: Any, stops: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_stops", {"stops": stops})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def add_stop(self, session: Any, position: float, color: Any) -> dict[str, Any]:
        return self.invoke(session, "add_stop", {"position": float(position), "color": color})

    def remove_stop(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "remove_stop", {"index": int(index)})


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


class RulerGuides(Component):
    control_type = "ruler_guides"

    def __init__(
        self,
        *children: Any,
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
        super().__init__(*children, props=merged, style=style, strict=strict)

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


class RulersOverlay(Component):
    control_type = "rulers_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        guides_x: list[float] | None = None,
        guides_y: list[float] | None = None,
        show_rulers: bool | None = None,
        show_grid: bool | None = None,
        grid_size: float | None = None,
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
            show_rulers=show_rulers,
            show_grid=show_grid,
            grid_size=grid_size,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

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


class SceneView(Component):
    control_type = "scene_view"

    def __init__(
        self,
        *children: Any,
        background: Any | None = None,
        show_grid: bool | None = None,
        show_axes: bool | None = None,
        camera: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            background=background,
            show_grid=show_grid,
            show_axes=show_axes,
            camera=dict(camera) if camera is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

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
