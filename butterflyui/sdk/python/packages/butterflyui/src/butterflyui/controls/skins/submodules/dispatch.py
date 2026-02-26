"""
Dispatch layer for the Skins umbrella control.

Maps every skins submodule string to its Python class and provides
category-based lookup helpers that mirror the Dart submodule registry.
"""
from __future__ import annotations

from typing import Optional, Type

# ---------------------------------------------------------------------------
# Individual module imports
# ---------------------------------------------------------------------------

from .selector import Selector
from .preset import Preset
from .editor import Editor
from .preview import Preview
from .token_mapper import TokenMapper
from .effects import Effects
from .particles import Particles
from .shaders import Shaders
from .materials import Materials
from .icons import Icons
from .fonts import Fonts
from .colors import Colors
from .background import Background
from .border import Border
from .shadow import Shadow
from .outline import Outline
from .animation import Animation
from .transition import Transition
from .interaction import Interaction
from .layout import Layout
from .responsive import Responsive
from .effect_editor import EffectEditor
from .particle_editor import ParticleEditor
from .shader_editor import ShaderEditor
from .material_editor import MaterialEditor
from .icon_editor import IconEditor
from .font_editor import FontEditor
from .color_editor import ColorEditor
from .background_editor import BackgroundEditor
from .border_editor import BorderEditor
from .shadow_editor import ShadowEditor
from .outline_editor import OutlineEditor
from .apply import Apply
from .clear import Clear
from .create_skin import CreateSkin
from .edit_skin import EditSkin
from .delete_skin import DeleteSkin

# ---------------------------------------------------------------------------
# Category dictionaries
# ---------------------------------------------------------------------------

CORE_COMPONENTS: dict[str, type] = {
    "selector": Selector,
    "preset": Preset,
    "editor": Editor,
    "preview": Preview,
    "token_mapper": TokenMapper,
}

TOKENS_COMPONENTS: dict[str, type] = {
    "effects": Effects,
    "particles": Particles,
    "shaders": Shaders,
    "materials": Materials,
    "icons": Icons,
    "fonts": Fonts,
    "colors": Colors,
    "background": Background,
    "border": Border,
    "shadow": Shadow,
    "outline": Outline,
    "animation": Animation,
    "transition": Transition,
    "interaction": Interaction,
    "layout": Layout,
    "responsive": Responsive,
}

EDITORS_COMPONENTS: dict[str, type] = {
    "effect_editor": EffectEditor,
    "particle_editor": ParticleEditor,
    "shader_editor": ShaderEditor,
    "material_editor": MaterialEditor,
    "icon_editor": IconEditor,
    "font_editor": FontEditor,
    "color_editor": ColorEditor,
    "background_editor": BackgroundEditor,
    "border_editor": BorderEditor,
    "shadow_editor": ShadowEditor,
    "outline_editor": OutlineEditor,
}

COMMANDS_COMPONENTS: dict[str, type] = {
    "apply": Apply,
    "clear": Clear,
    "create_skin": CreateSkin,
    "edit_skin": EditSkin,
    "delete_skin": DeleteSkin,
}

# ---------------------------------------------------------------------------
# Combined lookup tables
# ---------------------------------------------------------------------------

MODULE_COMPONENTS: dict[str, type] = {
    **CORE_COMPONENTS,
    **TOKENS_COMPONENTS,
    **EDITORS_COMPONENTS,
    **COMMANDS_COMPONENTS,
}

CATEGORY_COMPONENTS: dict[str, dict[str, type]] = {
    "core": CORE_COMPONENTS,
    "tokens": TOKENS_COMPONENTS,
    "editors": EDITORS_COMPONENTS,
    "commands": COMMANDS_COMPONENTS,
}

MODULE_CATEGORY: dict[str, str] = {
    module: category
    for category, modules in CATEGORY_COMPONENTS.items()
    for module in modules
}

# ---------------------------------------------------------------------------
# Dispatch functions
# ---------------------------------------------------------------------------


def get_skins_component(module: str) -> Optional[Type]:
    """Return the class for *module*, or ``None`` if unknown."""
    return MODULE_COMPONENTS.get(module)


def get_skins_core_component(module: str) -> Optional[Type]:
    return CORE_COMPONENTS.get(module)


def get_skins_tokens_component(module: str) -> Optional[Type]:
    return TOKENS_COMPONENTS.get(module)


def get_skins_editors_component(module: str) -> Optional[Type]:
    return EDITORS_COMPONENTS.get(module)


def get_skins_commands_component(module: str) -> Optional[Type]:
    return COMMANDS_COMPONENTS.get(module)


def get_skins_category_components(category: str) -> Optional[dict[str, type]]:
    """Return the category dict for *category*, or ``None`` if unknown."""
    return CATEGORY_COMPONENTS.get(category)


def get_skins_module_category(module: str) -> Optional[str]:
    """Return the category name for *module*, or ``None`` if unknown."""
    return MODULE_CATEGORY.get(module)


__all__ = [
    # Category dicts
    "CORE_COMPONENTS",
    "TOKENS_COMPONENTS",
    "EDITORS_COMPONENTS",
    "COMMANDS_COMPONENTS",
    # Combined
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    # Functions
    "get_skins_component",
    "get_skins_core_component",
    "get_skins_tokens_component",
    "get_skins_editors_component",
    "get_skins_commands_component",
    "get_skins_category_components",
    "get_skins_module_category",
    # Classes (re-exported for convenience)
    "Selector",
    "Preset",
    "Editor",
    "Preview",
    "TokenMapper",
    "Effects",
    "Particles",
    "Shaders",
    "Materials",
    "Icons",
    "Fonts",
    "Colors",
    "Background",
    "Border",
    "Shadow",
    "Outline",
    "Animation",
    "Transition",
    "Interaction",
    "Layout",
    "Responsive",
    "EffectEditor",
    "ParticleEditor",
    "ShaderEditor",
    "MaterialEditor",
    "IconEditor",
    "FontEditor",
    "ColorEditor",
    "BackgroundEditor",
    "BorderEditor",
    "ShadowEditor",
    "OutlineEditor",
    "Apply",
    "Clear",
    "CreateSkin",
    "EditSkin",
    "DeleteSkin",
]
