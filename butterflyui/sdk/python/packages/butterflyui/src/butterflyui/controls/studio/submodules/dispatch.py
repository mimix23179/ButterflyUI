from __future__ import annotations

from typing import Dict, Optional, Type

from .builder import Builder
from .canvas import Canvas
from .canvas_surface import CanvasSurface
from .timeline_surface import TimelineSurface
from .timeline import Timeline
from .timeline_editor import TimelineEditor
from .node_surface import NodeSurface
from .node import Node
from .node_graph import NodeGraph
from .preview_surface import PreviewSurface
from .preview import Preview
from .project_panel import ProjectPanel
from .outline_tree import OutlineTree
from .asset_browser import AssetBrowser
from .assets import Assets
from .assets_panel import AssetsPanel
from .layers import Layers
from .layers_panel import LayersPanel
from .component_palette import ComponentPalette
from .block_palette import BlockPalette
from .inspector import Inspector
from .properties_panel import PropertiesPanel
from .properties import Properties
from .actions_editor import ActionsEditor
from .bindings_editor import BindingsEditor
from .tokens_editor import TokensEditor
from .token_editor import TokenEditor
from .tokens import Tokens
from .selection_tools import SelectionTools
from .toolbox import Toolbox
from .transform_toolbar import TransformToolbar
from .transform_tools import TransformTools
from .transform_box import TransformBox
from .transform import Transform
from .responsive_toolbar import ResponsiveToolbar
from .responsive import Responsive

# ---------------------------------------------------------------------------
# Categorised component dicts
# ---------------------------------------------------------------------------

SURFACES_COMPONENTS: Dict[str, type] = {
    'builder': Builder,
    'canvas': Canvas,
    'canvas_surface': CanvasSurface,
    'timeline_surface': TimelineSurface,
    'timeline': Timeline,
    'timeline_editor': TimelineEditor,
    'node_surface': NodeSurface,
    'node': Node,
    'node_graph': NodeGraph,
    'preview_surface': PreviewSurface,
    'preview': Preview,
}

PANELS_COMPONENTS: Dict[str, type] = {
    'project_panel': ProjectPanel,
    'outline_tree': OutlineTree,
    'asset_browser': AssetBrowser,
    'assets': Assets,
    'assets_panel': AssetsPanel,
    'layers': Layers,
    'layers_panel': LayersPanel,
    'component_palette': ComponentPalette,
    'block_palette': BlockPalette,
    'inspector': Inspector,
    'properties_panel': PropertiesPanel,
    'properties': Properties,
    'actions_editor': ActionsEditor,
    'bindings_editor': BindingsEditor,
    'tokens_editor': TokensEditor,
    'token_editor': TokenEditor,
    'tokens': Tokens,
}

TOOLS_COMPONENTS: Dict[str, type] = {
    'selection_tools': SelectionTools,
    'toolbox': Toolbox,
    'transform_toolbar': TransformToolbar,
    'transform_tools': TransformTools,
    'transform_box': TransformBox,
    'transform': Transform,
    'responsive_toolbar': ResponsiveToolbar,
    'responsive': Responsive,
}

# ---------------------------------------------------------------------------
# Category names and merged lookup
# ---------------------------------------------------------------------------

STUDIO_CATEGORIES = ('surfaces', 'panels', 'tools')

_CATEGORY_MAP: Dict[str, Dict[str, type]] = {
    'surfaces': SURFACES_COMPONENTS,
    'panels': PANELS_COMPONENTS,
    'tools': TOOLS_COMPONENTS,
}

MODULE_CATEGORY: Dict[str, str] = {
    module: category
    for category, modules in _CATEGORY_MAP.items()
    for module in modules
}

# ---------------------------------------------------------------------------
# Lookup helpers
# ---------------------------------------------------------------------------


def get_studio_module_category(module: str) -> Optional[str]:
    """Return *'surfaces'*, *'panels'*, or *'tools'* for *module*, else None."""
    return MODULE_CATEGORY.get(module)


def get_studio_component(module: str) -> Optional[type]:
    """Return the component class for *module* across all categories."""
    for components in _CATEGORY_MAP.values():
        if module in components:
            return components[module]
    return None


def get_studio_surfaces_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is a surfaces module."""
    return SURFACES_COMPONENTS.get(module)


def get_studio_panels_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is a panels module."""
    return PANELS_COMPONENTS.get(module)


def get_studio_tools_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is a tools module."""
    return TOOLS_COMPONENTS.get(module)


def get_studio_category_components(category: str) -> Dict[str, type]:
    """Return the component dict for *category* ('surfaces', 'panels', 'tools')."""
    return dict(_CATEGORY_MAP.get(category, {}))


def is_studio_surfaces_module(module: str) -> bool:
    return module in SURFACES_COMPONENTS


def is_studio_panels_module(module: str) -> bool:
    return module in PANELS_COMPONENTS


def is_studio_tools_module(module: str) -> bool:
    return module in TOOLS_COMPONENTS


__all__ = [
    'SURFACES_COMPONENTS',
    'PANELS_COMPONENTS',
    'TOOLS_COMPONENTS',
    'STUDIO_CATEGORIES',
    'MODULE_CATEGORY',
    'get_studio_module_category',
    'get_studio_component',
    'get_studio_surfaces_component',
    'get_studio_panels_component',
    'get_studio_tools_component',
    'get_studio_category_components',
    'is_studio_surfaces_module',
    'is_studio_panels_module',
    'is_studio_tools_module',
]
