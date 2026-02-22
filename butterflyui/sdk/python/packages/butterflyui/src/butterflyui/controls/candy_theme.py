from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "CandyTheme",
    "CandySurface",
    "CandyContainer",
    "CandyRow",
    "CandyColumn",
    "CandyStack",
    "CandyWrap",
    "CandyButton",
    "CandyCard",
]


@dataclass
class CandyTheme:
    brightness: str = "light"
    colors: dict[str, Any] = field(default_factory=dict)
    typography: dict[str, Any] = field(default_factory=dict)
    radii: dict[str, Any] = field(default_factory=dict)
    spacing: dict[str, Any] = field(default_factory=dict)
    button: dict[str, Any] = field(default_factory=dict)
    card: dict[str, Any] = field(default_factory=dict)
    effects: dict[str, Any] = field(default_factory=dict)
    ui: dict[str, Any] = field(default_factory=dict)
    webview: dict[str, Any] = field(default_factory=dict)

    def to_json(self) -> dict[str, Any]:
        return {
            "brightness": self.brightness,
            "theme": {"brightness": self.brightness},
            "colors": self.colors,
            "typography": self.typography,
            "radii": self.radii,
            "spacing": self.spacing,
            "button": self.button,
            "card": self.card,
            "effects": self.effects,
            "ui": self.ui,
            "webview": self.webview,
        }


class CandySurface(Component):
    control_type = "candy_surface"

    def __init__(
        self,
        *children: Any,
        padding: Any | None = None,
        radius: float | None = None,
        background: Any | None = None,
        bgcolor: Any | None = None,
        candy_skins: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            padding=padding,
            radius=radius,
            background=background,
            bgcolor=bgcolor,
            candy_skins=candy_skins,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyContainer(Component):
    control_type = "candy_container"

    def __init__(
        self,
        *children: Any,
        width: Any | None = None,
        height: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        candy_skins: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            candy_skins=candy_skins,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyRow(Component):
    control_type = "candy_row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        main_axis: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            main_axis=main_axis,
            cross_axis=cross_axis,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyColumn(Component):
    control_type = "candy_column"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        main_axis: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            main_axis=main_axis,
            cross_axis=cross_axis,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyStack(Component):
    control_type = "candy_stack"

    def __init__(
        self,
        *children: Any,
        alignment: Any | None = None,
        fit: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, alignment=alignment, fit=fit, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyWrap(Component):
    control_type = "candy_wrap"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        run_spacing: float | None = None,
        direction: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing,
            run_spacing=run_spacing,
            direction=direction,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class CandyButton(Component):
    control_type = "candy_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        variant: str | None = None,
        icon: str | None = None,
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
            variant=variant,
            icon=icon,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def click(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "click", {})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})


class CandyCard(Component):
    control_type = "candy_card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        subtitle: str | None = None,
        elevated: bool | None = None,
        radius: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            elevated=elevated,
            radius=radius,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
