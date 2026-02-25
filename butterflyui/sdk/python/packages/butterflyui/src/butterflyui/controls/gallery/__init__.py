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

Gallery.toolbar: type[Toolbar] = Toolbar
Gallery.Toolbar: type[Toolbar] = Toolbar
Gallery.filter_bar: type[FilterBar] = FilterBar
Gallery.FilterBar: type[FilterBar] = FilterBar
Gallery.grid_layout: type[GridLayout] = GridLayout
Gallery.GridLayout: type[GridLayout] = GridLayout
Gallery.item_actions: type[ItemActions] = ItemActions
Gallery.ItemActions: type[ItemActions] = ItemActions
Gallery.item_badge: type[ItemBadge] = ItemBadge
Gallery.ItemBadge: type[ItemBadge] = ItemBadge
Gallery.item_meta_row: type[ItemMetaRow] = ItemMetaRow
Gallery.ItemMetaRow: type[ItemMetaRow] = ItemMetaRow
Gallery.item_preview: type[ItemPreview] = ItemPreview
Gallery.ItemPreview: type[ItemPreview] = ItemPreview
Gallery.item_selectable: type[ItemSelectable] = ItemSelectable
Gallery.ItemSelectable: type[ItemSelectable] = ItemSelectable
Gallery.item_tile: type[ItemTile] = ItemTile
Gallery.ItemTile: type[ItemTile] = ItemTile
Gallery.pagination: type[Pagination] = Pagination
Gallery.Pagination: type[Pagination] = Pagination
Gallery.section_header: type[SectionHeader] = SectionHeader
Gallery.SectionHeader: type[SectionHeader] = SectionHeader
Gallery.sort_bar: type[SortBar] = SortBar
Gallery.SortBar: type[SortBar] = SortBar
Gallery.empty_state: type[EmptyState] = EmptyState
Gallery.EmptyState: type[EmptyState] = EmptyState
Gallery.loading_skeleton: type[LoadingSkeleton] = LoadingSkeleton
Gallery.LoadingSkeleton: type[LoadingSkeleton] = LoadingSkeleton
Gallery.search_bar: type[SearchBar] = SearchBar
Gallery.SearchBar: type[SearchBar] = SearchBar
Gallery.fonts: type[Fonts] = Fonts
Gallery.Fonts: type[Fonts] = Fonts
Gallery.font_picker: type[FontPicker] = FontPicker
Gallery.FontPicker: type[FontPicker] = FontPicker
Gallery.font_renderer: type[FontRenderer] = FontRenderer
Gallery.FontRenderer: type[FontRenderer] = FontRenderer
Gallery.audio: type[Audio] = Audio
Gallery.Audio: type[Audio] = Audio
Gallery.audio_picker: type[AudioPicker] = AudioPicker
Gallery.AudioPicker: type[AudioPicker] = AudioPicker
Gallery.audio_renderer: type[AudioRenderer] = AudioRenderer
Gallery.AudioRenderer: type[AudioRenderer] = AudioRenderer
Gallery.video: type[Video] = Video
Gallery.Video: type[Video] = Video
Gallery.video_picker: type[VideoPicker] = VideoPicker
Gallery.VideoPicker: type[VideoPicker] = VideoPicker
Gallery.video_renderer: type[VideoRenderer] = VideoRenderer
Gallery.VideoRenderer: type[VideoRenderer] = VideoRenderer
Gallery.image: type[Image] = Image
Gallery.Image: type[Image] = Image
Gallery.image_picker: type[ImagePicker] = ImagePicker
Gallery.ImagePicker: type[ImagePicker] = ImagePicker
Gallery.image_renderer: type[ImageRenderer] = ImageRenderer
Gallery.ImageRenderer: type[ImageRenderer] = ImageRenderer
Gallery.document: type[Document] = Document
Gallery.Document: type[Document] = Document
Gallery.document_picker: type[DocumentPicker] = DocumentPicker
Gallery.DocumentPicker: type[DocumentPicker] = DocumentPicker
Gallery.document_renderer: type[DocumentRenderer] = DocumentRenderer
Gallery.DocumentRenderer: type[DocumentRenderer] = DocumentRenderer
Gallery.item_drag_handle: type[ItemDragHandle] = ItemDragHandle
Gallery.ItemDragHandle: type[ItemDragHandle] = ItemDragHandle
Gallery.item_drop_target: type[ItemDropTarget] = ItemDropTarget
Gallery.ItemDropTarget: type[ItemDropTarget] = ItemDropTarget
Gallery.item_reorder_handle: type[ItemReorderHandle] = ItemReorderHandle
Gallery.ItemReorderHandle: type[ItemReorderHandle] = ItemReorderHandle
Gallery.item_selection_checkbox: type[ItemSelectionCheckbox] = ItemSelectionCheckbox
Gallery.ItemSelectionCheckbox: type[ItemSelectionCheckbox] = ItemSelectionCheckbox
Gallery.item_selection_radio: type[ItemSelectionRadio] = ItemSelectionRadio
Gallery.ItemSelectionRadio: type[ItemSelectionRadio] = ItemSelectionRadio
Gallery.item_selection_switch: type[ItemSelectionSwitch] = ItemSelectionSwitch
Gallery.ItemSelectionSwitch: type[ItemSelectionSwitch] = ItemSelectionSwitch
Gallery.apply: type[Apply] = Apply
Gallery.Apply: type[Apply] = Apply
Gallery.clear: type[Clear] = Clear
Gallery.Clear: type[Clear] = Clear
Gallery.select_all: type[SelectAll] = SelectAll
Gallery.SelectAll: type[SelectAll] = SelectAll
Gallery.deselect_all: type[DeselectAll] = DeselectAll
Gallery.DeselectAll: type[DeselectAll] = DeselectAll
Gallery.apply_font: type[ApplyFont] = ApplyFont
Gallery.ApplyFont: type[ApplyFont] = ApplyFont
Gallery.apply_image: type[ApplyImage] = ApplyImage
Gallery.ApplyImage: type[ApplyImage] = ApplyImage
Gallery.set_as_wallpaper: type[SetAsWallpaper] = SetAsWallpaper
Gallery.SetAsWallpaper: type[SetAsWallpaper] = SetAsWallpaper
Gallery.presets: type[Presets] = Presets
Gallery.Presets: type[Presets] = Presets
Gallery.skins: type[Skins] = Skins
Gallery.Skins: type[Skins] = Skins

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
