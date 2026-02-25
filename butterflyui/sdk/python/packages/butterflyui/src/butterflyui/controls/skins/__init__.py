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

Skins.selector: type[Selector] = Selector
Skins.Selector: type[Selector] = Selector
Skins.preset: type[Preset] = Preset
Skins.Preset: type[Preset] = Preset
Skins.editor: type[Editor] = Editor
Skins.Editor: type[Editor] = Editor
Skins.preview: type[Preview] = Preview
Skins.Preview: type[Preview] = Preview
Skins.apply: type[Apply] = Apply
Skins.Apply: type[Apply] = Apply
Skins.clear: type[Clear] = Clear
Skins.Clear: type[Clear] = Clear
Skins.token_mapper: type[TokenMapper] = TokenMapper
Skins.TokenMapper: type[TokenMapper] = TokenMapper
Skins.create_skin: type[CreateSkin] = CreateSkin
Skins.CreateSkin: type[CreateSkin] = CreateSkin
Skins.edit_skin: type[EditSkin] = EditSkin
Skins.EditSkin: type[EditSkin] = EditSkin
Skins.delete_skin: type[DeleteSkin] = DeleteSkin
Skins.DeleteSkin: type[DeleteSkin] = DeleteSkin
Skins.effects: type[Effects] = Effects
Skins.Effects: type[Effects] = Effects
Skins.particles: type[Particles] = Particles
Skins.Particles: type[Particles] = Particles
Skins.shaders: type[Shaders] = Shaders
Skins.Shaders: type[Shaders] = Shaders
Skins.materials: type[Materials] = Materials
Skins.Materials: type[Materials] = Materials
Skins.icons: type[Icons] = Icons
Skins.Icons: type[Icons] = Icons
Skins.fonts: type[Fonts] = Fonts
Skins.Fonts: type[Fonts] = Fonts
Skins.colors: type[Colors] = Colors
Skins.Colors: type[Colors] = Colors
Skins.background: type[Background] = Background
Skins.Background: type[Background] = Background
Skins.border: type[Border] = Border
Skins.Border: type[Border] = Border
Skins.shadow: type[Shadow] = Shadow
Skins.Shadow: type[Shadow] = Shadow
Skins.outline: type[Outline] = Outline
Skins.Outline: type[Outline] = Outline
Skins.animation: type[Animation] = Animation
Skins.Animation: type[Animation] = Animation
Skins.transition: type[Transition] = Transition
Skins.Transition: type[Transition] = Transition
Skins.interaction: type[Interaction] = Interaction
Skins.Interaction: type[Interaction] = Interaction
Skins.layout: type[Layout] = Layout
Skins.Layout: type[Layout] = Layout
Skins.responsive: type[Responsive] = Responsive
Skins.Responsive: type[Responsive] = Responsive
Skins.effect_editor: type[EffectEditor] = EffectEditor
Skins.EffectEditor: type[EffectEditor] = EffectEditor
Skins.particle_editor: type[ParticleEditor] = ParticleEditor
Skins.ParticleEditor: type[ParticleEditor] = ParticleEditor
Skins.shader_editor: type[ShaderEditor] = ShaderEditor
Skins.ShaderEditor: type[ShaderEditor] = ShaderEditor
Skins.material_editor: type[MaterialEditor] = MaterialEditor
Skins.MaterialEditor: type[MaterialEditor] = MaterialEditor
Skins.icon_editor: type[IconEditor] = IconEditor
Skins.IconEditor: type[IconEditor] = IconEditor
Skins.font_editor: type[FontEditor] = FontEditor
Skins.FontEditor: type[FontEditor] = FontEditor
Skins.color_editor: type[ColorEditor] = ColorEditor
Skins.ColorEditor: type[ColorEditor] = ColorEditor
Skins.background_editor: type[BackgroundEditor] = BackgroundEditor
Skins.BackgroundEditor: type[BackgroundEditor] = BackgroundEditor
Skins.border_editor: type[BorderEditor] = BorderEditor
Skins.BorderEditor: type[BorderEditor] = BorderEditor
Skins.shadow_editor: type[ShadowEditor] = ShadowEditor
Skins.ShadowEditor: type[ShadowEditor] = ShadowEditor
Skins.outline_editor: type[OutlineEditor] = OutlineEditor
Skins.OutlineEditor: type[OutlineEditor] = OutlineEditor

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
