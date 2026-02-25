from __future__ import annotations

from .toolbar import Toolbar
from .filter_bar import FilterBar
from .grid_layout import GridLayout
from .item_actions import ItemActions
from .item_badge import ItemBadge
from .item_meta_row import ItemMetaRow
from .item_preview import ItemPreview
from .item_selectable import ItemSelectable
from .item_tile import ItemTile
from .pagination import Pagination
from .section_header import SectionHeader
from .sort_bar import SortBar
from .empty_state import EmptyState
from .loading_skeleton import LoadingSkeleton
from .search_bar import SearchBar
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
from .item_drag_handle import ItemDragHandle
from .item_drop_target import ItemDropTarget
from .item_reorder_handle import ItemReorderHandle
from .item_selection_checkbox import ItemSelectionCheckbox
from .item_selection_radio import ItemSelectionRadio
from .item_selection_switch import ItemSelectionSwitch
from .apply import Apply
from .clear import Clear
from .select_all import SelectAll
from .deselect_all import DeselectAll
from .apply_font import ApplyFont
from .apply_image import ApplyImage
from .set_as_wallpaper import SetAsWallpaper
from .presets import Presets
from .skins import Skins

MODULE_COMPONENTS = {
    "toolbar": Toolbar,
    "filter_bar": FilterBar,
    "grid_layout": GridLayout,
    "item_actions": ItemActions,
    "item_badge": ItemBadge,
    "item_meta_row": ItemMetaRow,
    "item_preview": ItemPreview,
    "item_selectable": ItemSelectable,
    "item_tile": ItemTile,
    "pagination": Pagination,
    "section_header": SectionHeader,
    "sort_bar": SortBar,
    "empty_state": EmptyState,
    "loading_skeleton": LoadingSkeleton,
    "search_bar": SearchBar,
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
    "item_drag_handle": ItemDragHandle,
    "item_drop_target": ItemDropTarget,
    "item_reorder_handle": ItemReorderHandle,
    "item_selection_checkbox": ItemSelectionCheckbox,
    "item_selection_radio": ItemSelectionRadio,
    "item_selection_switch": ItemSelectionSwitch,
    "apply": Apply,
    "clear": Clear,
    "select_all": SelectAll,
    "deselect_all": DeselectAll,
    "apply_font": ApplyFont,
    "apply_image": ApplyImage,
    "set_as_wallpaper": SetAsWallpaper,
    "presets": Presets,
    "skins": Skins,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    "MODULE_COMPONENTS",
    "Toolbar",
    "FilterBar",
    "GridLayout",
    "ItemActions",
    "ItemBadge",
    "ItemMetaRow",
    "ItemPreview",
    "ItemSelectable",
    "ItemTile",
    "Pagination",
    "SectionHeader",
    "SortBar",
    "EmptyState",
    "LoadingSkeleton",
    "SearchBar",
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
    "ItemDragHandle",
    "ItemDropTarget",
    "ItemReorderHandle",
    "ItemSelectionCheckbox",
    "ItemSelectionRadio",
    "ItemSelectionSwitch",
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
