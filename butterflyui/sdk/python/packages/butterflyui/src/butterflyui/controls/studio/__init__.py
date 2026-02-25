from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Studio
from .submodules import (
    Builder,
    Canvas,
    CanvasSurface,
    TimelineSurface,
    NodeSurface,
    PreviewSurface,
    BlockPalette,
    ComponentPalette,
    Inspector,
    OutlineTree,
    ProjectPanel,
    PropertiesPanel,
    ResponsiveToolbar,
    TokensEditor,
    ActionsEditor,
    BindingsEditor,
    AssetBrowser,
    SelectionTools,
    TransformBox,
    TransformToolbar,
    Assets,
    AssetsPanel,
    Layers,
    LayersPanel,
    Node,
    NodeGraph,
    Preview,
    Properties,
    Responsive,
    Timeline,
    TimelineEditor,
    TokenEditor,
    Tokens,
    Toolbox,
    Transform,
    TransformTools,
)
from .schema import (
    SCHEMA_VERSION,
    MODULES,
    STATES,
    EVENTS,
    REGISTRY_ROLE_ALIASES,
    REGISTRY_MANIFEST_LISTS,
)

Studio.builder = Builder
Studio.Builder = Builder
Studio.canvas = Canvas
Studio.Canvas = Canvas
Studio.canvas_surface = CanvasSurface
Studio.CanvasSurface = CanvasSurface
Studio.timeline_surface = TimelineSurface
Studio.TimelineSurface = TimelineSurface
Studio.node_surface = NodeSurface
Studio.NodeSurface = NodeSurface
Studio.preview_surface = PreviewSurface
Studio.PreviewSurface = PreviewSurface
Studio.block_palette = BlockPalette
Studio.BlockPalette = BlockPalette
Studio.component_palette = ComponentPalette
Studio.ComponentPalette = ComponentPalette
Studio.inspector = Inspector
Studio.Inspector = Inspector
Studio.outline_tree = OutlineTree
Studio.OutlineTree = OutlineTree
Studio.project_panel = ProjectPanel
Studio.ProjectPanel = ProjectPanel
Studio.properties_panel = PropertiesPanel
Studio.PropertiesPanel = PropertiesPanel
Studio.responsive_toolbar = ResponsiveToolbar
Studio.ResponsiveToolbar = ResponsiveToolbar
Studio.tokens_editor = TokensEditor
Studio.TokensEditor = TokensEditor
Studio.actions_editor = ActionsEditor
Studio.ActionsEditor = ActionsEditor
Studio.bindings_editor = BindingsEditor
Studio.BindingsEditor = BindingsEditor
Studio.asset_browser = AssetBrowser
Studio.AssetBrowser = AssetBrowser
Studio.selection_tools = SelectionTools
Studio.SelectionTools = SelectionTools
Studio.transform_box = TransformBox
Studio.TransformBox = TransformBox
Studio.transform_toolbar = TransformToolbar
Studio.TransformToolbar = TransformToolbar
Studio.assets = Assets
Studio.Assets = Assets
Studio.assets_panel = AssetsPanel
Studio.AssetsPanel = AssetsPanel
Studio.layers = Layers
Studio.Layers = Layers
Studio.layers_panel = LayersPanel
Studio.LayersPanel = LayersPanel
Studio.node = Node
Studio.Node = Node
Studio.node_graph = NodeGraph
Studio.NodeGraph = NodeGraph
Studio.preview = Preview
Studio.Preview = Preview
Studio.properties = Properties
Studio.Properties = Properties
Studio.responsive = Responsive
Studio.Responsive = Responsive
Studio.timeline = Timeline
Studio.Timeline = Timeline
Studio.timeline_editor = TimelineEditor
Studio.TimelineEditor = TimelineEditor
Studio.token_editor = TokenEditor
Studio.TokenEditor = TokenEditor
Studio.tokens = Tokens
Studio.Tokens = Tokens
Studio.toolbox = Toolbox
Studio.Toolbox = Toolbox
Studio.transform = Transform
Studio.Transform = Transform
Studio.transform_tools = TransformTools
Studio.TransformTools = TransformTools

__all__ = [
    "Studio",
    "SCHEMA_VERSION",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
    "MODULE_COMPONENTS",
    "Builder",
    "Canvas",
    "CanvasSurface",
    "TimelineSurface",
    "NodeSurface",
    "PreviewSurface",
    "BlockPalette",
    "ComponentPalette",
    "Inspector",
    "OutlineTree",
    "ProjectPanel",
    "PropertiesPanel",
    "ResponsiveToolbar",
    "TokensEditor",
    "ActionsEditor",
    "BindingsEditor",
    "AssetBrowser",
    "SelectionTools",
    "TransformBox",
    "TransformToolbar",
    "Assets",
    "AssetsPanel",
    "Layers",
    "LayersPanel",
    "Node",
    "NodeGraph",
    "Preview",
    "Properties",
    "Responsive",
    "Timeline",
    "TimelineEditor",
    "TokenEditor",
    "Tokens",
    "Toolbox",
    "Transform",
    "TransformTools",
]
