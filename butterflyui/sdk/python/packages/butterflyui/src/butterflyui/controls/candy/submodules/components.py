from __future__ import annotations

from .align import Align
from .animation import Animation
from .aspect_ratio import AspectRatio
from .avatar import Avatar
from .badge import Badge
from .border import Border
from .button import Button
from .canvas import Canvas
from .card import Card
from .center import Center
from .clip import Clip
from .column import Column
from .container import Container
from .decorated_box import DecoratedBox
from .effects import Effects
from .fitted_box import FittedBox
from .gradient import Gradient
from .icon import Icon
from .motion import Motion
from .outline import Outline
from .overflow_box import OverflowBox
from .particles import Particles
from .row import Row
from .shadow import Shadow
from .spacer import Spacer
from .stack import Stack
from .surface import Surface
from .text import Text
from .transition import Transition
from .wrap import Wrap

MODULE_COMPONENTS = {
    "align": Align,
    "animation": Animation,
    "aspect_ratio": AspectRatio,
    "avatar": Avatar,
    "badge": Badge,
    "border": Border,
    "button": Button,
    "canvas": Canvas,
    "card": Card,
    "center": Center,
    "clip": Clip,
    "column": Column,
    "container": Container,
    "decorated_box": DecoratedBox,
    "effects": Effects,
    "fitted_box": FittedBox,
    "gradient": Gradient,
    "icon": Icon,
    "motion": Motion,
    "outline": Outline,
    "overflow_box": OverflowBox,
    "particles": Particles,
    "row": Row,
    "shadow": Shadow,
    "spacer": Spacer,
    "stack": Stack,
    "surface": Surface,
    "text": Text,
    "transition": Transition,
    "wrap": Wrap,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
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
