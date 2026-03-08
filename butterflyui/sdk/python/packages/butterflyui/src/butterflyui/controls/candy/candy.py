from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from .._shared import Component, merge_props
from ._helpers import (
    _bridge_candy_module_props,
    _coerce_string_list,
    _normalize_candy_module,
)
from .component_spec import CandyComponentSpec, candy_component
from .scene import CandyLayer, CandyScene, coerce_candy_layer_list, coerce_candy_scene
from .style_pack import CandyStylePack, candy_style_pack
from .tokens import CandyTheme, CandyTokens

__all__ = [
    "Candy",
    "CandyScope",
    "CandyLayer",
    "CandyScene",
    "CandyTheme",
    "CandyTokens",
    "CandyStylePack",
    "CandyComponentSpec",
    "candy_style_pack",
    "candy_component",
    "candy_enhance",
]


class CandyScope(Component):
    """
    High-level Candy enhancer for existing layouts and controls.

    `CandyScope` is the normal way to make ButterflyUI feel alive. It keeps the
    real layout/content controls intact and adds cinematic visual polish on top
    through presets, scene layers, actors, tokens, and local styling.
    """

    control_type = "candy_scope"

    tokens: CandyTokens | Mapping[str, Any] | None = None
    """
    Flat token mapping or ``CandyTokens`` helper applied to the Candy scope.
    """
    theme: CandyTheme | Mapping[str, Any] | None = None
    """
    Structured Candy theme mapping applied to the scope.
    """
    brightness: str | None = None
    """
    Scope brightness mode, typically ``"light"`` or ``"dark"``.
    """
    radius: Mapping[str, Any] | None = None
    """
    Radius-token bucket forwarded to the Candy theme scope.
    """
    colors: Mapping[str, Any] | None = None
    """
    Color-token bucket forwarded to the Candy theme scope.
    """
    typography: Mapping[str, Any] | None = None
    """
    Typography-token bucket forwarded to the Candy theme scope.
    """
    spacing: Mapping[str, Any] | None = None
    """
    Spacing-token bucket forwarded to the Candy theme scope.
    """
    elevation: Mapping[str, Any] | None = None
    """
    Elevation-token bucket forwarded to the Candy theme scope.
    """
    motion: Mapping[str, Any] | None = None
    """
    Motion-token bucket forwarded to the Candy theme scope.
    """
    button: Mapping[str, Any] | None = None
    """
    Button-token bucket forwarded to the Candy theme scope.
    """
    card: Mapping[str, Any] | None = None
    """
    Card-token bucket forwarded to the Candy theme scope.
    """
    effects: Mapping[str, Any] | None = None
    """
    Effects-token bucket forwarded to the Candy theme scope.
    """
    preset: str | None = None
    """
    High-level Candy preset such as ``"galaxy"``, ``"matrix_rain"``, or ``"flowing_water"``.
    """
    ambient: Iterable[str] | None = None
    """
    Ambient Candy enhancements applied to the subtree.
    """
    reactive: Iterable[str] | None = None
    """
    Reactive Candy enhancements such as hover or motion polish.
    """
    decor: Iterable[str] | None = None
    """
    Decorative Candy enhancements such as shimmer or rainbow borders.
    """
    actor: Mapping[str, Any] | None = None
    """
    Decorative actor overlay configuration.
    """
    scene: CandyScene | Mapping[str, Any] | None = None
    """
    Structured Candy scene or raw scene mapping applied to the subtree.
    """
    scene_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Mixed Candy scene layers appended to the scope scene definition.
    """
    background_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Candy scene layers rendered behind the subtree.
    """
    overlay_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Candy scene layers rendered above the subtree.
    """
    actors: Iterable[Mapping[str, Any]] | None = None
    """
    Additional actor overlay definitions forwarded to the runtime.
    """
    target: str | None = None
    """
    Semantic target selector describing what the Candy scope should enhance.
    """
    apply_to: str | None = None
    """
    Alias for ``target`` kept for explicit enhancement wording.
    """
    mode: str | None = None
    """
    Candy mode label such as ``"enhance"``, ``"ambient"``, or ``"reactive"``.
    """
    ui: Mapping[str, Any] | None = None
    """
    Shared UI-token bucket forwarded with the scope.
    """
    webview: Mapping[str, Any] | None = None
    """
    Webview-specific token bucket forwarded with the scope.
    """

    def __init__(
        self,
        *children: Any,
        tokens: CandyTokens | Mapping[str, Any] | None = None,
        theme: CandyTheme | Mapping[str, Any] | None = None,
        brightness: str | None = None,
        radius: Mapping[str, Any] | None = None,
        colors: Mapping[str, Any] | None = None,
        typography: Mapping[str, Any] | None = None,
        spacing: Mapping[str, Any] | None = None,
        elevation: Mapping[str, Any] | None = None,
        motion: Mapping[str, Any] | None = None,
        button: Mapping[str, Any] | None = None,
        card: Mapping[str, Any] | None = None,
        effects: Mapping[str, Any] | None = None,
        preset: str | None = None,
        ambient: Iterable[str] | None = None,
        reactive: Iterable[str] | None = None,
        decor: Iterable[str] | None = None,
        actor: Mapping[str, Any] | None = None,
        scene: CandyScene | Mapping[str, Any] | None = None,
        scene_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        background_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        overlay_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        actors: Iterable[Mapping[str, Any]] | None = None,
        target: str | None = None,
        apply_to: str | None = None,
        mode: str | None = None,
        ui: Mapping[str, Any] | None = None,
        webview: Mapping[str, Any] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_tokens: Mapping[str, Any] | None = None
        if isinstance(tokens, CandyTokens):
            resolved_tokens = tokens.to_json()
        elif tokens is not None:
            resolved_tokens = dict(tokens)

        resolved_theme: Mapping[str, Any] | None = None
        if isinstance(theme, CandyTheme):
            resolved_theme = theme.to_json()
        elif theme is not None:
            resolved_theme = dict(theme)

        scene_payload = coerce_candy_scene(scene)
        merged = merge_props(
            props,
            tokens=resolved_tokens,
            theme=resolved_theme,
            brightness=brightness,
            radius=radius,
            colors=colors,
            typography=typography,
            spacing=spacing,
            elevation=elevation,
            motion=motion,
            button=button,
            card=card,
            effects=effects,
            preset=preset,
            ambient=_coerce_string_list(ambient),
            reactive=_coerce_string_list(reactive),
            decor=_coerce_string_list(decor),
            actor=dict(actor) if actor is not None else None,
            scene=scene_payload,
            scene_layers=coerce_candy_layer_list(scene_layers),
            background_layers=coerce_candy_layer_list(
                background_layers,
                position="background",
            ),
            overlay_layers=coerce_candy_layer_list(
                overlay_layers,
                position="overlay",
            ),
            actors=[dict(item) for item in actors] if actors is not None else None,
            target=target,
            apply_to=apply_to,
            mode=mode,
            ui=ui,
            webview=webview,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Candy(Component):
    """
    Low-level Candy bridge.

    `Candy` stays the main public control, but it should be thought of as a
    ButterflyUI-native enhancement bridge: it can render one runtime module and
    also carry Candy presets, scenes, actors, and styling layers.
    """

    control_type = "candy"

    module: str | None = None
    """
    Runtime Candy module name to render.
    """
    layout: str | None = None
    """
    Compatibility alias for ``module``.
    """
    state: str | None = None
    """
    Active state name used for state-driven styling.
    """
    states: Iterable[str] | None = None
    """
    List of known runtime state names for this Candy node.
    """
    events: list[str] | None = None
    """
    Runtime event names that should be emitted back to Python.
    """
    preset: str | None = None
    """
    High-level Candy preset applied to this node.
    """
    target: str | None = None
    """
    Semantic target selector describing what this Candy node should enhance.
    """
    ambient: Iterable[str] | None = None
    """
    Ambient Candy enhancements applied to this node.
    """
    reactive: Iterable[str] | None = None
    """
    Reactive Candy enhancements applied to this node.
    """
    decor: Iterable[str] | None = None
    """
    Decorative Candy enhancements applied to this node.
    """
    scene: CandyScene | Mapping[str, Any] | None = None
    """
    Structured Candy scene or raw scene mapping applied to this node.
    """
    scene_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Mixed Candy scene layers appended to this node.
    """
    background_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Candy scene layers rendered behind this node.
    """
    overlay_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None
    """
    Candy scene layers rendered above this node.
    """
    actor: Mapping[str, Any] | None = None
    """
    Decorative actor overlay configuration.
    """

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
        layout: str | None = None,
        state: str | None = None,
        states: Iterable[str] | None = None,
        events: list[str] | None = None,
        preset: str | None = None,
        target: str | None = None,
        ambient: Iterable[str] | None = None,
        reactive: Iterable[str] | None = None,
        decor: Iterable[str] | None = None,
        scene: CandyScene | Mapping[str, Any] | None = None,
        scene_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        background_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        overlay_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
        actor: Mapping[str, Any] | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_layout = _normalize_candy_module(layout)
        raw_module: Any | None = module if module is not None else resolved_layout
        if raw_module is None and isinstance(props, Mapping):
            raw_module = props.get("module", props.get("layout"))
        resolved_module = _normalize_candy_module(raw_module)

        merged = merge_props(
            props,
            module=resolved_module,
            layout=resolved_layout,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            preset=preset,
            target=target,
            ambient=_coerce_string_list(ambient),
            reactive=_coerce_string_list(reactive),
            decor=_coerce_string_list(decor),
            scene=coerce_candy_scene(scene),
            scene_layers=coerce_candy_layer_list(scene_layers),
            background_layers=coerce_candy_layer_list(
                background_layers,
                position="background",
            ),
            overlay_layers=coerce_candy_layer_list(
                overlay_layers,
                position="overlay",
            ),
            actor=dict(actor) if actor is not None else None,
            **kwargs,
        )
        bridged = _bridge_candy_module_props(resolved_module, merged)
        super().__init__(*children, child=child, props=bridged, style=style, strict=strict)


def candy_enhance(
    child: Any,
    *,
    preset: str | None = None,
    ambient: Iterable[str] | None = None,
    reactive: Iterable[str] | None = None,
    decor: Iterable[str] | None = None,
    actor: Mapping[str, Any] | None = None,
    scene: CandyScene | Mapping[str, Any] | None = None,
    scene_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
    background_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
    overlay_layers: Iterable[str | Mapping[str, Any] | CandyLayer] | None = None,
    target: str | None = None,
    mode: str | None = "enhance",
    tokens: CandyTokens | Mapping[str, Any] | None = None,
    theme: CandyTheme | Mapping[str, Any] | None = None,
    brightness: str | None = None,
    props: Mapping[str, Any] | None = None,
    style: Mapping[str, Any] | None = None,
    strict: bool = False,
    **kwargs: Any,
) -> CandyScope:
    return CandyScope(
        child,
        preset=preset,
        ambient=ambient,
        reactive=reactive,
        decor=decor,
        actor=actor,
        scene=scene,
        scene_layers=scene_layers,
        background_layers=background_layers,
        overlay_layers=overlay_layers,
        target=target,
        mode=mode,
        tokens=tokens,
        theme=theme,
        brightness=brightness,
        props=props,
        style=style,
        strict=strict,
        **kwargs,
    )
