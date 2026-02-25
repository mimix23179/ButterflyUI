from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Candy, CandySchemaError, CandyTheme
from .submodules import (
    Align,
    Animation,
    AspectRatio,
    Avatar,
    Badge,
    Border,
    Button,
    Canvas,
    Card,
    Center,
    Clip,
    Column,
    Container,
    DecoratedBox,
    Effects,
    FittedBox,
    Gradient,
    Icon,
    Motion,
    Outline,
    OverflowBox,
    Particles,
    Row,
    Shadow,
    Spacer,
    Stack,
    Surface,
    Text,
    Transition,
    Wrap,
)
from .schema import (
    EVENTS,
    MODULES,
    REGISTRY_MANIFEST_LISTS,
    REGISTRY_ROLE_ALIASES,
    SCHEMA_VERSION,
    STATES,
)

Candy.align: type[Align] = Align
Candy.Align: type[Align] = Align
Candy.animation: type[Animation] = Animation
Candy.Animation: type[Animation] = Animation
Candy.aspect_ratio: type[AspectRatio] = AspectRatio
Candy.AspectRatio: type[AspectRatio] = AspectRatio
Candy.avatar: type[Avatar] = Avatar
Candy.Avatar: type[Avatar] = Avatar
Candy.badge: type[Badge] = Badge
Candy.Badge: type[Badge] = Badge
Candy.border: type[Border] = Border
Candy.Border: type[Border] = Border
Candy.button: type[Button] = Button
Candy.Button: type[Button] = Button
Candy.canvas: type[Canvas] = Canvas
Candy.Canvas: type[Canvas] = Canvas
Candy.card: type[Card] = Card
Candy.Card: type[Card] = Card
Candy.center: type[Center] = Center
Candy.Center: type[Center] = Center
Candy.clip: type[Clip] = Clip
Candy.Clip: type[Clip] = Clip
Candy.column: type[Column] = Column
Candy.Column: type[Column] = Column
Candy.container: type[Container] = Container
Candy.Container: type[Container] = Container
Candy.decorated_box: type[DecoratedBox] = DecoratedBox
Candy.DecoratedBox: type[DecoratedBox] = DecoratedBox
Candy.effects: type[Effects] = Effects
Candy.Effects: type[Effects] = Effects
Candy.fitted_box: type[FittedBox] = FittedBox
Candy.FittedBox: type[FittedBox] = FittedBox
Candy.gradient: type[Gradient] = Gradient
Candy.Gradient: type[Gradient] = Gradient
Candy.icon: type[Icon] = Icon
Candy.Icon: type[Icon] = Icon
Candy.motion: type[Motion] = Motion
Candy.Motion: type[Motion] = Motion
Candy.outline: type[Outline] = Outline
Candy.Outline: type[Outline] = Outline
Candy.overflow_box: type[OverflowBox] = OverflowBox
Candy.OverflowBox: type[OverflowBox] = OverflowBox
Candy.particles: type[Particles] = Particles
Candy.Particles: type[Particles] = Particles
Candy.row: type[Row] = Row
Candy.Row: type[Row] = Row
Candy.shadow: type[Shadow] = Shadow
Candy.Shadow: type[Shadow] = Shadow
Candy.spacer: type[Spacer] = Spacer
Candy.Spacer: type[Spacer] = Spacer
Candy.stack: type[Stack] = Stack
Candy.Stack: type[Stack] = Stack
Candy.surface: type[Surface] = Surface
Candy.Surface: type[Surface] = Surface
Candy.text: type[Text] = Text
Candy.Text: type[Text] = Text
Candy.transition: type[Transition] = Transition
Candy.Transition: type[Transition] = Transition
Candy.wrap: type[Wrap] = Wrap
Candy.Wrap: type[Wrap] = Wrap

__all__ = [
    "CandySchemaError",
    "CandyTheme",
    "Candy",
    "SCHEMA_VERSION",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
    "MODULE_COMPONENTS",
    "Align",
    "Animation",
    "AspectRatio",
    "Avatar",
    "Badge",
    "Border",
    "Button",
    "Canvas",
    "Card",
    "Center",
    "Clip",
    "Column",
    "Container",
    "DecoratedBox",
    "Effects",
    "FittedBox",
    "Gradient",
    "Icon",
    "Motion",
    "Outline",
    "OverflowBox",
    "Particles",
    "Row",
    "Shadow",
    "Spacer",
    "Stack",
    "Surface",
    "Text",
    "Transition",
    "Wrap",
]
