"""
Dispatch layer for the Gallery umbrella control.

Maps every gallery submodule string to its Python class and provides
category-based lookup helpers that mirror the Dart submodule registry.
"""
from __future__ import annotations

from typing import Optional, Type

# ---------------------------------------------------------------------------
# Individual module imports
# ---------------------------------------------------------------------------

from .toolbar import Toolbar
from .filter_bar import FilterBar
from .sort_bar import SortBar
from .section_header import SectionHeader
from .grid_layout import GridLayout
from .pagination import Pagination
from .search_bar import SearchBar
from .loading_skeleton import LoadingSkeleton
from .empty_state import EmptyState
from .item_tile import ItemTile
from .item_badge import ItemBadge
from .item_meta_row import ItemMetaRow
from .item_preview import ItemPreview
from .item_actions import ItemActions
from .item_selectable import ItemSelectable
from .item_drag_handle import ItemDragHandle
from .item_drop_target import ItemDropTarget
from .item_reorder_handle import ItemReorderHandle
from .item_selection_checkbox import ItemSelectionCheckbox
from .item_selection_radio import ItemSelectionRadio
from .item_selection_switch import ItemSelectionSwitch
from .fonts import Fonts
from .font_picker import FontPicker
from .font_renderer import FontRenderer
from .audio import Audio
from .audio_picker import AudioPicker
from .audio_renderer import AudioRenderer
from .video import Video
from .video_picker import VideoPicker
from .video_renderer import VideoRenderer
from .image import Image
from .image_picker import ImagePicker
from .image_renderer import ImageRenderer
from .document import Document
from .document_picker import DocumentPicker
from .document_renderer import DocumentRenderer
from .apply import Apply
from .clear import Clear
from .select_all import SelectAll
from .deselect_all import DeselectAll
from .apply_font import ApplyFont
from .apply_image import ApplyImage
from .set_as_wallpaper import SetAsWallpaper
from .presets import Presets
from .skins import Skins

# ---------------------------------------------------------------------------
# Category dictionaries
# ---------------------------------------------------------------------------

LAYOUT_COMPONENTS: dict[str, type] = {
    "toolbar": Toolbar,
    "filter_bar": FilterBar,
    "sort_bar": SortBar,
    "section_header": SectionHeader,
    "grid_layout": GridLayout,
    "pagination": Pagination,
    "search_bar": SearchBar,
    "loading_skeleton": LoadingSkeleton,
    "empty_state": EmptyState,
}

ITEMS_COMPONENTS: dict[str, type] = {
    "item_tile": ItemTile,
    "item_badge": ItemBadge,
    "item_meta_row": ItemMetaRow,
    "item_preview": ItemPreview,
    "item_actions": ItemActions,
    "item_selectable": ItemSelectable,
    "item_drag_handle": ItemDragHandle,
    "item_drop_target": ItemDropTarget,
    "item_reorder_handle": ItemReorderHandle,
    "item_selection_checkbox": ItemSelectionCheckbox,
    "item_selection_radio": ItemSelectionRadio,
    "item_selection_switch": ItemSelectionSwitch,
}

MEDIA_COMPONENTS: dict[str, type] = {
    "fonts": Fonts,
    "font_picker": FontPicker,
    "font_renderer": FontRenderer,
    "audio": Audio,
    "audio_picker": AudioPicker,
    "audio_renderer": AudioRenderer,
    "video": Video,
    "video_picker": VideoPicker,
    "video_renderer": VideoRenderer,
    "image": Image,
    "image_picker": ImagePicker,
    "image_renderer": ImageRenderer,
    "document": Document,
    "document_picker": DocumentPicker,
    "document_renderer": DocumentRenderer,
}

COMMANDS_COMPONENTS: dict[str, type] = {
    "apply": Apply,
    "clear": Clear,
    "select_all": SelectAll,
    "deselect_all": DeselectAll,
    "apply_font": ApplyFont,
    "apply_image": ApplyImage,
    "set_as_wallpaper": SetAsWallpaper,
}

CUSTOMIZATION_COMPONENTS: dict[str, type] = {
    "presets": Presets,
    "skins": Skins,
}

# ---------------------------------------------------------------------------
# Combined lookup tables
# ---------------------------------------------------------------------------

MODULE_COMPONENTS: dict[str, type] = {
    **LAYOUT_COMPONENTS,
    **ITEMS_COMPONENTS,
    **MEDIA_COMPONENTS,
    **COMMANDS_COMPONENTS,
    **CUSTOMIZATION_COMPONENTS,
}

CATEGORY_COMPONENTS: dict[str, dict[str, type]] = {
    "layout": LAYOUT_COMPONENTS,
    "items": ITEMS_COMPONENTS,
    "media": MEDIA_COMPONENTS,
    "commands": COMMANDS_COMPONENTS,
    "customization": CUSTOMIZATION_COMPONENTS,
}

MODULE_CATEGORY: dict[str, str] = {
    module: category
    for category, modules in CATEGORY_COMPONENTS.items()
    for module in modules
}

# ---------------------------------------------------------------------------
# Dispatch functions
# ---------------------------------------------------------------------------


def get_gallery_component(module: str) -> Optional[Type]:
    """Return the class for *module*, or ``None`` if unknown."""
    return MODULE_COMPONENTS.get(module)


def get_gallery_layout_component(module: str) -> Optional[Type]:
    return LAYOUT_COMPONENTS.get(module)


def get_gallery_items_component(module: str) -> Optional[Type]:
    return ITEMS_COMPONENTS.get(module)


def get_gallery_media_component(module: str) -> Optional[Type]:
    return MEDIA_COMPONENTS.get(module)


def get_gallery_commands_component(module: str) -> Optional[Type]:
    return COMMANDS_COMPONENTS.get(module)


def get_gallery_customization_component(module: str) -> Optional[Type]:
    return CUSTOMIZATION_COMPONENTS.get(module)


def get_gallery_category_components(category: str) -> Optional[dict[str, type]]:
    """Return the category dict for *category*, or ``None`` if unknown."""
    return CATEGORY_COMPONENTS.get(category)


def get_gallery_module_category(module: str) -> Optional[str]:
    """Return the category name for *module*, or ``None`` if unknown."""
    return MODULE_CATEGORY.get(module)


__all__ = [
    # Category dicts
    "LAYOUT_COMPONENTS",
    "ITEMS_COMPONENTS",
    "MEDIA_COMPONENTS",
    "COMMANDS_COMPONENTS",
    "CUSTOMIZATION_COMPONENTS",
    # Combined
    "MODULE_COMPONENTS",
    "CATEGORY_COMPONENTS",
    "MODULE_CATEGORY",
    # Functions
    "get_gallery_component",
    "get_gallery_layout_component",
    "get_gallery_items_component",
    "get_gallery_media_component",
    "get_gallery_commands_component",
    "get_gallery_customization_component",
    "get_gallery_category_components",
    "get_gallery_module_category",
    # Classes (re-exported for convenience)
    "Toolbar",
    "FilterBar",
    "SortBar",
    "SectionHeader",
    "GridLayout",
    "Pagination",
    "SearchBar",
    "LoadingSkeleton",
    "EmptyState",
    "ItemTile",
    "ItemBadge",
    "ItemMetaRow",
    "ItemPreview",
    "ItemActions",
    "ItemSelectable",
    "ItemDragHandle",
    "ItemDropTarget",
    "ItemReorderHandle",
    "ItemSelectionCheckbox",
    "ItemSelectionRadio",
    "ItemSelectionSwitch",
    "Fonts",
    "FontPicker",
    "FontRenderer",
    "Audio",
    "AudioPicker",
    "AudioRenderer",
    "Video",
    "VideoPicker",
    "VideoRenderer",
    "Image",
    "ImagePicker",
    "ImageRenderer",
    "Document",
    "DocumentPicker",
    "DocumentRenderer",
    "Apply",
    "Clear",
    "SelectAll",
    "DeselectAll",
    "ApplyFont",
    "ApplyImage",
    "SetAsWallpaper",
    "Presets",
    "Skins",
]
