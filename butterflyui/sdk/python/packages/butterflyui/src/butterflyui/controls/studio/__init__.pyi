from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Studio as _Studio
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

class Studio(_Studio):
    builder: type[Builder]
    Builder: type[Builder]
    canvas: type[Canvas]
    Canvas: type[Canvas]
    canvas_surface: type[CanvasSurface]
    CanvasSurface: type[CanvasSurface]
    timeline_surface: type[TimelineSurface]
    TimelineSurface: type[TimelineSurface]
    node_surface: type[NodeSurface]
    NodeSurface: type[NodeSurface]
    preview_surface: type[PreviewSurface]
    PreviewSurface: type[PreviewSurface]
    block_palette: type[BlockPalette]
    BlockPalette: type[BlockPalette]
    component_palette: type[ComponentPalette]
    ComponentPalette: type[ComponentPalette]
    inspector: type[Inspector]
    Inspector: type[Inspector]
    outline_tree: type[OutlineTree]
    OutlineTree: type[OutlineTree]
    project_panel: type[ProjectPanel]
    ProjectPanel: type[ProjectPanel]
    properties_panel: type[PropertiesPanel]
    PropertiesPanel: type[PropertiesPanel]
    responsive_toolbar: type[ResponsiveToolbar]
    ResponsiveToolbar: type[ResponsiveToolbar]
    tokens_editor: type[TokensEditor]
    TokensEditor: type[TokensEditor]
    actions_editor: type[ActionsEditor]
    ActionsEditor: type[ActionsEditor]
    bindings_editor: type[BindingsEditor]
    BindingsEditor: type[BindingsEditor]
    asset_browser: type[AssetBrowser]
    AssetBrowser: type[AssetBrowser]
    selection_tools: type[SelectionTools]
    SelectionTools: type[SelectionTools]
    transform_box: type[TransformBox]
    TransformBox: type[TransformBox]
    transform_toolbar: type[TransformToolbar]
    TransformToolbar: type[TransformToolbar]
    assets: type[Assets]
    Assets: type[Assets]
    assets_panel: type[AssetsPanel]
    AssetsPanel: type[AssetsPanel]
    layers: type[Layers]
    Layers: type[Layers]
    layers_panel: type[LayersPanel]
    LayersPanel: type[LayersPanel]
    node: type[Node]
    Node: type[Node]
    node_graph: type[NodeGraph]
    NodeGraph: type[NodeGraph]
    preview: type[Preview]
    Preview: type[Preview]
    properties: type[Properties]
    Properties: type[Properties]
    responsive: type[Responsive]
    Responsive: type[Responsive]
    timeline: type[Timeline]
    Timeline: type[Timeline]
    timeline_editor: type[TimelineEditor]
    TimelineEditor: type[TimelineEditor]
    token_editor: type[TokenEditor]
    TokenEditor: type[TokenEditor]
    tokens: type[Tokens]
    Tokens: type[Tokens]
    toolbox: type[Toolbox]
    Toolbox: type[Toolbox]
    transform: type[Transform]
    Transform: type[Transform]
    transform_tools: type[TransformTools]
    TransformTools: type[TransformTools]

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
