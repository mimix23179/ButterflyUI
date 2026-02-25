from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Skins
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

Skins.selector = Selector
Skins.Selector = Selector
Skins.preset = Preset
Skins.Preset = Preset
Skins.editor = Editor
Skins.Editor = Editor
Skins.preview = Preview
Skins.Preview = Preview
Skins.apply = Apply
Skins.Apply = Apply
Skins.clear = Clear
Skins.Clear = Clear
Skins.token_mapper = TokenMapper
Skins.TokenMapper = TokenMapper
Skins.create_skin = CreateSkin
Skins.CreateSkin = CreateSkin
Skins.edit_skin = EditSkin
Skins.EditSkin = EditSkin
Skins.delete_skin = DeleteSkin
Skins.DeleteSkin = DeleteSkin
Skins.effects = Effects
Skins.Effects = Effects
Skins.particles = Particles
Skins.Particles = Particles
Skins.shaders = Shaders
Skins.Shaders = Shaders
Skins.materials = Materials
Skins.Materials = Materials
Skins.icons = Icons
Skins.Icons = Icons
Skins.fonts = Fonts
Skins.Fonts = Fonts
Skins.colors = Colors
Skins.Colors = Colors
Skins.background = Background
Skins.Background = Background
Skins.border = Border
Skins.Border = Border
Skins.shadow = Shadow
Skins.Shadow = Shadow
Skins.outline = Outline
Skins.Outline = Outline
Skins.animation = Animation
Skins.Animation = Animation
Skins.transition = Transition
Skins.Transition = Transition
Skins.interaction = Interaction
Skins.Interaction = Interaction
Skins.layout = Layout
Skins.Layout = Layout
Skins.responsive = Responsive
Skins.Responsive = Responsive
Skins.effect_editor = EffectEditor
Skins.EffectEditor = EffectEditor
Skins.particle_editor = ParticleEditor
Skins.ParticleEditor = ParticleEditor
Skins.shader_editor = ShaderEditor
Skins.ShaderEditor = ShaderEditor
Skins.material_editor = MaterialEditor
Skins.MaterialEditor = MaterialEditor
Skins.icon_editor = IconEditor
Skins.IconEditor = IconEditor
Skins.font_editor = FontEditor
Skins.FontEditor = FontEditor
Skins.color_editor = ColorEditor
Skins.ColorEditor = ColorEditor
Skins.background_editor = BackgroundEditor
Skins.BackgroundEditor = BackgroundEditor
Skins.border_editor = BorderEditor
Skins.BorderEditor = BorderEditor
Skins.shadow_editor = ShadowEditor
Skins.ShadowEditor = ShadowEditor
Skins.outline_editor = OutlineEditor
Skins.OutlineEditor = OutlineEditor

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
