from __future__ import annotations

from .builder import Builder
from .canvas import Canvas
from .canvas_surface import CanvasSurface
from .timeline_surface import TimelineSurface
from .node_surface import NodeSurface
from .preview_surface import PreviewSurface
from .block_palette import BlockPalette
from .component_palette import ComponentPalette
from .inspector import Inspector
from .outline_tree import OutlineTree
from .project_panel import ProjectPanel
from .properties_panel import PropertiesPanel
from .responsive_toolbar import ResponsiveToolbar
from .tokens_editor import TokensEditor
from .actions_editor import ActionsEditor
from .bindings_editor import BindingsEditor
from .asset_browser import AssetBrowser
from .selection_tools import SelectionTools
from .transform_box import TransformBox
from .transform_toolbar import TransformToolbar
from .assets import Assets
from .assets_panel import AssetsPanel
from .layers import Layers
from .layers_panel import LayersPanel
from .node import Node
from .node_graph import NodeGraph
from .preview import Preview
from .properties import Properties
from .responsive import Responsive
from .timeline import Timeline
from .timeline_editor import TimelineEditor
from .token_editor import TokenEditor
from .tokens import Tokens
from .toolbox import Toolbox
from .transform import Transform
from .transform_tools import TransformTools

MODULE_COMPONENTS = {
    'builder': Builder,
    'canvas': Canvas,
    'canvas_surface': CanvasSurface,
    'timeline_surface': TimelineSurface,
    'node_surface': NodeSurface,
    'preview_surface': PreviewSurface,
    'block_palette': BlockPalette,
    'component_palette': ComponentPalette,
    'inspector': Inspector,
    'outline_tree': OutlineTree,
    'project_panel': ProjectPanel,
    'properties_panel': PropertiesPanel,
    'responsive_toolbar': ResponsiveToolbar,
    'tokens_editor': TokensEditor,
    'actions_editor': ActionsEditor,
    'bindings_editor': BindingsEditor,
    'asset_browser': AssetBrowser,
    'selection_tools': SelectionTools,
    'transform_box': TransformBox,
    'transform_toolbar': TransformToolbar,
    'assets': Assets,
    'assets_panel': AssetsPanel,
    'layers': Layers,
    'layers_panel': LayersPanel,
    'node': Node,
    'node_graph': NodeGraph,
    'preview': Preview,
    'properties': Properties,
    'responsive': Responsive,
    'timeline': Timeline,
    'timeline_editor': TimelineEditor,
    'token_editor': TokenEditor,
    'tokens': Tokens,
    'toolbox': Toolbox,
    'transform': Transform,
    'transform_tools': TransformTools,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    'MODULE_COMPONENTS',
    'Builder',
    'Canvas',
    'CanvasSurface',
    'TimelineSurface',
    'NodeSurface',
    'PreviewSurface',
    'BlockPalette',
    'ComponentPalette',
    'Inspector',
    'OutlineTree',
    'ProjectPanel',
    'PropertiesPanel',
    'ResponsiveToolbar',
    'TokensEditor',
    'ActionsEditor',
    'BindingsEditor',
    'AssetBrowser',
    'SelectionTools',
    'TransformBox',
    'TransformToolbar',
    'Assets',
    'AssetsPanel',
    'Layers',
    'LayersPanel',
    'Node',
    'NodeGraph',
    'Preview',
    'Properties',
    'Responsive',
    'Timeline',
    'TimelineEditor',
    'TokenEditor',
    'Tokens',
    'Toolbox',
    'Transform',
    'TransformTools',
]
