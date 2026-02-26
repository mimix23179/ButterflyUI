from __future__ import annotations

from .components import (
    CATEGORY_COMPONENTS,
    DECORATION_COMPONENTS,
    EFFECTS_COMPONENTS,
    INTERACTIVE_COMPONENTS,
    LAYOUT_COMPONENTS,
    MODULE_CATEGORY,
    MODULE_COMPONENTS,
    MOTION_COMPONENTS,
    get_candy_category_components,
    get_candy_component,
    get_candy_decoration_component,
    get_candy_effects_component,
    get_candy_interactive_component,
    get_candy_layout_component,
    get_candy_module_category,
    get_candy_motion_component,
)
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

Candy.align = Align
Candy.Align = Align
Candy.animation = Animation
Candy.Animation = Animation
Candy.aspect_ratio = AspectRatio
Candy.AspectRatio = AspectRatio
Candy.avatar = Avatar
Candy.Avatar = Avatar
Candy.badge = Badge
Candy.Badge = Badge
Candy.border = Border
Candy.Border = Border
Candy.button = Button
Candy.Button = Button
Candy.canvas = Canvas
Candy.Canvas = Canvas
Candy.card = Card
Candy.Card = Card
Candy.center = Center
Candy.Center = Center
Candy.clip = Clip
Candy.Clip = Clip
Candy.column = Column
Candy.Column = Column
Candy.container = Container
Candy.Container = Container
Candy.decorated_box = DecoratedBox
Candy.DecoratedBox = DecoratedBox
Candy.effects = Effects
Candy.Effects = Effects
Candy.fitted_box = FittedBox
Candy.FittedBox = FittedBox
Candy.gradient = Gradient
Candy.Gradient = Gradient
Candy.icon = Icon
Candy.Icon = Icon
Candy.motion = Motion
Candy.Motion = Motion
Candy.outline = Outline
Candy.Outline = Outline
Candy.overflow_box = OverflowBox
Candy.OverflowBox = OverflowBox
Candy.particles = Particles
Candy.Particles = Particles
Candy.row = Row
Candy.Row = Row
Candy.shadow = Shadow
Candy.Shadow = Shadow
Candy.spacer = Spacer
Candy.Spacer = Spacer
Candy.stack = Stack
Candy.Stack = Stack
Candy.surface = Surface
Candy.Surface = Surface
Candy.text = Text
Candy.Text = Text
Candy.transition = Transition
Candy.Transition = Transition
Candy.wrap = Wrap
Candy.Wrap = Wrap

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
    "LAYOUT_COMPONENTS",
    "INTERACTIVE_COMPONENTS",
    "DECORATION_COMPONENTS",
    "EFFECTS_COMPONENTS",
    "MOTION_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    "get_candy_component",
    "get_candy_layout_component",
    "get_candy_interactive_component",
    "get_candy_decoration_component",
    "get_candy_effects_component",
    "get_candy_motion_component",
    "get_candy_category_components",
    "get_candy_module_category",
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
