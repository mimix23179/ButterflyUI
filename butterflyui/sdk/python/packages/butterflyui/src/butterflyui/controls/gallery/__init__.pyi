from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Gallery as _Gallery
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

class Gallery(_Gallery):
    toolbar: type[Toolbar]
    Toolbar: type[Toolbar]
    filter_bar: type[FilterBar]
    FilterBar: type[FilterBar]
    grid_layout: type[GridLayout]
    GridLayout: type[GridLayout]
    item_actions: type[ItemActions]
    ItemActions: type[ItemActions]
    item_badge: type[ItemBadge]
    ItemBadge: type[ItemBadge]
    item_meta_row: type[ItemMetaRow]
    ItemMetaRow: type[ItemMetaRow]
    item_preview: type[ItemPreview]
    ItemPreview: type[ItemPreview]
    item_selectable: type[ItemSelectable]
    ItemSelectable: type[ItemSelectable]
    item_tile: type[ItemTile]
    ItemTile: type[ItemTile]
    pagination: type[Pagination]
    Pagination: type[Pagination]
    section_header: type[SectionHeader]
    SectionHeader: type[SectionHeader]
    sort_bar: type[SortBar]
    SortBar: type[SortBar]
    empty_state: type[EmptyState]
    EmptyState: type[EmptyState]
    loading_skeleton: type[LoadingSkeleton]
    LoadingSkeleton: type[LoadingSkeleton]
    search_bar: type[SearchBar]
    SearchBar: type[SearchBar]
    fonts: type[Fonts]
    Fonts: type[Fonts]
    font_picker: type[FontPicker]
    FontPicker: type[FontPicker]
    font_renderer: type[FontRenderer]
    FontRenderer: type[FontRenderer]
    audio: type[Audio]
    Audio: type[Audio]
    audio_picker: type[AudioPicker]
    AudioPicker: type[AudioPicker]
    audio_renderer: type[AudioRenderer]
    AudioRenderer: type[AudioRenderer]
    video: type[Video]
    Video: type[Video]
    video_picker: type[VideoPicker]
    VideoPicker: type[VideoPicker]
    video_renderer: type[VideoRenderer]
    VideoRenderer: type[VideoRenderer]
    image: type[Image]
    Image: type[Image]
    image_picker: type[ImagePicker]
    ImagePicker: type[ImagePicker]
    image_renderer: type[ImageRenderer]
    ImageRenderer: type[ImageRenderer]
    document: type[Document]
    Document: type[Document]
    document_picker: type[DocumentPicker]
    DocumentPicker: type[DocumentPicker]
    document_renderer: type[DocumentRenderer]
    DocumentRenderer: type[DocumentRenderer]
    item_drag_handle: type[ItemDragHandle]
    ItemDragHandle: type[ItemDragHandle]
    item_drop_target: type[ItemDropTarget]
    ItemDropTarget: type[ItemDropTarget]
    item_reorder_handle: type[ItemReorderHandle]
    ItemReorderHandle: type[ItemReorderHandle]
    item_selection_checkbox: type[ItemSelectionCheckbox]
    ItemSelectionCheckbox: type[ItemSelectionCheckbox]
    item_selection_radio: type[ItemSelectionRadio]
    ItemSelectionRadio: type[ItemSelectionRadio]
    item_selection_switch: type[ItemSelectionSwitch]
    ItemSelectionSwitch: type[ItemSelectionSwitch]
    apply: type[Apply]
    Apply: type[Apply]
    clear: type[Clear]
    Clear: type[Clear]
    select_all: type[SelectAll]
    SelectAll: type[SelectAll]
    deselect_all: type[DeselectAll]
    DeselectAll: type[DeselectAll]
    apply_font: type[ApplyFont]
    ApplyFont: type[ApplyFont]
    apply_image: type[ApplyImage]
    ApplyImage: type[ApplyImage]
    set_as_wallpaper: type[SetAsWallpaper]
    SetAsWallpaper: type[SetAsWallpaper]
    presets: type[Presets]
    Presets: type[Presets]
    skins: type[Skins]
    Skins: type[Skins]

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
