from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Candy", "CandyScope", "CandyTheme", "CandyTokens"]


@dataclass
class CandyTokens:
    """
    Flat design-token store passed to ``CandyScope`` or ``CandyTheme``.

    ``data`` holds raw key-value token pairs. Use ``from_dict`` to create
    an instance from an existing mapping, and ``to_json`` to serialise back
    to a plain dict for transmission to Flutter.

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
    Structured design theme mapping semantic token categories to runtime values.

    Groups design decisions into named buckets — ``colors``, ``typography``,
    ``radii``, ``spacing``, ``elevation``, ``motion``, ``button``, ``card``,
    ``effects``, ``ui``, and ``webview`` — that ``CandyScope`` applies to
    its child subtree. ``brightness`` controls light/dark mode.

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


class CandyScope(Component):
    """
    Theme-scope wrapper that injects Candy design tokens and optional visual effects.

    The runtime builds a ``CandyTokens`` context from token inputs and
    exposes it to all descendant controls via an ``InheritedWidget``.
    Token categories can be supplied individually (``colors``,
    ``typography``, ``radius``, *etc.*) or as a pre-built ``CandyTokens``
    or ``CandyTheme`` object.

    Optional effect flags add overlay effects to the scope's child without
    extra widget wrappers. Pass any of the following as keyword arguments:
    ``particles=True``, ``scanline=True``, ``shimmer=True``,
    ``vignette=True``, ``glow=True``, ``animated_background=True``,
    ``liquid_morph=True``, or ``parallax=True``.

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
            Effects token bucket (e.g. ``{"glassBlur": 18}``).
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
    Theme-aware compositor that renders a named layout or widget module.

    The Flutter runtime dispatches to one of many named module builders
    based on the ``module`` prop. Layout modules: ``"row"``, ``"column"``,
    ``"stack"``, ``"wrap"``, ``"container"`` / ``"surface"``, ``"align"``,
    ``"center"``, ``"spacer"``, ``"aspect_ratio"``, ``"fitted_box"``,
    ``"overflow_box"``, ``"card"``, ``"page"``. Interactive modules:
    ``"button"``, ``"badge"``, ``"avatar"``, ``"icon"``, ``"text"``.
    Additional decoration, effects, and motion modules are supported.
    All modules inherit ambient ``CandyScope`` tokens automatically.

    ``state`` and ``states`` enable state-machine-driven styling.

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
            List of all recognised state names for this control.
        events:
            List of event names the Flutter runtime should emit to Python.
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
        merged = merge_props(
            props,
            module=module if module is not None else layout,
            layout=layout,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)
