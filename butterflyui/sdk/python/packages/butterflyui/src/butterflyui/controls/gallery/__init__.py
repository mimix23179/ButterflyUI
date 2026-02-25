from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Gallery
from .submodules import (
    Toolbar,
    FilterBar,
    GridLayout,
    ItemActions,
    ItemBadge,
    ItemMetaRow,
    ItemPreview,
    ItemSelectable,
    ItemTile,
    Pagination,
    SectionHeader,
    SortBar,
    EmptyState,
    LoadingSkeleton,
    SearchBar,
    Fonts,
    FontPicker,
    FontRenderer,
    Audio,
    AudioPicker,
    AudioRenderer,
    Video,
    VideoPicker,
    VideoRenderer,
    Image,
    ImagePicker,
    ImageRenderer,
    Document,
    DocumentPicker,
    DocumentRenderer,
    ItemDragHandle,
    ItemDropTarget,
    ItemReorderHandle,
    ItemSelectionCheckbox,
    ItemSelectionRadio,
    ItemSelectionSwitch,
    Apply,
    Clear,
    SelectAll,
    DeselectAll,
    ApplyFont,
    ApplyImage,
    SetAsWallpaper,
    Presets,
    Skins,
)
from .schema import (
    EVENTS,
    MODULES,
    REGISTRY_MANIFEST_LISTS,
    REGISTRY_ROLE_ALIASES,
    SCHEMA_VERSION,
    STATES,
)

Gallery.toolbar = Toolbar
Gallery.Toolbar = Toolbar
Gallery.filter_bar = FilterBar
Gallery.FilterBar = FilterBar
Gallery.grid_layout = GridLayout
Gallery.GridLayout = GridLayout
Gallery.item_actions = ItemActions
Gallery.ItemActions = ItemActions
Gallery.item_badge = ItemBadge
Gallery.ItemBadge = ItemBadge
Gallery.item_meta_row = ItemMetaRow
Gallery.ItemMetaRow = ItemMetaRow
Gallery.item_preview = ItemPreview
Gallery.ItemPreview = ItemPreview
Gallery.item_selectable = ItemSelectable
Gallery.ItemSelectable = ItemSelectable
Gallery.item_tile = ItemTile
Gallery.ItemTile = ItemTile
Gallery.pagination = Pagination
Gallery.Pagination = Pagination
Gallery.section_header = SectionHeader
Gallery.SectionHeader = SectionHeader
Gallery.sort_bar = SortBar
Gallery.SortBar = SortBar
Gallery.empty_state = EmptyState
Gallery.EmptyState = EmptyState
Gallery.loading_skeleton = LoadingSkeleton
Gallery.LoadingSkeleton = LoadingSkeleton
Gallery.search_bar = SearchBar
Gallery.SearchBar = SearchBar
Gallery.fonts = Fonts
Gallery.Fonts = Fonts
Gallery.font_picker = FontPicker
Gallery.FontPicker = FontPicker
Gallery.font_renderer = FontRenderer
Gallery.FontRenderer = FontRenderer
Gallery.audio = Audio
Gallery.Audio = Audio
Gallery.audio_picker = AudioPicker
Gallery.AudioPicker = AudioPicker
Gallery.audio_renderer = AudioRenderer
Gallery.AudioRenderer = AudioRenderer
Gallery.video = Video
Gallery.Video = Video
Gallery.video_picker = VideoPicker
Gallery.VideoPicker = VideoPicker
Gallery.video_renderer = VideoRenderer
Gallery.VideoRenderer = VideoRenderer
Gallery.image = Image
Gallery.Image = Image
Gallery.image_picker = ImagePicker
Gallery.ImagePicker = ImagePicker
Gallery.image_renderer = ImageRenderer
Gallery.ImageRenderer = ImageRenderer
Gallery.document = Document
Gallery.Document = Document
Gallery.document_picker = DocumentPicker
Gallery.DocumentPicker = DocumentPicker
Gallery.document_renderer = DocumentRenderer
Gallery.DocumentRenderer = DocumentRenderer
Gallery.item_drag_handle = ItemDragHandle
Gallery.ItemDragHandle = ItemDragHandle
Gallery.item_drop_target = ItemDropTarget
Gallery.ItemDropTarget = ItemDropTarget
Gallery.item_reorder_handle = ItemReorderHandle
Gallery.ItemReorderHandle = ItemReorderHandle
Gallery.item_selection_checkbox = ItemSelectionCheckbox
Gallery.ItemSelectionCheckbox = ItemSelectionCheckbox
Gallery.item_selection_radio = ItemSelectionRadio
Gallery.ItemSelectionRadio = ItemSelectionRadio
Gallery.item_selection_switch = ItemSelectionSwitch
Gallery.ItemSelectionSwitch = ItemSelectionSwitch
Gallery.apply = Apply
Gallery.Apply = Apply
Gallery.clear = Clear
Gallery.Clear = Clear
Gallery.select_all = SelectAll
Gallery.SelectAll = SelectAll
Gallery.deselect_all = DeselectAll
Gallery.DeselectAll = DeselectAll
Gallery.apply_font = ApplyFont
Gallery.ApplyFont = ApplyFont
Gallery.apply_image = ApplyImage
Gallery.ApplyImage = ApplyImage
Gallery.set_as_wallpaper = SetAsWallpaper
Gallery.SetAsWallpaper = SetAsWallpaper
Gallery.presets = Presets
Gallery.Presets = Presets
Gallery.skins = Skins
Gallery.Skins = Skins

__all__ = [
    "Gallery",
    "SCHEMA_VERSION",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
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
