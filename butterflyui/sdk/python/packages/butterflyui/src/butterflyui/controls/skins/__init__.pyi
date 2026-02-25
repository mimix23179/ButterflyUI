from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Skins as _Skins
from .submodules import (
    Selector,
    Preset,
    Editor,
    Preview,
    Apply,
    Clear,
    TokenMapper,
    CreateSkin,
    EditSkin,
    DeleteSkin,
    Effects,
    Particles,
    Shaders,
    Materials,
    Icons,
    Fonts,
    Colors,
    Background,
    Border,
    Shadow,
    Outline,
    Animation,
    Transition,
    Interaction,
    Layout,
    Responsive,
    EffectEditor,
    ParticleEditor,
    ShaderEditor,
    MaterialEditor,
    IconEditor,
    FontEditor,
    ColorEditor,
    BackgroundEditor,
    BorderEditor,
    ShadowEditor,
    OutlineEditor,
)
from .schema import (
    SCHEMA_VERSION,
    MODULES,
    STATES,
    EVENTS,
    REGISTRY_ROLE_ALIASES,
    REGISTRY_MANIFEST_LISTS,
    DEFAULT_NAMES,
    DEFAULT_PRESETS,
)

class Skins(_Skins):
    selector: type[Selector]
    Selector: type[Selector]
    preset: type[Preset]
    Preset: type[Preset]
    editor: type[Editor]
    Editor: type[Editor]
    preview: type[Preview]
    Preview: type[Preview]
    apply: type[Apply]
    Apply: type[Apply]
    clear: type[Clear]
    Clear: type[Clear]
    token_mapper: type[TokenMapper]
    TokenMapper: type[TokenMapper]
    create_skin: type[CreateSkin]
    CreateSkin: type[CreateSkin]
    edit_skin: type[EditSkin]
    EditSkin: type[EditSkin]
    delete_skin: type[DeleteSkin]
    DeleteSkin: type[DeleteSkin]
    effects: type[Effects]
    Effects: type[Effects]
    particles: type[Particles]
    Particles: type[Particles]
    shaders: type[Shaders]
    Shaders: type[Shaders]
    materials: type[Materials]
    Materials: type[Materials]
    icons: type[Icons]
    Icons: type[Icons]
    fonts: type[Fonts]
    Fonts: type[Fonts]
    colors: type[Colors]
    Colors: type[Colors]
    background: type[Background]
    Background: type[Background]
    border: type[Border]
    Border: type[Border]
    shadow: type[Shadow]
    Shadow: type[Shadow]
    outline: type[Outline]
    Outline: type[Outline]
    animation: type[Animation]
    Animation: type[Animation]
    transition: type[Transition]
    Transition: type[Transition]
    interaction: type[Interaction]
    Interaction: type[Interaction]
    layout: type[Layout]
    Layout: type[Layout]
    responsive: type[Responsive]
    Responsive: type[Responsive]
    effect_editor: type[EffectEditor]
    EffectEditor: type[EffectEditor]
    particle_editor: type[ParticleEditor]
    ParticleEditor: type[ParticleEditor]
    shader_editor: type[ShaderEditor]
    ShaderEditor: type[ShaderEditor]
    material_editor: type[MaterialEditor]
    MaterialEditor: type[MaterialEditor]
    icon_editor: type[IconEditor]
    IconEditor: type[IconEditor]
    font_editor: type[FontEditor]
    FontEditor: type[FontEditor]
    color_editor: type[ColorEditor]
    ColorEditor: type[ColorEditor]
    background_editor: type[BackgroundEditor]
    BackgroundEditor: type[BackgroundEditor]
    border_editor: type[BorderEditor]
    BorderEditor: type[BorderEditor]
    shadow_editor: type[ShadowEditor]
    ShadowEditor: type[ShadowEditor]
    outline_editor: type[OutlineEditor]
    OutlineEditor: type[OutlineEditor]

__all__ = [
    "Skins",
    "SCHEMA_VERSION",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
    "DEFAULT_NAMES",
    "DEFAULT_PRESETS",
    "MODULE_COMPONENTS",
    "Selector",
    "Preset",
    "Editor",
    "Preview",
    "Apply",
    "Clear",
    "TokenMapper",
    "CreateSkin",
    "EditSkin",
    "DeleteSkin",
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
]
