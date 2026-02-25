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

Studio.builder: type[Builder] = Builder
Studio.Builder: type[Builder] = Builder
Studio.canvas: type[Canvas] = Canvas
Studio.Canvas: type[Canvas] = Canvas
Studio.canvas_surface: type[CanvasSurface] = CanvasSurface
Studio.CanvasSurface: type[CanvasSurface] = CanvasSurface
Studio.timeline_surface: type[TimelineSurface] = TimelineSurface
Studio.TimelineSurface: type[TimelineSurface] = TimelineSurface
Studio.node_surface: type[NodeSurface] = NodeSurface
Studio.NodeSurface: type[NodeSurface] = NodeSurface
Studio.preview_surface: type[PreviewSurface] = PreviewSurface
Studio.PreviewSurface: type[PreviewSurface] = PreviewSurface
Studio.block_palette: type[BlockPalette] = BlockPalette
Studio.BlockPalette: type[BlockPalette] = BlockPalette
Studio.component_palette: type[ComponentPalette] = ComponentPalette
Studio.ComponentPalette: type[ComponentPalette] = ComponentPalette
Studio.inspector: type[Inspector] = Inspector
Studio.Inspector: type[Inspector] = Inspector
Studio.outline_tree: type[OutlineTree] = OutlineTree
Studio.OutlineTree: type[OutlineTree] = OutlineTree
Studio.project_panel: type[ProjectPanel] = ProjectPanel
Studio.ProjectPanel: type[ProjectPanel] = ProjectPanel
Studio.properties_panel: type[PropertiesPanel] = PropertiesPanel
Studio.PropertiesPanel: type[PropertiesPanel] = PropertiesPanel
Studio.responsive_toolbar: type[ResponsiveToolbar] = ResponsiveToolbar
Studio.ResponsiveToolbar: type[ResponsiveToolbar] = ResponsiveToolbar
Studio.tokens_editor: type[TokensEditor] = TokensEditor
Studio.TokensEditor: type[TokensEditor] = TokensEditor
Studio.actions_editor: type[ActionsEditor] = ActionsEditor
Studio.ActionsEditor: type[ActionsEditor] = ActionsEditor
Studio.bindings_editor: type[BindingsEditor] = BindingsEditor
Studio.BindingsEditor: type[BindingsEditor] = BindingsEditor
Studio.asset_browser: type[AssetBrowser] = AssetBrowser
Studio.AssetBrowser: type[AssetBrowser] = AssetBrowser
Studio.selection_tools: type[SelectionTools] = SelectionTools
Studio.SelectionTools: type[SelectionTools] = SelectionTools
Studio.transform_box: type[TransformBox] = TransformBox
Studio.TransformBox: type[TransformBox] = TransformBox
Studio.transform_toolbar: type[TransformToolbar] = TransformToolbar
Studio.TransformToolbar: type[TransformToolbar] = TransformToolbar
Studio.assets: type[Assets] = Assets
Studio.Assets: type[Assets] = Assets
Studio.assets_panel: type[AssetsPanel] = AssetsPanel
Studio.AssetsPanel: type[AssetsPanel] = AssetsPanel
Studio.layers: type[Layers] = Layers
Studio.Layers: type[Layers] = Layers
Studio.layers_panel: type[LayersPanel] = LayersPanel
Studio.LayersPanel: type[LayersPanel] = LayersPanel
Studio.node: type[Node] = Node
Studio.Node: type[Node] = Node
Studio.node_graph: type[NodeGraph] = NodeGraph
Studio.NodeGraph: type[NodeGraph] = NodeGraph
Studio.preview: type[Preview] = Preview
Studio.Preview: type[Preview] = Preview
Studio.properties: type[Properties] = Properties
Studio.Properties: type[Properties] = Properties
Studio.responsive: type[Responsive] = Responsive
Studio.Responsive: type[Responsive] = Responsive
Studio.timeline: type[Timeline] = Timeline
Studio.Timeline: type[Timeline] = Timeline
Studio.timeline_editor: type[TimelineEditor] = TimelineEditor
Studio.TimelineEditor: type[TimelineEditor] = TimelineEditor
Studio.token_editor: type[TokenEditor] = TokenEditor
Studio.TokenEditor: type[TokenEditor] = TokenEditor
Studio.tokens: type[Tokens] = Tokens
Studio.Tokens: type[Tokens] = Tokens
Studio.toolbox: type[Toolbox] = Toolbox
Studio.Toolbox: type[Toolbox] = Toolbox
Studio.transform: type[Transform] = Transform
Studio.Transform: type[Transform] = Transform
Studio.transform_tools: type[TransformTools] = TransformTools
Studio.TransformTools: type[TransformTools] = TransformTools

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
