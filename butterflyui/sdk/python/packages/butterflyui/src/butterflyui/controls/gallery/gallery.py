from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from collections.abc import Iterable, Mapping
import mimetypes
from pathlib import Path
import sys
from typing import Any

from .._shared import Component, merge_props

__all__ = [
    "Gallery",
    "GalleryScope",
    "GalleryItem",
    "GalleryLayoutType",
    "gallery_grid",
    "gallery_masonry",
    "gallery_list",
    "gallery_carousel",
    "gallery_virtual_grid",
    "gallery_virtual_list",
    "gallery_item_from_file",
    "gallery_items_from_paths",
    "scan_gallery_directory",
    "discover_installed_font_paths",
    "gallery_font_items_from_system",
    "gallery_local_media",
    "gallery_local_images",
    "gallery_local_videos",
    "gallery_local_audio",
    "gallery_local_documents",
    "gallery_local_fonts",
]


class GalleryLayoutType:
    """
    Enum-like container for supported Gallery layout strings.

    Use these constants when setting ``Gallery(layout=...)``.

    - ``GRID``: fixed-column grid
    - ``MASONRY``: variable-height masonry grid
    - ``LIST``: vertical list rows
    - ``CAROUSEL``: page-style horizontal carousel
    - ``VIRTUAL_GRID``: virtualized grid for large datasets
    - ``VIRTUAL_LIST``: virtualized list for large datasets

    ``all()`` returns every supported layout string.
    """

    GRID = "grid"
    MASONRY = "masonry"
    LIST = "list"
    CAROUSEL = "carousel"
    VIRTUAL_GRID = "virtual_grid"
    VIRTUAL_LIST = "virtual_list"

    @staticmethod
    def all() -> list[str]:
        return [
            GalleryLayoutType.GRID,
            GalleryLayoutType.MASONRY,
            GalleryLayoutType.LIST,
            GalleryLayoutType.CAROUSEL,
            GalleryLayoutType.VIRTUAL_GRID,
            GalleryLayoutType.VIRTUAL_LIST,
        ]


def _normalize_gallery_token(value: Any | None) -> str:
    if value is None:
        return ""
    return str(value).strip().lower().replace("-", "_").replace(" ", "_")


def _normalize_gallery_layout(value: Any | None) -> str | None:
    token = _normalize_gallery_token(value)
    if not token:
        return None
    aliases = {
        "virtualgrid": GalleryLayoutType.VIRTUAL_GRID,
        "virtuallist": GalleryLayoutType.VIRTUAL_LIST,
        "grid_layout": GalleryLayoutType.GRID,
        "list_layout": GalleryLayoutType.LIST,
    }
    return aliases.get(token, token)


def _normalize_gallery_module(value: Any | None) -> str | None:
    token = _normalize_gallery_token(value)
    if not token:
        return None
    aliases = {
        "grid": "grid_layout",
        "virtualgrid": "virtual_grid",
        "virtuallist": "virtual_list",
        "filter": "filter_bar",
        "sort": "sort_bar",
        "search": "search_bar",
        "item": "item_tile",
        "selection": "item_selectable",
        "select": "item_selectable",
    }
    return aliases.get(token, token)


def _resolve_layout_from_module(module: str | None) -> str | None:
    if module is None:
        return None
    return {
        "grid_layout": GalleryLayoutType.GRID,
        "virtual_grid": GalleryLayoutType.VIRTUAL_GRID,
        "virtual_list": GalleryLayoutType.VIRTUAL_LIST,
        "list": GalleryLayoutType.LIST,
        "carousel": GalleryLayoutType.CAROUSEL,
    }.get(module)


def _resolve_type_filter_from_module(module: str | None) -> str | None:
    if module is None:
        return None
    return {
        "fonts": "font",
        "font_picker": "font",
        "font_renderer": "font",
        "audio": "audio",
        "audio_picker": "audio",
        "audio_renderer": "audio",
        "video": "video",
        "video_picker": "video",
        "video_renderer": "video",
        "image": "image",
        "image_picker": "image",
        "image_renderer": "image",
        "document": "document",
        "document_picker": "document",
        "document_renderer": "document",
        "skins": "skins",
    }.get(module)


def _bridge_gallery_module_props(
    module: str | None,
    raw_props: Mapping[str, Any],
) -> dict[str, Any]:
    bridged = dict(raw_props)
    if module:
        bridged["module"] = module

    def actions_list() -> list[dict[str, Any]]:
        raw = bridged.get("actions", bridged.get("toolbar_actions"))
        if not isinstance(raw, list):
            return []
        out: list[dict[str, Any]] = []
        for entry in raw:
            if isinstance(entry, Mapping):
                out.append(dict(entry))
        return out

    def ensure_action(
        *,
        action_id: str,
        label: str,
        icon: str | None = None,
        variant: str = "text",
    ) -> None:
        current = actions_list()
        for action in current:
            existing_id = action.get("id")
            existing_label = action.get("label", action.get("text"))
            if existing_id == action_id or existing_label == label:
                bridged["actions"] = current
                return
        next_action: dict[str, Any] = {"id": action_id, "label": label, "variant": variant}
        if icon:
            next_action["icon"] = icon
        current.append(next_action)
        bridged["actions"] = current

    if module is None:
        return bridged

    if module == "grid_layout":
        bridged.setdefault("layout", GalleryLayoutType.GRID)
    elif module == "item_tile":
        bridged.setdefault("layout", GalleryLayoutType.GRID)
        bridged.setdefault("item_style", "card")
    elif module == "item_preview":
        bridged.setdefault("show_meta", False)
        bridged.setdefault("show_actions", False)
    elif module == "item_actions":
        bridged.setdefault("show_actions", True)
    elif module in {"item_meta_row", "item_badge", "section_header"}:
        bridged.setdefault("show_meta", True)
    elif module == "item_selectable":
        bridged.setdefault("show_selections", True)
        bridged.setdefault("selection_mode", "single")
    elif module == "item_selection_checkbox":
        bridged.setdefault("show_selections", True)
        bridged.setdefault("selection_mode", "multi")
    elif module in {"item_selection_radio", "item_selection_switch"}:
        bridged.setdefault("show_selections", True)
        bridged.setdefault("selection_mode", "single")
    elif module == "loading_skeleton":
        bridged.setdefault("is_loading", True)
    elif module == "empty_state":
        bridged.setdefault("layout", GalleryLayoutType.GRID)
    elif module == "toolbar":
        bridged.setdefault("show_actions", True)
    elif module == "search_bar":
        ensure_action(action_id="search", label="Search", icon="search")
    elif module == "filter_bar":
        ensure_action(action_id="filter", label="Filter", icon="filter_alt", variant="outlined")
    elif module == "sort_bar":
        ensure_action(action_id="sort", label="Sort", icon="sort", variant="outlined")
    elif module == "pagination":
        bridged.setdefault("show_pagination", True)
    elif module == "item_reorder_handle":
        bridged.setdefault("enable_reorder", True)
    elif module == "item_drag_handle":
        bridged.setdefault("enable_drag", True)
    elif module == "item_drop_target":
        bridged.setdefault("enable_drag", True)
    elif module == "clear":
        ensure_action(action_id="clear", label="Clear", icon="clear", variant="outlined")
    elif module == "select_all":
        ensure_action(action_id="select_all", label="Select all", icon="done_all", variant="outlined")
        bridged.setdefault("selection_mode", "multi")
        bridged.setdefault("show_selections", True)
    elif module == "deselect_all":
        ensure_action(
            action_id="deselect_all",
            label="Deselect all",
            icon="remove_done",
            variant="outlined",
        )
        bridged.setdefault("selection_mode", "multi")
        bridged.setdefault("show_selections", True)
    elif module == "apply":
        ensure_action(action_id="apply", label="Apply", icon="check", variant="filled")
    elif module == "apply_font":
        ensure_action(action_id="apply_font", label="Apply font", icon="font_download", variant="filled")
        bridged.setdefault("type_filter", "font")
    elif module == "apply_image":
        ensure_action(action_id="apply_image", label="Apply image", icon="image", variant="filled")
        bridged.setdefault("type_filter", "image")
    elif module == "set_as_wallpaper":
        ensure_action(
            action_id="set_as_wallpaper",
            label="Set wallpaper",
            icon="wallpaper",
            variant="filled",
        )
        bridged.setdefault("type_filter", "image")
    elif module == "presets":
        bridged.setdefault("layout", GalleryLayoutType.LIST)
    elif module == "skins":
        bridged.setdefault("layout", GalleryLayoutType.GRID)

    layout_from_module = _resolve_layout_from_module(module)
    if layout_from_module is not None:
        bridged.setdefault("layout", layout_from_module)
    type_filter = _resolve_type_filter_from_module(module)
    if type_filter is not None:
        bridged.setdefault("type_filter", type_filter)

    return bridged


@dataclass
class GalleryItem:
    """
    Serializable item model for ``Gallery``.

    Each instance represents one media/entity row in the gallery payload.
    The runtime consumes the JSON keys produced by ``to_json``.

    Key fields:
    - identity: ``id``, ``name``, ``type``
    - media: ``url``, ``thumbnail_url``
    - metadata: ``subtitle``, ``description``, ``tags``, ``status``
    - social/meta: ``like_count``, ``view_count``, ``author_name``
    - runtime state: ``is_selected``, ``is_loading``

    Use ``from_dict`` to safely coerce mixed snake_case/camelCase sources.
    """

    id: str
    name: str | None = None
    path: str | None = None
    url: str | None = None
    thumbnail_url: str | None = None
    type: str = "image"
    metadata: dict[str, Any] | None = None
    is_selected: bool = False
    is_loading: bool = False
    subtitle: str | None = None
    description: str | None = None
    author_name: str | None = None
    author_avatar: str | None = None
    like_count: int | None = None
    view_count: int | None = None
    created_at: str | None = None
    aspect_ratio: float | None = None
    tags: list[str] | None = None
    status: str | None = None

    def to_json(self) -> dict[str, Any]:
        result: dict[str, Any] = {"id": self.id}
        if self.name is not None:
            result["name"] = self.name
        if self.path is not None:
            result["path"] = self.path
        if self.url is not None:
            result["url"] = self.url
        if self.thumbnail_url is not None:
            result["thumbnailUrl"] = self.thumbnail_url
        if self.type:
            result["type"] = self.type
        if self.metadata is not None:
            result["metadata"] = self.metadata
        if self.is_selected:
            result["isSelected"] = self.is_selected
        if self.is_loading:
            result["isLoading"] = self.is_loading
        if self.subtitle is not None:
            result["subtitle"] = self.subtitle
        if self.description is not None:
            result["description"] = self.description
        if self.author_name is not None:
            result["authorName"] = self.author_name
        if self.author_avatar is not None:
            result["authorAvatar"] = self.author_avatar
        if self.like_count is not None:
            result["likeCount"] = self.like_count
        if self.view_count is not None:
            result["viewCount"] = self.view_count
        if self.created_at is not None:
            result["createdAt"] = self.created_at
        if self.aspect_ratio is not None:
            result["aspectRatio"] = self.aspect_ratio
        if self.tags is not None:
            result["tags"] = self.tags
        if self.status is not None:
            result["status"] = self.status
        return result

    @staticmethod
    def from_dict(data: Mapping[str, Any]) -> "GalleryItem":
        def pick(*keys: str) -> Any:
            for key in keys:
                if key in data:
                    return data[key]
            return None

        def as_int(value: Any) -> int | None:
            if value is None:
                return None
            try:
                return int(value)
            except Exception:
                return None

        def as_float(value: Any) -> float | None:
            if value is None:
                return None
            try:
                return float(value)
            except Exception:
                return None

        raw_id = pick("id")
        return GalleryItem(
            id="" if raw_id is None else str(raw_id),
            name=pick("name"),
            path=pick("path"),
            url=pick("url"),
            thumbnail_url=pick("thumbnailUrl", "thumbnail_url"),
            type=pick("type") or "image",
            metadata=pick("metadata"),
            is_selected=bool(pick("isSelected", "is_selected") or False),
            is_loading=bool(pick("isLoading", "is_loading") or False),
            subtitle=pick("subtitle"),
            description=pick("description"),
            author_name=pick("authorName", "author_name"),
            author_avatar=pick("authorAvatar", "author_avatar"),
            like_count=as_int(pick("likeCount", "like_count")),
            view_count=as_int(pick("viewCount", "view_count")),
            created_at=pick("createdAt", "created_at"),
            aspect_ratio=as_float(pick("aspectRatio", "aspect_ratio")),
            tags=pick("tags"),
            status=pick("status"),
        ) 


_MEDIA_TYPE_EXTENSIONS: dict[str, set[str]] = {
    "image": {".png", ".jpg", ".jpeg", ".gif", ".webp", ".bmp", ".svg", ".tif", ".tiff"},
    "video": {".mp4", ".mov", ".avi", ".mkv", ".webm", ".m4v"},
    "audio": {".mp3", ".wav", ".aac", ".ogg", ".flac", ".m4a"},
    "document": {
        ".pdf",
        ".doc",
        ".docx",
        ".txt",
        ".rtf",
        ".odt",
        ".md",
        ".csv",
        ".xls",
        ".xlsx",
        ".ppt",
        ".pptx",
        ".json",
        ".yaml",
        ".yml",
    },
    "font": {".ttf", ".otf", ".woff", ".woff2"},
}


def _normalize_media_type(value: Any | None) -> str:
    token = _normalize_gallery_token(value)
    if not token:
        return "document"
    aliases = {
        "img": "image",
        "photo": "image",
        "pics": "image",
        "vid": "video",
        "music": "audio",
        "sound": "audio",
        "doc": "document",
        "file": "document",
        "fonts": "font",
    }
    return aliases.get(token, token)


def _infer_media_type(path: Path, explicit_type: Any | None = None) -> str:
    if explicit_type is not None:
        return _normalize_media_type(explicit_type)

    suffix = path.suffix.lower()
    for media_type, extensions in _MEDIA_TYPE_EXTENSIONS.items():
        if suffix in extensions:
            return media_type

    mime_type, _ = mimetypes.guess_type(str(path))
    if isinstance(mime_type, str):
        if mime_type.startswith("image/"):
            return "image"
        if mime_type.startswith("video/"):
            return "video"
        if mime_type.startswith("audio/"):
            return "audio"
        if "font" in mime_type:
            return "font"
    return "document"


def _coerce_existing_path(value: str | Path | None) -> Path | None:
    if value is None:
        return None
    candidate = Path(value).expanduser()
    if candidate.exists():
        try:
            return candidate.resolve()
        except Exception:
            return candidate
    return None


def _file_timestamp(value: float | int | None) -> str | None:
    if value is None:
        return None
    try:
        dt = datetime.fromtimestamp(float(value), tz=timezone.utc)
    except Exception:
        return None
    return dt.isoformat().replace("+00:00", "Z")


def gallery_item_from_file(
    path: str | Path,
    *,
    thumbnail: str | Path | None = None,
    type: str | None = None,
    name: str | None = None,
    metadata: Mapping[str, Any] | None = None,
    tags: Iterable[str] | None = None,
    status: str | None = None,
    author_name: str | None = None,
    subtitle: str | None = None,
    aspect_ratio: float | None = None,
) -> GalleryItem:
    """
    Build a ``GalleryItem`` from a local filesystem path.

    The resulting item includes local ``path`` and also sets ``url`` to the same
    path so Flutter-side media preview controls can consume it directly.
    """

    raw_path = Path(path).expanduser()
    resolved_path = _coerce_existing_path(raw_path) or raw_path
    media_type = _infer_media_type(resolved_path, explicit_type=type)

    thumbnail_path = _coerce_existing_path(thumbnail)
    source = str(resolved_path)
    thumb = str(thumbnail_path) if thumbnail_path is not None else None
    if media_type == "image" and thumb is None:
        thumb = source

    file_metadata: dict[str, Any] = {}
    try:
        stat = resolved_path.stat()
        file_metadata = {
            "bytes": int(stat.st_size),
            "extension": resolved_path.suffix.lower(),
            "created_at": _file_timestamp(stat.st_ctime),
            "modified_at": _file_timestamp(stat.st_mtime),
        }
    except Exception:
        file_metadata = {"extension": resolved_path.suffix.lower()}

    if media_type == "font":
        # Best-effort font family hint from filename for font preview tiles.
        file_metadata.setdefault("font_family", (name or resolved_path.stem).replace("_", " "))
    if aspect_ratio is not None:
        file_metadata["aspect_ratio"] = float(aspect_ratio)

    if metadata:
        file_metadata.update(dict(metadata))

    return GalleryItem(
        id=str(resolved_path),
        name=name or resolved_path.stem,
        path=source,
        url=source,
        thumbnail_url=thumb,
        type=media_type,
        metadata=file_metadata,
        subtitle=subtitle or resolved_path.suffix.lower().lstrip("."),
        author_name=author_name,
        created_at=file_metadata.get("modified_at"),
        aspect_ratio=aspect_ratio,
        tags=list(tags) if tags is not None else None,
        status=status,
    )


def gallery_items_from_paths(
    paths: Iterable[str | Path],
    *,
    type: str | None = None,
    thumbnails: Mapping[str, str | Path] | None = None,
    recursive: bool = True,
    include_hidden: bool = False,
    allowed_types: Iterable[str] | None = None,
) -> list[GalleryItem]:
    """
    Convert files/directories into ``GalleryItem`` records.

    Directories are expanded to files (recursively by default).
    """

    allowed_type_set = (
        {_normalize_media_type(value) for value in allowed_types}
        if allowed_types is not None
        else None
    )
    thumbnail_map = dict(thumbnails or {})

    discovered_files: list[Path] = []
    for raw in paths:
        candidate = Path(raw).expanduser()
        resolved = _coerce_existing_path(candidate) or candidate
        if resolved.is_dir():
            iterator = resolved.rglob("*") if recursive else resolved.glob("*")
            for child in iterator:
                if not child.is_file():
                    continue
                if not include_hidden and child.name.startswith("."):
                    continue
                discovered_files.append(child)
            continue
        if resolved.is_file() or not resolved.exists():
            if include_hidden or not resolved.name.startswith("."):
                discovered_files.append(resolved)

    items: list[GalleryItem] = []
    for file_path in discovered_files:
        lookup_key = str(file_path)
        key_candidates = {
            lookup_key,
            lookup_key.lower(),
            str(file_path.name),
            str(file_path.name).lower(),
            lookup_key.replace("\\", "/"),
            lookup_key.replace("\\", "/").lower(),
        }
        try:
            resolved = str(file_path.resolve())
            key_candidates.add(resolved)
            key_candidates.add(resolved.lower())
            normalized_resolved = resolved.replace("\\", "/")
            key_candidates.add(normalized_resolved)
            key_candidates.add(normalized_resolved.lower())
        except Exception:
            pass
        matched_thumbnail = None
        for candidate in key_candidates:
            if candidate in thumbnail_map:
                matched_thumbnail = thumbnail_map[candidate]
                break
        item = gallery_item_from_file(
            file_path,
            type=type,
            thumbnail=matched_thumbnail,
        )
        if allowed_type_set is not None and _normalize_media_type(item.type) not in allowed_type_set:
            continue
        items.append(item)
    return items


def scan_gallery_directory(
    directory: str | Path,
    *,
    recursive: bool = True,
    include_hidden: bool = False,
    allowed_types: Iterable[str] | None = None,
) -> list[GalleryItem]:
    """Scan a directory and return discovered media as ``GalleryItem`` entries."""

    return gallery_items_from_paths(
        [directory],
        recursive=recursive,
        include_hidden=include_hidden,
        allowed_types=allowed_types,
    )


def discover_installed_font_paths(
    *,
    include_user_fonts: bool = True,
    extra_dirs: Iterable[str | Path] | None = None,
    recursive: bool = True,
) -> list[Path]:
    """
    Discover font file paths from common system and user font directories.
    """

    candidates: list[Path] = []
    platform = sys.platform.lower()
    home = Path.home()

    if platform.startswith("win"):
        candidates.append(Path("C:/Windows/Fonts"))
        if include_user_fonts:
            candidates.append(home / "AppData/Local/Microsoft/Windows/Fonts")
    elif platform == "darwin":
        candidates.extend([Path("/System/Library/Fonts"), Path("/Library/Fonts")])
        if include_user_fonts:
            candidates.append(home / "Library/Fonts")
    else:
        candidates.extend([Path("/usr/share/fonts"), Path("/usr/local/share/fonts")])
        if include_user_fonts:
            candidates.extend([home / ".fonts", home / ".local/share/fonts"])

    if extra_dirs is not None:
        candidates.extend(Path(value).expanduser() for value in extra_dirs)

    discovered: list[Path] = []
    seen: set[str] = set()
    for folder in candidates:
        resolved = _coerce_existing_path(folder)
        if resolved is None or not resolved.is_dir():
            continue
        iterator = resolved.rglob("*") if recursive else resolved.glob("*")
        for path in iterator:
            if not path.is_file():
                continue
            if path.suffix.lower() not in _MEDIA_TYPE_EXTENSIONS["font"]:
                continue
            key = str(path).lower()
            if key in seen:
                continue
            seen.add(key)
            discovered.append(path)
    return discovered


def gallery_font_items_from_system(
    *,
    include_user_fonts: bool = True,
    extra_dirs: Iterable[str | Path] | None = None,
    recursive: bool = True,
    thumbnails: Mapping[str, str | Path] | None = None,
) -> list[GalleryItem]:
    """Return ``GalleryItem`` entries for installed local font files."""

    font_paths = discover_installed_font_paths(
        include_user_fonts=include_user_fonts,
        extra_dirs=extra_dirs,
        recursive=recursive,
    )
    return gallery_items_from_paths(
        font_paths,
        type="font",
        thumbnails=thumbnails,
        recursive=False,
    )


def gallery_local_media(
    paths: Iterable[str | Path],
    *,
    layout: str | None = GalleryLayoutType.GRID,
    module: str | None = None,
    allowed_types: Iterable[str] | None = None,
    recursive: bool = True,
    include_hidden: bool = False,
    thumbnails: Mapping[str, str | Path] | None = None,
    **kwargs: Any,
) -> Gallery:
    """
    Build a ``Gallery`` from local filesystem paths.
    """

    items = gallery_items_from_paths(
        paths,
        thumbnails=thumbnails,
        recursive=recursive,
        include_hidden=include_hidden,
        allowed_types=allowed_types,
    )
    return Gallery(items=items, layout=layout, module=module, **kwargs)


def _gallery_local_by_type(
    paths: Iterable[str | Path],
    *,
    media_type: str,
    layout: str | None,
    module: str | None,
    **kwargs: Any,
) -> Gallery:
    allowed = {_normalize_media_type(media_type)}
    return gallery_local_media(
        paths,
        layout=layout,
        module=module,
        allowed_types=allowed,
        **kwargs,
    )


def gallery_local_images(paths: Iterable[str | Path], *, layout: str | None = GalleryLayoutType.GRID, **kwargs: Any) -> Gallery:
    return _gallery_local_by_type(paths, media_type="image", layout=layout, module="image", **kwargs)


def gallery_local_videos(paths: Iterable[str | Path], *, layout: str | None = GalleryLayoutType.GRID, **kwargs: Any) -> Gallery:
    return _gallery_local_by_type(paths, media_type="video", layout=layout, module="video", **kwargs)


def gallery_local_audio(paths: Iterable[str | Path], *, layout: str | None = GalleryLayoutType.LIST, **kwargs: Any) -> Gallery:
    return _gallery_local_by_type(paths, media_type="audio", layout=layout, module="audio", **kwargs)


def gallery_local_documents(paths: Iterable[str | Path], *, layout: str | None = GalleryLayoutType.LIST, **kwargs: Any) -> Gallery:
    return _gallery_local_by_type(paths, media_type="document", layout=layout, module="document", **kwargs)


def gallery_local_fonts(
    paths: Iterable[str | Path] | None = None,
    *,
    include_system_fonts: bool = True,
    include_user_fonts: bool = True,
    extra_dirs: Iterable[str | Path] | None = None,
    thumbnails: Mapping[str, str | Path] | None = None,
    layout: str | None = GalleryLayoutType.LIST,
    **kwargs: Any,
) -> Gallery:
    """
    Build a font-focused gallery from explicit font paths and/or discovered
    installed fonts.
    """

    font_items: list[GalleryItem] = []
    if include_system_fonts:
        font_items.extend(
            gallery_font_items_from_system(
                include_user_fonts=include_user_fonts,
                extra_dirs=extra_dirs,
                thumbnails=thumbnails,
            )
        )
    if paths is not None:
        font_items.extend(
            gallery_items_from_paths(
                paths,
                type="font",
                thumbnails=thumbnails,
                recursive=True,
            )
        )

    deduped: list[GalleryItem] = []
    seen: set[str] = set()
    for item in font_items:
        key = str(item.id).lower()
        if key in seen:
            continue
        seen.add(key)
        deduped.append(item)

    return Gallery(items=deduped, layout=layout, module="fonts", type_filter="font", **kwargs)


class GalleryScope(Component):
    """
    Scope wrapper for gallery-level configuration.

    ``GalleryScope`` is a lightweight container for wrapping one or more
    ``Gallery`` nodes with shared props. It currently behaves as a pass-through
    container and keeps room for future scoped gallery state.
    """


    control_type = "gallery_scope"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, **kwargs)
        super().__init__(*children, child=child, props=merged, style=style, strict=strict)


class Gallery(Component):
    """
    Umbrella Gallery control for asset browsing and selection.

    ``Gallery`` renders a collection of ``GalleryItem`` entries using a selected
    layout and optional module-specific behavior.

    Core behavior:
    - accepts ``GalleryItem`` instances or raw mappings in ``items``
    - normalizes module/layout aliases before serialization
    - bridges umbrella module names to practical runtime defaults
    - forwards unknown ``**kwargs`` so new runtime props remain usable

    Examples of bridged module behavior:
    - ``filter`` -> ``filter_bar`` and auto-add filter toolbar action
    - ``apply_font`` sets ``type_filter="font"`` and injects an apply action
    - ``select_all`` enables multi-selection defaults and action wiring

    Use convenience helpers ``gallery_grid``, ``gallery_masonry``,
    ``gallery_list``, ``gallery_carousel``, ``gallery_virtual_grid``, and
    ``gallery_virtual_list`` for common layout presets.

    Args:
        items:
            Iterable of ``GalleryItem`` or mapping objects.
        module:
            Optional umbrella module selector.
        layout:
            Layout mode string.
        type_filter:
            Optional media type filter such as ``"image"`` or ``"font"``.
        columns:
            Grid/virtual-grid column count.
        spacing:
            Base item spacing.
        main_axis_spacing:
            Main-axis spacing override.
        cross_axis_spacing:
            Cross-axis spacing override.
        events:
            Runtime event names to emit to Python.
        **kwargs:
            Additional runtime props forwarded as-is.
    """


    control_type = "gallery"

    def __init__(
        self,
        *,
        items: Iterable[GalleryItem | Mapping[str, Any]] | None = None,
        module: str | None = None,
        layout: str | None = None,
        type_filter: str | None = None,
        columns: int | None = None,
        spacing: float | None = None,
        main_axis_spacing: float | None = None,
        cross_axis_spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        extra_kwargs = dict(kwargs)
        raw_module: Any | None = module
        if raw_module is None:
            raw_module = extra_kwargs.pop("module", None)
        raw_type_filter: Any | None = type_filter
        if raw_type_filter is None:
            raw_type_filter = extra_kwargs.pop("type_filter", None)
        if raw_module is None and isinstance(props, Mapping):
            raw_module = props.get("module")
        if raw_type_filter is None and isinstance(props, Mapping):
            raw_type_filter = props.get("type_filter")

        resolved_module = _normalize_gallery_module(raw_module)
        resolved_layout = _normalize_gallery_layout(layout)
        resolved_type_filter = _normalize_gallery_token(raw_type_filter) or None

        resolved_items: list[dict[str, Any]] | None = None
        if items is not None:
            resolved_items = []
            for item in items:
                if isinstance(item, GalleryItem):
                    resolved_items.append(item.to_json())
                elif isinstance(item, Mapping):
                    mapped = dict(item)
                    if (
                        "id" in mapped
                        or "url" in mapped
                        or "thumbnailUrl" in mapped
                        or "thumbnail_url" in mapped
                    ):
                        resolved_items.append(GalleryItem.from_dict(mapped).to_json())
                    else:
                        resolved_items.append(mapped)
        merged = merge_props(
            props,
            items=resolved_items,
            module=resolved_module,
            layout=resolved_layout,
            type_filter=resolved_type_filter,
            columns=columns,
            spacing=spacing,
            main_axis_spacing=main_axis_spacing,
            cross_axis_spacing=cross_axis_spacing,
            events=events,
            **extra_kwargs,
        )
        bridged = _bridge_gallery_module_props(resolved_module, merged)
        super().__init__(props=bridged, style=style, strict=strict)


def gallery_grid(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.GRID, **kwargs)


def gallery_masonry(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.MASONRY, **kwargs)


def gallery_list(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.LIST, **kwargs)


def gallery_carousel(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.CAROUSEL, **kwargs)


def gallery_virtual_grid(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.VIRTUAL_GRID, **kwargs)


def gallery_virtual_list(*, items: Iterable[GalleryItem | Mapping[str, Any]] | None = None, **kwargs: Any) -> Gallery:
    return Gallery(items=items, layout=GalleryLayoutType.VIRTUAL_LIST, **kwargs)
