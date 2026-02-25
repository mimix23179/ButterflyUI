from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Candy as _Candy, CandySchemaError, CandyTheme
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

class Candy(_Candy):
    align: type[Align]
    Align: type[Align]
    animation: type[Animation]
    Animation: type[Animation]
    aspect_ratio: type[AspectRatio]
    AspectRatio: type[AspectRatio]
    avatar: type[Avatar]
    Avatar: type[Avatar]
    badge: type[Badge]
    Badge: type[Badge]
    border: type[Border]
    Border: type[Border]
    button: type[Button]
    Button: type[Button]
    canvas: type[Canvas]
    Canvas: type[Canvas]
    card: type[Card]
    Card: type[Card]
    center: type[Center]
    Center: type[Center]
    clip: type[Clip]
    Clip: type[Clip]
    column: type[Column]
    Column: type[Column]
    container: type[Container]
    Container: type[Container]
    decorated_box: type[DecoratedBox]
    DecoratedBox: type[DecoratedBox]
    effects: type[Effects]
    Effects: type[Effects]
    fitted_box: type[FittedBox]
    FittedBox: type[FittedBox]
    gradient: type[Gradient]
    Gradient: type[Gradient]
    icon: type[Icon]
    Icon: type[Icon]
    motion: type[Motion]
    Motion: type[Motion]
    outline: type[Outline]
    Outline: type[Outline]
    overflow_box: type[OverflowBox]
    OverflowBox: type[OverflowBox]
    particles: type[Particles]
    Particles: type[Particles]
    row: type[Row]
    Row: type[Row]
    shadow: type[Shadow]
    Shadow: type[Shadow]
    spacer: type[Spacer]
    Spacer: type[Spacer]
    stack: type[Stack]
    Stack: type[Stack]
    surface: type[Surface]
    Surface: type[Surface]
    text: type[Text]
    Text: type[Text]
    transition: type[Transition]
    Transition: type[Transition]
    wrap: type[Wrap]
    Wrap: type[Wrap]

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
