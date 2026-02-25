from __future__ import annotations

from .selector import Selector
from .preset import Preset
from .editor import Editor
from .preview import Preview
from .apply import Apply
from .clear import Clear
from .token_mapper import TokenMapper
from .create_skin import CreateSkin
from .edit_skin import EditSkin
from .delete_skin import DeleteSkin
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

MODULE_COMPONENTS = {
    'selector': Selector,
    'preset': Preset,
    'editor': Editor,
    'preview': Preview,
    'apply': Apply,
    'clear': Clear,
    'token_mapper': TokenMapper,
    'create_skin': CreateSkin,
    'edit_skin': EditSkin,
    'delete_skin': DeleteSkin,
    'effects': Effects,
    'particles': Particles,
    'shaders': Shaders,
    'materials': Materials,
    'icons': Icons,
    'fonts': Fonts,
    'colors': Colors,
    'background': Background,
    'border': Border,
    'shadow': Shadow,
    'outline': Outline,
    'animation': Animation,
    'transition': Transition,
    'interaction': Interaction,
    'layout': Layout,
    'responsive': Responsive,
    'effect_editor': EffectEditor,
    'particle_editor': ParticleEditor,
    'shader_editor': ShaderEditor,
    'material_editor': MaterialEditor,
    'icon_editor': IconEditor,
    'font_editor': FontEditor,
    'color_editor': ColorEditor,
    'background_editor': BackgroundEditor,
    'border_editor': BorderEditor,
    'shadow_editor': ShadowEditor,
    'outline_editor': OutlineEditor,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    'MODULE_COMPONENTS',
    'Selector',
    'Preset',
    'Editor',
    'Preview',
    'Apply',
    'Clear',
    'TokenMapper',
    'CreateSkin',
    'EditSkin',
    'DeleteSkin',
    'Effects',
    'Particles',
    'Shaders',
    'Materials',
    'Icons',
    'Fonts',
    'Colors',
    'Background',
    'Border',
    'Shadow',
    'Outline',
    'Animation',
    'Transition',
    'Interaction',
    'Layout',
    'Responsive',
    'EffectEditor',
    'ParticleEditor',
    'ShaderEditor',
    'MaterialEditor',
    'IconEditor',
    'FontEditor',
    'ColorEditor',
    'BackgroundEditor',
    'BorderEditor',
    'ShadowEditor',
    'OutlineEditor',
]
