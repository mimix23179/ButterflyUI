"""
Skins Control - Allows users to create custom skins for their programs.

Skins is a control that uses various existing components from ButterflyUI
to let users build their own skins for their programs. Users can create
different themed skins like shadow, fire, earth, gaming, etc.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Optional, Iterable, Mapping

from ...core import Control


@dataclass
class SkinsTokens:
    """Tokens configuration for a skin."""
    background: str = "#FAFAFA"
    surface: str = "#F5F5F5"
    surface_alt: str = "#EEEEEE"
    text: str = "#1A1A1A"
    muted_text: str = "#666666"
    border: str = "#E0E0E0"
    primary: str = "#6366F1"
    secondary: str = "#8B5CF6"
    success: str = "#22C55E"
    warning: str = "#F59E0B"
    info: str = "#3B82F6"
    error: str = "#EF4444"
    radius_sm: float = 6
    radius_md: float = 12
    radius_lg: float = 18
    spacing_xs: float = 4
    spacing_sm: float = 8
    spacing_md: float = 12
    spacing_lg: float = 20
    glass_blur: float = 18
    
    def to_dict(self) -> dict[str, Any]:
        return {
            "background": self.background,
            "surface": self.surface,
            "surfaceAlt": self.surface_alt,
            "text": self.text,
            "mutedText": self.muted_text,
            "border": self.border,
            "primary": self.primary,
            "secondary": self.secondary,
            "success": self.success,
            "warning": self.warning,
            "info": self.info,
            "error": self.error,
            "radius": {
                "sm": self.radius_sm,
                "md": self.radius_md,
                "lg": self.radius_lg,
            },
            "spacing": {
                "xs": self.spacing_xs,
                "sm": self.spacing_sm,
                "md": self.spacing_md,
                "lg": self.spacing_lg,
            },
            "effects": {
                "glassBlur": self.glass_blur,
            },
        }


# Predefined skin presets
class SkinsPresets:
    """Predefined skin presets."""
    
    @staticmethod
    def default() -> SkinsTokens:
        """Default skin preset."""
        return SkinsTokens()
    
    @staticmethod
    def shadow() -> SkinsTokens:
        """Shadow skin preset - dark theme with purple accents."""
        return SkinsTokens(
            background="#1A1A2E",
            surface="#16213E",
            surface_alt="#0F3460",
            text="#EAEAEA",
            muted_text="#A0A0A0",
            border="#2D2D44",
            primary="#7B68EE",
            secondary="#9370DB",
            radius_sm=8,
            radius_md=16,
            radius_lg=24,
            spacing_xs=4,
            spacing_sm=8,
            spacing_md=16,
            spacing_lg=24,
            glass_blur=20,
        )
    
    @staticmethod
    def fire() -> SkinsTokens:
        """Fire skin preset - warm red/orange theme."""
        return SkinsTokens(
            background="#1A0A0A",
            surface="#2D1515",
            surface_alt="#4A1C1C",
            text="#FFE4D6",
            muted_text="#CC9988",
            border="#5C2020",
            primary="#FF4500",
            secondary="#FF6347",
            radius_sm=4,
            radius_md=8,
            radius_lg=16,
            spacing_xs=2,
            spacing_sm=6,
            spacing_md=10,
            spacing_lg=18,
            glass_blur=10,
        )
    
    @staticmethod
    def earth() -> SkinsTokens:
        """Earth skin preset - natural brown/green theme."""
        return SkinsTokens(
            background="#1A1A14",
            surface="#2D2D1F",
            surface_alt="#3D3D2A",
            text="#E8E4D6",
            muted_text="#A8A490",
            border="#4A4A35",
            primary="#8B7355",
            secondary="#A0826D",
            radius_sm=2,
            radius_md=6,
            radius_lg=12,
            spacing_xs=4,
            spacing_sm=8,
            spacing_md=12,
            spacing_lg=20,
            glass_blur=15,
        )
    
    @staticmethod
    def gaming() -> SkinsTokens:
        """Gaming skin preset - cyber/neon green theme."""
        return SkinsTokens(
            background="#0D0D1A",
            surface="#151525",
            surface_alt="#1E1E30",
            text="#00FF88",
            muted_text="#00AA55",
            border="#2A2A40",
            primary="#00FF88",
            secondary="#00DDFF",
            radius_sm=2,
            radius_md=4,
            radius_lg=8,
            spacing_xs=2,
            spacing_sm=4,
            spacing_md=8,
            spacing_lg=16,
            glass_blur=25,
        )


@dataclass
class SkinsScope(Control):
    """
    SkinsScope is a wrapper control that applies a custom skin to its children.
    
    Use this to apply a predefined or custom skin to a section of your UI.
    
    Example:
        SkinsScope(
            skin="shadow",
            children=[...],
        )
    """
    control_type: str = "skins_scope"
    
    # Skin configuration
    skin: str = "default"  # Preset name: "default", "shadow", "fire", "earth", "gaming"
    tokens: Optional[SkinsTokens] = None  # Custom tokens
    brightness: str = "light"  # "light" or "dark"
    
    # Children
    children: list[Control] = field(default_factory=list)

    def __init__(
        self,
        *children: Control,
        skin: str = "default",
        tokens: Optional[SkinsTokens] = None,
        brightness: str = "light",
        children_list: Optional[Iterable[Control]] = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        self.skin = skin
        self.tokens = tokens
        self.brightness = brightness

        merged_children = list(children)
        if children_list is not None:
            merged_children.extend(list(children_list))

        super().__init__(
            self.control_type,
            props=props,
            children=merged_children,
            style=style,
            strict=strict,
            **kwargs,
        )
        self.__post_init__()
    
    def __post_init__(self):
        # Convert tokens to dict if provided
        tokens_dict = None
        if self.tokens is not None:
            tokens_dict = self.tokens.to_dict()
        
        self.props["skin"] = self.skin
        if tokens_dict is not None:
            self.props["tokens"] = tokens_dict
        self.props["brightness"] = self.brightness
    
    def to_dict(self) -> dict[str, Any]:
        result = super().to_dict()
        # Add children
        if self.children:
            result["children"] = [child.to_dict() for child in self.children]
        return result


@dataclass
class Skins(Control):
    """
    Skins is a control that allows users to build custom UI components
    using various layout, decoration, effects, and motion modules.
    
    This is similar to Candy but focused on creating custom skin themes
    for applications.
    
    Example:
        Skins(
            module="row",
            main="center",
            cross="center",
            children=[...],
        )
    """
    control_type: str = "skins"
    
    # Module type - determines what kind of component to build
    # Layout: row, column, stack, wrap, align, container, card, button, badge, border
    # Decoration: gradient, decorated, clip
    # Effects: effects, particles, canvas
    # Motion: animation, motion, transition
    module: str = "container"
    
    # Layout properties
    main: Optional[str] = None  # Main axis alignment
    cross: Optional[str] = None  # Cross axis alignment
    size: Optional[str] = None  # Main axis size
    direction: Optional[str] = None  # Direction for wrap
    alignment: Optional[str] = None  # Alignment for align control
    width: Optional[float] = None  # Width factor for align
    height: Optional[float] = None  # Height factor for align
    fit: Optional[str] = None  # Stack fit
    spacing: Optional[float] = None  # Wrap spacing
    run_spacing: Optional[float] = None  # Wrap run spacing
    
    # Decoration properties
    padding: Optional[Any] = None
    margin: Optional[Any] = None
    radius: Optional[float] = None
    gradient: Optional[Any] = None
    bgcolor: Optional[str] = None
    background: Optional[str] = None
    shadow: Optional[Any] = None
    border: Optional[Any] = None
    shape: Optional[str] = None
    color: Optional[str] = None
    elevation: Optional[float] = None
    shadow_color: Optional[str] = None
    
    # Effects properties
    shimmer: Optional[bool] = None
    overlay: Optional[bool] = None
    
    # Motion properties
    duration_ms: Optional[int] = None
    curve: Optional[str] = None
    preset: Optional[str] = None
    
    # Children
    children: list[Control] = field(default_factory=list)

    def __init__(
        self,
        *children: Control,
        module: str = "container",
        main: Optional[str] = None,
        cross: Optional[str] = None,
        size: Optional[str] = None,
        direction: Optional[str] = None,
        alignment: Optional[str] = None,
        width: Optional[float] = None,
        height: Optional[float] = None,
        fit: Optional[str] = None,
        spacing: Optional[float] = None,
        run_spacing: Optional[float] = None,
        padding: Optional[Any] = None,
        margin: Optional[Any] = None,
        radius: Optional[float] = None,
        gradient: Optional[Any] = None,
        bgcolor: Optional[str] = None,
        background: Optional[str] = None,
        shadow: Optional[Any] = None,
        border: Optional[Any] = None,
        shape: Optional[str] = None,
        color: Optional[str] = None,
        elevation: Optional[float] = None,
        shadow_color: Optional[str] = None,
        shimmer: Optional[bool] = None,
        overlay: Optional[bool] = None,
        duration_ms: Optional[int] = None,
        curve: Optional[str] = None,
        preset: Optional[str] = None,
        children_list: Optional[Iterable[Control]] = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        self.module = module
        self.main = main
        self.cross = cross
        self.size = size
        self.direction = direction
        self.alignment = alignment
        self.width = width
        self.height = height
        self.fit = fit
        self.spacing = spacing
        self.run_spacing = run_spacing
        self.padding = padding
        self.margin = margin
        self.radius = radius
        self.gradient = gradient
        self.bgcolor = bgcolor
        self.background = background
        self.shadow = shadow
        self.border = border
        self.shape = shape
        self.color = color
        self.elevation = elevation
        self.shadow_color = shadow_color
        self.shimmer = shimmer
        self.overlay = overlay
        self.duration_ms = duration_ms
        self.curve = curve
        self.preset = preset

        merged_children = list(children)
        if children_list is not None:
            merged_children.extend(list(children_list))

        super().__init__(
            self.control_type,
            props=props,
            children=merged_children,
            style=style,
            strict=strict,
            **kwargs,
        )
        self.__post_init__()
    
    def __post_init__(self):
        # Map props
        if self.module:
            self.props["module"] = self.module
        if self.main:
            self.props["main"] = self.main
        if self.cross:
            self.props["cross"] = self.cross
        if self.size:
            self.props["size"] = self.size
        if self.direction:
            self.props["direction"] = self.direction
        if self.alignment:
            self.props["alignment"] = self.alignment
        if self.width is not None:
            self.props["width"] = self.width
        if self.height is not None:
            self.props["height"] = self.height
        if self.fit:
            self.props["fit"] = self.fit
        if self.spacing is not None:
            self.props["spacing"] = self.spacing
        if self.run_spacing is not None:
            self.props["runSpacing"] = self.run_spacing
        if self.padding is not None:
            self.props["padding"] = self.padding
        if self.margin is not None:
            self.props["margin"] = self.margin
        if self.radius is not None:
            self.props["radius"] = self.radius
        if self.gradient is not None:
            self.props["gradient"] = self.gradient
        if self.bgcolor:
            self.props["bgcolor"] = self.bgcolor
        if self.background:
            self.props["background"] = self.background
        if self.shadow is not None:
            self.props["shadow"] = self.shadow
        if self.border is not None:
            self.props["border"] = self.border
        if self.shape:
            self.props["shape"] = self.shape
        if self.color:
            self.props["color"] = self.color
        if self.elevation is not None:
            self.props["elevation"] = self.elevation
        if self.shadow_color:
            self.props["shadowColor"] = self.shadow_color
        if self.shimmer is not None:
            self.props["shimmer"] = self.shimmer
        if self.overlay is not None:
            self.props["overlay"] = self.overlay
        if self.duration_ms is not None:
            self.props["duration_ms"] = self.duration_ms
        if self.curve:
            self.props["curve"] = self.curve
        if self.preset:
            self.props["preset"] = self.preset
    
    def to_dict(self) -> dict[str, Any]:
        result = super().to_dict()
        # Add children
        if self.children:
            result["children"] = [child.to_dict() for child in self.children]
        return result


# Convenience functions for creating Skins controls

def skins_row(
    *children: Control,
    main: Optional[str] = None,
    cross: Optional[str] = None,
    size: Optional[str] = None,
) -> Skins:
    """Create a row layout with Skins styling."""
    return Skins(
        module="row",
        main=main,
        cross=cross,
        size=size,
        children=list(children),
    )


def skins_column(
    *children: Control,
    main: Optional[str] = None,
    cross: Optional[str] = None,
    size: Optional[str] = None,
) -> Skins:
    """Create a column layout with Skins styling."""
    return Skins(
        module="column",
        main=main,
        cross=cross,
        size=size,
        children=list(children),
    )


def skins_container(
    *children: Control,
    padding: Optional[Any] = None,
    margin: Optional[Any] = None,
    radius: Optional[float] = None,
    bgcolor: Optional[str] = None,
    gradient: Optional[Any] = None,
    border: Optional[Any] = None,
) -> Skins:
    """Create a container with Skins styling."""
    return Skins(
        module="container",
        padding=padding,
        margin=margin,
        radius=radius,
        bgcolor=bgcolor,
        gradient=gradient,
        border=border,
        children=list(children),
    )


def skins_card(
    *children: Control,
    elevation: Optional[float] = None,
    color: Optional[str] = None,
    radius: Optional[float] = None,
) -> Skins:
    """Create a card with Skins styling."""
    return Skins(
        module="card",
        elevation=elevation,
        color=color,
        radius=radius,
        children=list(children),
    )


def skins_transition(
    *children: Control,
    duration_ms: Optional[int] = 220,
    curve: Optional[str] = "ease",
    preset: Optional[str] = "fade",
) -> Skins:
    """Create a transition with Skins styling."""
    return Skins(
        module="transition",
        duration_ms=duration_ms,
        curve=curve,
        preset=preset,
        children=list(children),
    )
