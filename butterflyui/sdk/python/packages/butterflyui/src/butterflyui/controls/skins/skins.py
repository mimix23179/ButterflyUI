from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Mapping, Iterable
from typing import Any

from .._shared import Component, merge_props

__all__ = [
    "Skins",
    "SkinsScope",
    "SkinsTokens",
    "SkinsPresets",
    "skins_row",
    "skins_column",
    "skins_container",
    "skins_card",
    "skins_transition",
]


@dataclass
class SkinsTokens:
    """
    Flat design-token store for a Skins skin, used by ``SkinsScope``.

    ``data`` holds raw key-value pairs describing colors, radii, spacing,
    and effects. Use ``from_dict`` to create from an existing mapping
    and ``to_json`` to serialise back to a plain dict.

    See ``SkinsPresets`` for ready-made named skin presets.

    ```python
    import butterflyui as bui

    tokens = bui.SkinsTokens.from_dict({
        "background": "#1A1A2E",
        "primary": "#7B68EE",
        "radius": {"sm": 8, "md": 16},
    })
    ```
    """
    data: dict[str, Any] = field(default_factory=dict)

    @staticmethod
    def from_dict(values: Mapping[str, Any]) -> "SkinsTokens":
        return SkinsTokens(dict(values))

    def to_json(self) -> dict[str, Any]:
        return dict(self.data)


class SkinsPresets:
    """
    Factory providing named built-in skin token presets.

    Each static method returns a ``SkinsTokens`` instance ready to pass
    to ``SkinsScope(tokens=...)``. Available presets:

    * ``default()`` — light neutral palette with indigo primary.
    * ``shadow()`` — deep navy dark theme with medium-blue accent.
    * ``fire()`` — dark red/orange high-contrast fire theme.
    * ``earth()`` — warm earthtone dark theme.
    * ``gaming()`` — dark neon green/cyan gaming aesthetic.

    ```python
    import butterflyui as bui

    bui.SkinsScope(
        bui.Skins(bui.Text("Gaming!"), module="card"),
        tokens=bui.SkinsPresets.gaming(),
        brightness="dark",
    )
    ```
    """
    @staticmethod
    def default() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#FAFAFA",
                "surface": "#F5F5F5",
                "surfaceAlt": "#EEEEEE",
                "text": "#1A1A1A",
                "mutedText": "#666666",
                "border": "#E0E0E0",
                "primary": "#6366F1",
                "secondary": "#8B5CF6",
                "radius": {"sm": 6, "md": 12, "lg": 18},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 18},
            }
        )

    @staticmethod
    def shadow() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A2E",
                "surface": "#16213E",
                "surfaceAlt": "#0F3460",
                "text": "#EAEAEA",
                "mutedText": "#A0A0A0",
                "border": "#2D2D44",
                "primary": "#7B68EE",
                "secondary": "#9370DB",
                "radius": {"sm": 8, "md": 16, "lg": 24},
                "spacing": {"xs": 4, "sm": 8, "md": 16, "lg": 24},
                "effects": {"glassBlur": 20},
            }
        )

    @staticmethod
    def fire() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A0A0A",
                "surface": "#2D1515",
                "surfaceAlt": "#4A1C1C",
                "text": "#FFE4D6",
                "mutedText": "#CC9988",
                "border": "#5C2020",
                "primary": "#FF4500",
                "secondary": "#FF6347",
                "radius": {"sm": 4, "md": 8, "lg": 16},
                "spacing": {"xs": 2, "sm": 6, "md": 10, "lg": 18},
                "effects": {"glassBlur": 10},
            }
        )

    @staticmethod
    def earth() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#1A1A14",
                "surface": "#2D2D1F",
                "surfaceAlt": "#3D3D2A",
                "text": "#E8E4D6",
                "mutedText": "#A8A490",
                "border": "#4A4A35",
                "primary": "#8B7355",
                "secondary": "#A0826D",
                "radius": {"sm": 2, "md": 6, "lg": 12},
                "spacing": {"xs": 4, "sm": 8, "md": 12, "lg": 20},
                "effects": {"glassBlur": 15},
            }
        )

    @staticmethod
    def gaming() -> SkinsTokens:
        return SkinsTokens(
            {
                "background": "#0D0D1A",
                "surface": "#151525",
                "surfaceAlt": "#1E1E30",
                "text": "#00FF88",
                "mutedText": "#00AA55",
                "border": "#2A2A40",
                "primary": "#00FF88",
                "secondary": "#00DDFF",
                "radius": {"sm": 2, "md": 4, "lg": 8},
                "spacing": {"xs": 2, "sm": 4, "md": 8, "lg": 16},
                "effects": {"glassBlur": 25},
            }
        )


class SkinsScope(Component):
    """
    Skin-scope wrapper that injects a named or custom skin token set.

    The runtime resolves the active ``SkinsTokens`` from either the named
    ``skin`` preset or a custom ``tokens`` mapping, then provides them to
    all descendant ``Skins`` controls via an ``InheritedWidget``.
    ``brightness`` overrides the light/dark mode of the resolved skin.

    ```python
    import butterflyui as bui

    bui.SkinsScope(
        bui.Skins(bui.Text("Styled card"), module="card"),
        skin="shadow",
        brightness="dark",
    )
    ```

    Args:
        skin:
            Named built-in skin preset. Values: ``"default"``,
            ``"shadow"``, ``"fire"``, ``"earth"``, ``"gaming"``.
        tokens:
            Custom ``SkinsTokens`` instance or raw mapping that overrides
            the preset.
        brightness:
            Color mode override. Values: ``"light"``, ``"dark"``.
    """

    control_type = "skins_scope"

    def __init__(
        self,
        *children: Any,
        skin: str | None = None,
        tokens: SkinsTokens | Mapping[str, Any] | None = None,
        brightness: str | None = None,
        child: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_tokens: Mapping[str, Any] | None = None
        if isinstance(tokens, SkinsTokens):
            resolved_tokens = tokens.to_json()
        elif tokens is not None:
            resolved_tokens = dict(tokens)
        merged = merge_props(
            props,
            skin=skin,
            tokens=resolved_tokens,
            brightness=brightness,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Skins(Component):
    """
    Skin-aware compositor that renders a named layout or decoration module.

    The Flutter runtime resolves ambient ``SkinsScope`` tokens and dispatches
    to the module named by ``module``. Layout modules: ``"row"``,
    ``"column"``, ``"stack"``, ``"wrap"``, ``"align"`` / ``"alignment"``,
    ``"container"``, ``"card"``, ``"button"`` / ``"btn"``, ``"badge"``,
    ``"border"``, ``"page"``. Decoration modules: ``"gradient"``,
    ``"decorated"``, ``"clip"``. Effects and motion modules are also
    available.

    Convenience factories ``skins_row``, ``skins_column``,
    ``skins_container``, ``skins_card``, and ``skins_transition`` pre-set
    the ``module`` prop.

    ``state`` and ``states`` enable state-machine-driven styling.

    ```python
    import butterflyui as bui

    bui.Skins(
        bui.Text("Card content"),
        module="card",
        events=["tap"],
    )
    # or using the convenience factory:
    bui.skins_card(bui.Text("Card content"), events=["tap"])
    ```

    Args:
        module:
            Name of the Flutter module to render. Values include
            ``"row"``, ``"column"``, ``"stack"``, ``"wrap"``,
            ``"container"``, ``"card"``, ``"button"``, ``"gradient"``,
            ``"clip"``, ``"page"``, and more.
        state:
            Active state name used for state-driven styling.
        states:
            List of all recognised state names for this control.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "skins"

    def __init__(
        self,
        *children: Any,
        module: str | None = None,
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
            module=module,
            state=state,
            states=list(states) if states is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


def skins_row(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="row", **kwargs)


def skins_column(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="column", **kwargs)


def skins_container(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="container", **kwargs)


def skins_card(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="card", **kwargs)


def skins_transition(*children: Any, **kwargs: Any) -> Skins:
    return Skins(*children, module="transition", **kwargs)
