from __future__ import annotations

import copy
from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from typing import Any

from .._shared import Component, merge_props

__all__ = [
    "Candy",
    "CandyScope",
    "CandyTheme",
    "CandyTokens",
    "CandyStylePack",
    "CandyComponentSpec",
    "candy_style_pack",
    "candy_component",
]


def _coerce_mapping(value: Mapping[str, Any] | None) -> dict[str, Any] | None:
    if value is None:
        return None
    return dict(value)


def _merge_dicts(
    left: Mapping[str, Any] | None,
    right: Mapping[str, Any] | None,
) -> dict[str, Any]:
    merged: dict[str, Any] = {}
    if left:
        merged.update(dict(left))
    if right:
        merged.update(dict(right))
    return merged


def _snapshot_control_value(value: Any) -> Any:
    from ...core.control import coerce_json_value

    return coerce_json_value(value)


def _normalize_candy_module(value: Any | None) -> str | None:
    if value is None:
        return None
    normalized = str(value).strip().lower().replace("-", "_").replace(" ", "_")
    aliases = {
        "candy": "container",
        "layout": "container",
        "layout_primitive": "container",
        "layout_primitives": "container",
        "layout_system": "container",
        "surface_primitives": "surface",
        "surface_system": "surface",
        "surfaces": "surface",
        "typography": "text",
        "typography_system": "text",
        "decoration_system": "decorated_box",
        "style": "decorated_box",
        "styling": "decorated_box",
        "decoration": "decorated_box",
        "decorated": "decorated_box",
        "decoratedbox": "decorated_box",
        "aspectratio": "aspect_ratio",
        "overflowbox": "overflow_box",
        "fittedbox": "fitted_box",
        "buttonstyle": "button_style",
        "particle": "particles",
        "visual_modifiers": "effects",
        "effects_pipeline": "effects",
        "motion_system": "motion",
        "animation_system": "motion",
        "interaction": "pressable",
        "interaction_wrapper": "pressable",
        "interaction_wrappers": "pressable",
        "pressable_wrapper": "pressable",
        "gesture": "gesture_area",
        "gesture_wrapper": "gesture_area",
        "hover": "hover_region",
        "hover_wrapper": "hover_region",
        "split": "split_pane",
        "layers": "layer",
        "view": "viewport",
    }
    return aliases.get(normalized, normalized)


def _bridge_candy_module_props(
    module: str | None,
    raw_props: Mapping[str, Any],
) -> dict[str, Any]:
    bridged = dict(raw_props)
    if module:
        bridged["module"] = module
    if module == "page":
        bridged.setdefault("safe_area", True)
    if module == "surface" and bridged.get("bgcolor") is None and bridged.get("background") is not None:
        bridged["bgcolor"] = bridged.get("background")
    if module == "button" and bridged.get("text") is None and bridged.get("label") is not None:
        bridged["text"] = bridged.get("label")
    if module == "text":
        if bridged.get("text") is None and bridged.get("label") is not None:
            bridged["text"] = bridged.get("label")
        if bridged.get("text") is None and bridged.get("value") is not None:
            bridged["text"] = bridged.get("value")
    if module == "effects":
        bridged.setdefault("overlay", True)
    return bridged


@dataclass
class CandyTokens:
    """
    Serializable token map used by ``CandyScope``.

    This is the low-level token container for Candy controls. ``data`` is
    forwarded as-is to the Flutter runtime, so it can contain nested token
    groups such as ``colors``, ``spacing``, ``radius``, ``effects``, and
    other custom buckets used by your app.

    Use ``from_dict`` when you already have a mapping, and ``to_json`` when
    you need a payload-safe dictionary.

    ```python
    import butterflyui as bui

    tokens = bui.CandyTokens.from_dict({
        "primary": "#6366F1",
        "background": "#FFFFFF",
    })
    ```
    """


    data: dict[str, Any] = field(default_factory=dict)

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "CandyTokens":
        return CandyTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


@dataclass
class CandyTheme:
    """
    Structured token bundle for ``CandyScope``.

    ``CandyTheme`` is a higher-level helper over ``CandyTokens``. It groups
    token values into semantic sections:
    ``colors``, ``typography``, ``radii``, ``spacing``, ``elevation``,
    ``motion``, ``button``, ``card``, ``effects``, ``ui``, and ``webview``.
    ``brightness`` sets the intended light/dark mode.

    ``to_json`` flattens this structure into the runtime payload format used
    by the Flutter side.

    ```python
    import butterflyui as bui

    theme = bui.CandyTheme(
        brightness="dark",
        colors={"primary": "#6366F1", "background": "#0A0A0A"},
        radii={"md": 12},
    )
    scope = bui.CandyScope(bui.Text("Hi"), theme=theme)
    ```
    """


    brightness: str = "light"
    colors: dict[str, Any] = field(default_factory=dict)
    typography: dict[str, Any] = field(default_factory=dict)
    radii: dict[str, Any] = field(default_factory=dict)
    spacing: dict[str, Any] = field(default_factory=dict)
    elevation: dict[str, Any] = field(default_factory=dict)
    motion: dict[str, Any] = field(default_factory=dict)
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
            "elevation": self.elevation,
            "motion": self.motion,
            "button": self.button,
            "card": self.card,
            "effects": self.effects,
            "ui": self.ui,
            "webview": self.webview,
        }


@dataclass
class CandyStylePack:
    """
    Declarative custom style-pack spec builder for Candy/runtime themes.

    ``CandyStylePack`` wraps the same runtime payload shape used by
    ``register_style_pack`` and ``Page.register_style_pack`` while keeping
    everything strongly typed in Python wrappers.

    Typical use:
    1. Build the pack with tokens/overrides/components/effects.
    2. Call ``register()`` globally or against a ``Page`` instance.
    3. Set ``page.style_pack`` (or ``page.set_style_pack(...)``) to activate it.
    """

    name: str
    tokens: CandyTokens | Mapping[str, Any] | None = None
    base: str | None = None
    background: Any | None = None
    overrides: Mapping[str, Any] | None = None
    components: Mapping[str, Any] | None = None
    motion: Mapping[str, Any] | None = None
    effects: Mapping[str, Any] | None = None

    def to_spec(self) -> dict[str, Any]:
        """
        Return the runtime-ready style-pack dictionary without registering it.
        """

        token_payload: dict[str, Any] | None = None
        if isinstance(self.tokens, CandyTokens):
            token_payload = self.tokens.to_json()
        elif isinstance(self.tokens, Mapping):
            token_payload = dict(self.tokens)

        normalized = self.name.strip().lower().replace(" ", "_")
        spec: dict[str, Any] = {"name": normalized}
        if token_payload is not None:
            spec["tokens"] = token_payload
        if self.base:
            spec["base"] = str(self.base)
        if self.background is not None:
            spec["background"] = self.background
        if self.overrides:
            spec["overrides"] = dict(self.overrides)
        if self.components:
            spec["components"] = dict(self.components)
        if self.motion:
            spec["motion"] = dict(self.motion)
        if self.effects:
            spec["effects"] = dict(self.effects)
        return spec

    def register(self, page: Any | None = None) -> dict[str, Any]:
        """
        Register this custom style pack globally or on a specific page.

        If ``page`` is provided and exposes ``register_style_pack``, that page
        is updated immediately so the runtime receives the custom pack payload.
        """

        from ...style_packs import register_style_pack

        if page is not None and hasattr(page, "register_style_pack"):
            return page.register_style_pack(
                self.name,
                tokens=self.tokens,
                base=self.base,
                background=self.background,
                overrides=_coerce_mapping(self.overrides),
                components=_coerce_mapping(self.components),
                motion=_coerce_mapping(self.motion),
                effects=_coerce_mapping(self.effects),
            )
        return register_style_pack(
            self.name,
            tokens=self.tokens,
            base=self.base,
            background=self.background,
            overrides=_coerce_mapping(self.overrides),
            components=_coerce_mapping(self.components),
            motion=_coerce_mapping(self.motion),
            effects=_coerce_mapping(self.effects),
        )


def candy_style_pack(
    name: str,
    *,
    tokens: CandyTokens | Mapping[str, Any] | None = None,
    base: str | None = None,
    background: Any | None = None,
    overrides: Mapping[str, Any] | None = None,
    components: Mapping[str, Any] | None = None,
    motion: Mapping[str, Any] | None = None,
    effects: Mapping[str, Any] | None = None,
) -> CandyStylePack:
    """
    Convenience factory for ``CandyStylePack``.
    """

    return CandyStylePack(
        name=name,
        tokens=tokens,
        base=base,
        background=background,
        overrides=overrides,
        components=components,
        motion=motion,
        effects=effects,
    )


@dataclass
class CandyComponentSpec:
    """
    Reusable custom Candy component template.

    This helper enables authoring component blueprints from any controls
    (including customization/effects controls) and instantiating them with
    per-use prop/style/child overrides.
    """

    module: str = "container"
    props: dict[str, Any] = field(default_factory=dict)
    style: dict[str, Any] = field(default_factory=dict)
    children: list[Any] = field(default_factory=list)
    scope_tokens: dict[str, Any] | None = None
    scope_theme: dict[str, Any] | None = None
    scope_brightness: str | None = None
    strict: bool = False

    def add_children(self, *children: Any) -> "CandyComponentSpec":
        """
        Append child controls (snapshotted to JSON-compatible control maps).
        """

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
    ) -> Candy | CandyScope:
        """
        Build a ``Candy`` node from this spec with optional runtime overrides.

        ``wrap_scope`` defaults to ``True`` when scope tokens/theme/brightness
        were configured on the spec.
        """

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
    """
    Build a reusable ``CandyComponentSpec`` from controls and base props.

    ``scope_tokens``/``scope_theme`` make the component self-contained for
    tokenized styling while remaining fully overridable during instantiation.
    """

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


class CandyScope(Component):
    """
    Scope wrapper that provides Candy tokens to descendant controls.

    Place ``CandyScope`` around a subtree to define shared visual tokens and
    behavior defaults. Descendant ``Candy`` controls read these tokens at
    render time, which keeps styling consistent without repeating props.

    You can pass tokens as:
    - a ``CandyTokens`` instance
    - a ``CandyTheme`` instance
    - plain mappings via ``tokens=...`` and bucket args such as ``colors=...``

    You can also enable scope-level effect flags (for example
    ``particles=True`` or ``scanline=True``), which the runtime applies as
    wrappers around the scope child.

    Descendants inside the scope can use universal slot styling through
    ``style_slots`` / ``style={"slots": ...}`` with common slots:
    ``root``, ``background``, ``border``, ``content``, ``label``, ``icon``,
    ``leading``, ``trailing``, and ``overlay``.

    ```python
    import butterflyui as bui

    bui.CandyScope(
        bui.Text("Hello"),
        brightness="dark",
        colors={"primary": "#6366F1"},
        effects={"glassBlur": 18},
    )
    ```

    Args:
        tokens:
            Flat token map or ``CandyTokens`` instance applied to the scope.
        theme:
            Structured ``CandyTheme`` or mapping with theme category buckets.
        brightness:
            Color mode. Values: ``"light"``, ``"dark"``.
        radius:
            Radius token bucket mapping.
        colors:
            Color token bucket mapping.
        typography:
            Typography token bucket mapping.
        spacing:
            Spacing token bucket mapping.
        elevation:
            Elevation/shadow token bucket mapping.
        motion:
            Motion/animation token bucket mapping.
        button:
            Button style token bucket mapping.
        card:
            Card style token bucket mapping.
        effects:
            Effects token bucket, for example ``{"glassBlur": 18}``.
        ui:
            General UI token bucket mapping.
        webview:
            Webview-specific token overrides.
    """



    control_type = "candy_scope"

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
            ui=ui,
            webview=webview,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Candy(Component):
    """
    Umbrella Candy control that renders one module per node.

    ``Candy`` is the Python entry point for the Candy umbrella system.
    The selected ``module`` decides what the runtime builds. Common groups:
    - layout: ``row``, ``column``, ``stack``, ``wrap``, ``container``
    - interactive: ``button``, ``badge``, ``avatar``, ``icon``, ``text``
    - decoration/effects/motion: ``decorated_box``, ``effects``, ``motion``,
      ``transition``, and related modules

    Module names are normalized before serialization so aliases such as
    ``layout_primitives``, ``decorated``, ``aspectratio``, and
    ``interaction_wrappers`` map to canonical runtime module IDs.

    The constructor also applies lightweight prop bridging for common
    cross-module fields, for example:
    - ``label`` -> ``text`` for text/button-style modules
    - ``background`` -> ``bgcolor`` for ``surface``

    Unknown ``**kwargs`` are still forwarded, so new Dart-side module args
    can be used from Python without waiting for wrapper updates.

    Candy modules also participate in the shared universal pipeline:
    style -> modifiers -> motion -> effects. You can pass cross-control keys
    like ``classes``, ``modifiers``, ``on_hover_modifiers``,
    ``on_pressed_modifiers``, ``enter_motion``/``hover_motion`` and
    ``effects``/``effect_order`` directly on ``Candy(...)``.

    ```python
    import butterflyui as bui

    bui.Candy(
        bui.Text("Hello"),
        bui.Text("World"),
        module="row",
        events=["tap"],
    )
    ```

    Args:
        module:
            Name of the Flutter module to render. Also accepts ``layout``
            as an alias. Values include ``"row"``, ``"column"``,
            ``"stack"``, ``"wrap"``, ``"container"``, ``"card"``,
            ``"page"``, ``"button"``, ``"badge"``, ``"text"``,
            ``"icon"``, ``"avatar"``, and more.
        layout:
            Alias for ``module``.
        state:
            Active state name used for state-driven styling.
        states:
            List of all recognized state names for this control.
        events:
            List of event names the Flutter runtime should emit to Python.
        style:
            Optional visual style map applied by the shared control renderer.
            Common keys include ``gradient``, ``shadow``, ``radius``,
            ``border_color``, ``border_width``, ``clip_behavior``,
            ``backdrop_blur``/``backdrop_color`` (glass effect), and
            per-slot overrides under ``style={"slots": {...}}``.
        **kwargs:
            Additional module-specific props forwarded to runtime.
    """



    control_type = "candy"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
        layout: str | None = None,
        state: str | None = None,
        states: Iterable[str] | None = None,
        events: list[str] | None = None,
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
            **kwargs,
        )
        bridged = _bridge_candy_module_props(resolved_module, merged)
        super().__init__(*children, child=child, props=bridged, style=style, strict=strict)
