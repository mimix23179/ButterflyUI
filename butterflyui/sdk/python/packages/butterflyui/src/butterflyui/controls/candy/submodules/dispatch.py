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

# ── Category component maps ────────────────────────────────────────────────────

LAYOUT_COMPONENTS: dict[str, type] = {
    "align": Align,
    "aspect_ratio": AspectRatio,
    "card": Card,
    "center": Center,
    "column": Column,
    "container": Container,
    "fitted_box": FittedBox,
    "overflow_box": OverflowBox,
    "row": Row,
    "spacer": Spacer,
    "stack": Stack,
    "surface": Surface,
    "wrap": Wrap,
}

INTERACTIVE_COMPONENTS: dict[str, type] = {
    "avatar": Avatar,
    "badge": Badge,
    "button": Button,
    "icon": Icon,
    "text": Text,
}

DECORATION_COMPONENTS: dict[str, type] = {
    "border": Border,
    "clip": Clip,
    "decorated_box": DecoratedBox,
    "gradient": Gradient,
    "outline": Outline,
    "shadow": Shadow,
}

EFFECTS_COMPONENTS: dict[str, type] = {
    "canvas": Canvas,
    "effects": Effects,
    "particles": Particles,
}

MOTION_COMPONENTS: dict[str, type] = {
    "animation": Animation,
    "motion": Motion,
    "transition": Transition,
}

MODULE_COMPONENTS: dict[str, type] = {
    **LAYOUT_COMPONENTS,
    **INTERACTIVE_COMPONENTS,
    **DECORATION_COMPONENTS,
    **EFFECTS_COMPONENTS,
    **MOTION_COMPONENTS,
}

CATEGORY_COMPONENTS: dict[str, dict[str, type]] = {
    "layout": LAYOUT_COMPONENTS,
    "interactive": INTERACTIVE_COMPONENTS,
    "decoration": DECORATION_COMPONENTS,
    "effects": EFFECTS_COMPONENTS,
    "motion": MOTION_COMPONENTS,
}

MODULE_CATEGORY: dict[str, str] = {
    **{m: "layout" for m in LAYOUT_COMPONENTS},
    **{m: "interactive" for m in INTERACTIVE_COMPONENTS},
    **{m: "decoration" for m in DECORATION_COMPONENTS},
    **{m: "effects" for m in EFFECTS_COMPONENTS},
    **{m: "motion" for m in MOTION_COMPONENTS},
}

# ── Dispatch helpers ───────────────────────────────────────────────────────────

def _norm(token: str) -> str:
    return token.strip().lower().replace("-", "_")


def get_candy_component(module_token: str) -> type | None:
    return MODULE_COMPONENTS.get(_norm(module_token))


def get_candy_layout_component(module_token: str) -> type | None:
    return LAYOUT_COMPONENTS.get(_norm(module_token))


def get_candy_interactive_component(module_token: str) -> type | None:
    return INTERACTIVE_COMPONENTS.get(_norm(module_token))


def get_candy_decoration_component(module_token: str) -> type | None:
    return DECORATION_COMPONENTS.get(_norm(module_token))


def get_candy_effects_component(module_token: str) -> type | None:
    return EFFECTS_COMPONENTS.get(_norm(module_token))


def get_candy_motion_component(module_token: str) -> type | None:
    return MOTION_COMPONENTS.get(_norm(module_token))


def get_candy_category_components(category: str) -> dict[str, type]:
    return dict(CATEGORY_COMPONENTS.get(_norm(category), {}))


def get_candy_module_category(module_token: str) -> str | None:
    return MODULE_CATEGORY.get(_norm(module_token))


__all__ = [
    "LAYOUT_COMPONENTS",
    "INTERACTIVE_COMPONENTS",
    "DECORATION_COMPONENTS",
    "EFFECTS_COMPONENTS",
    "MOTION_COMPONENTS",
    "MODULE_COMPONENTS",
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
