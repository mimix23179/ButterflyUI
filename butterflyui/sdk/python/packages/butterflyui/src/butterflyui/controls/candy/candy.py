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
    """
    Raw mapping payload stored by this helper type and forwarded to the runtime after JSON-safe normalization.
    """

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
    """
    Brightness mode associated with the scoped theme or token bundle, typically ``"light"`` or ``"dark"``.
    """
    colors: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named color tokens to the concrete color values used by the renderer.
    """
    typography: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named typography tokens to reusable text-style values such as size, weight, family, and line height.
    """
    radii: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named radius tokens to reusable corner-radius values.
    """
    spacing: dict[str, Any] = field(default_factory=dict)
    """
    Base spacing value used between items or structural regions inside the control.
    """
    elevation: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named elevation tokens to reusable shadow, blur, or surface depth settings.
    """
    motion: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named motion tokens to reusable duration, easing, or transition specifications used by animated controls.
    """
    button: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named button style tokens to reusable button appearances consumed by recipes, variants, or control defaults.
    """
    card: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of named card style tokens to reusable surface, border, and elevation settings for card-like components.
    """
    effects: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of effect tokens or effect definitions bundled with this theme, pack, or control.
    """
    ui: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of shared UI tokens used across general-purpose controls, surfaces, and layout primitives.
    """
    webview: dict[str, Any] = field(default_factory=dict)
    """
    Mapping of webview-specific tokens or settings forwarded to the runtime.
    """

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
    """
    Human-readable name used to identify this item, style pack, or preset.
    """
    tokens: CandyTokens | Mapping[str, Any] | None = None
    """
    Token mapping or token helper object that provides reusable design values to this definition.
    """
    base: str | None = None
    """
    Base style map applied in the idle state before any interactive or disabled overrides are merged.
    """
    background: Any | None = None
    """
    Background value or surface descriptor applied by the style pack when it defines a global page or shell backdrop.
    """
    overrides: Mapping[str, Any] | None = None
    """
    Override mapping merged on top of the base theme, preset, or style definition.
    """
    components: Mapping[str, Any] | None = None
    """
    Component-specific overrides or named component definitions bundled with this theme or style pack.
    """
    motion: Mapping[str, Any] | None = None
    """
    Mapping of named motion tokens to reusable duration, easing, or transition specifications used by animated controls.
    """
    effects: Mapping[str, Any] | None = None
    """
    Mapping of effect tokens or effect definitions bundled with this theme, pack, or control.
    """

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
    """
    Runtime module identifier that tells the umbrella control which Flutter-side implementation to render.
    """
    props: dict[str, Any] = field(default_factory=dict)
    """
    Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
    """
    style: dict[str, Any] = field(default_factory=dict)
    """
    Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
    """
    children: list[Any] = field(default_factory=list)
    """
    Ordered list of child payloads nested inside this reusable component spec.
    """
    scope_tokens: dict[str, Any] | None = None
    """
    Token overrides applied by the reusable component when it creates a scope wrapper for its children.
    """
    scope_theme: dict[str, Any] | None = None
    """
    Theme mapping injected into the generated ``CandyScope`` when this component spec is instantiated with scope wrapping enabled.
    """
    scope_brightness: str | None = None
    """
    Brightness override applied when this component spec wraps the instantiated control in a ``CandyScope``.
    """
    strict: bool = False
    """
    Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """

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
    """


    tokens: CandyTokens | Mapping[str, Any] | None = None
    """
    Flat token map or ``CandyTokens`` instance applied to the scope.
    """

    theme: CandyTheme | Mapping[str, Any] | None = None
    """
    Structured ``CandyTheme`` or mapping with theme category buckets.
    """

    brightness: str | None = None
    """
    Color mode. Values: ``"light"``, ``"dark"``.
    """

    radius: Mapping[str, Any] | None = None
    """
    Mapping of named radius tokens to the concrete corner-radius values used by the renderer. Use this bucket to centralize reusable radius tokens for themes, recipes, or component defaults.
    """

    colors: Mapping[str, Any] | None = None
    """
    Mapping of named color tokens to the concrete values used by the renderer. Use this bucket to centralize reusable color-related settings.
    """

    typography: Mapping[str, Any] | None = None
    """
    Mapping of named typography tokens to reusable text-style values such as size, weight, family, or line-height settings.
    """

    spacing: Mapping[str, Any] | None = None
    """
    Mapping of named spacing tokens to the gap, padding, or margin values consumed by the renderer.
    """

    elevation: Mapping[str, Any] | None = None
    """
    Mapping of named elevation/shadow tokens to the concrete values used by the renderer. Use this bucket to centralize reusable elevation/shadow-related settings.
    """

    motion: Mapping[str, Any] | None = None
    """
    Mapping of named motion/animation tokens to the concrete values used by the renderer. Use this bucket to centralize reusable motion/animation-related settings.
    """

    button: Mapping[str, Any] | None = None
    """
    Mapping of named button style tokens to the concrete values used by the renderer. Use this bucket to centralize reusable button style-related settings.
    """

    card: Mapping[str, Any] | None = None
    """
    Mapping of named card style tokens to the concrete values used by the renderer. Use this bucket to centralize reusable card style-related settings.
    """

    effects: Mapping[str, Any] | None = None
    """
    Effects token bucket, for example ``{"glassBlur": 18}``.
    """

    ui: Mapping[str, Any] | None = None
    """
    Mapping of named general ui tokens to the concrete values used by the renderer. Use this bucket to centralize reusable general ui-related settings.
    """

    webview: Mapping[str, Any] | None = None
    """
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
    """


    module: str | None = None
    """
    Name of the Flutter module to render. Also accepts ``layout``
    as an alias. Values include ``"row"``, ``"column"``,
    ``"stack"``, ``"wrap"``, ``"container"``, ``"card"``,
    ``"page"``, ``"button"``, ``"badge"``, ``"text"``,
    ``"icon"``, ``"avatar"``, and more.
    """

    layout: str | None = None
    """
    Backward-compatible alias for ``module``. When both fields are provided, ``module`` takes precedence and this alias is kept only for compatibility.
    """

    state: str | None = None
    """
    Active state name used for state-driven styling.
    """

    states: Iterable[str] | None = None
    """
    List of all recognized state names for this control.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
