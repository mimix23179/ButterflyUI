from __future__ import annotations

from dataclasses import dataclass
from collections.abc import Iterable, Mapping
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
]


class GalleryLayoutType:
    """
    Enumeration of supported ``Gallery`` layout modes.

    Class attributes map layout names to the string constants consumed by
    the Flutter runtime:

    * ``GRID`` — fixed-column image/media grid.
    * ``MASONRY`` — variable-height masonry grid.
    * ``LIST`` — single-column list with metadata rows.
    * ``CAROUSEL`` — full-width horizontally scrolling carousel.
    * ``VIRTUAL_GRID`` — virtualised grid for large item counts.
    * ``VIRTUAL_LIST`` — virtualised list for large item counts.

    Use ``GalleryLayoutType.all()`` to get a list of all valid values.
    Pass the string constants directly to ``Gallery(layout=...)``.

    ```python
    import butterflyui as bui

    bui.Gallery(layout=bui.GalleryLayoutType.MASONRY, items=[...])
    # equivalent to
    bui.gallery_masonry(items=[...])
    ```
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


@dataclass
class GalleryItem:
    """
    Data container representing a single item in a ``Gallery``.

    Fields map directly to the JSON payload consumed by the Flutter gallery
    renderer. ``id`` is mandatory. ``url`` / ``thumbnail_url`` control what
    image or media is displayed. ``type`` hints the renderer:
    ``"image"`` (default), ``"video"``, ``"audio"``, ``"document"``,
    ``"font"``, or ``"folder"``.

    Social metadata (``like_count``, ``view_count``, ``author_name``,
    ``author_avatar``, ``created_at``) is rendered when ``show_meta`` /
    ``show_actions`` are enabled on the parent ``Gallery``.
    ``is_selected`` / ``is_loading`` reflect transient display states.

    Construct directly or via ``GalleryItem.from_dict(mapping)``.

    ```python
    import butterflyui as bui

    item = bui.GalleryItem(
        id="img-1",
        url="https://picsum.photos/400",
        name="Sunset",
        type="image",
        like_count=42,
    )
    ```
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
        return GalleryItem(
            id=str(data.get("id", "")),
            name=data.get("name"),
            path=data.get("path"),
            url=data.get("url"),
            thumbnail_url=data.get("thumbnailUrl") or data.get("thumbnail_url"),
            type=data.get("type") or "image",
            metadata=data.get("metadata"),
            is_selected=bool(data.get("isSelected") or data.get("is_selected") or False),
            is_loading=bool(data.get("isLoading") or data.get("is_loading") or False),
            subtitle=data.get("subtitle"),
            description=data.get("description"),
            author_name=data.get("authorName") or data.get("author_name"),
            author_avatar=data.get("authorAvatar") or data.get("author_avatar"),
            like_count=data.get("likeCount") or data.get("like_count"),
            view_count=data.get("viewCount") or data.get("view_count"),
            created_at=data.get("createdAt") or data.get("created_at"),
            aspect_ratio=data.get("aspectRatio") or data.get("aspect_ratio"),
            tags=data.get("tags"),
            status=data.get("status"),
        )


class GalleryScope(Component):
    """
    Scope wrapper that provides ambient Gallery theming context to its children.

    Currently acts as a transparent pass-through container. Future versions
    will provide shared selection state and theming tokens to nested
    ``Gallery`` controls. No meaningful init parameters beyond child widgets
    and layout props forwarded via keyword arguments.

    ```python
    import butterflyui as bui

    bui.GalleryScope(
        bui.Gallery(
            items=[bui.GalleryItem(id="1", url="https://picsum.photos/400")],
            layout="grid",
        )
    )
    ```
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
    Media gallery control supporting grid, masonry, list, carousel, and virtual layouts.

    The runtime renders a scrollable collection of ``GalleryItem`` objects
    in the style selected by ``layout``. ``items`` accepts sequences of
    ``GalleryItem`` dataclass instances or raw dict mappings. Each item
    can carry an image URL, thumbnail, metadata, and social counters.

    Additional Dart-side props can be forwarded as keyword arguments:
    ``item_border_radius``, ``show_selections``, ``show_actions``,
    ``show_meta``, ``selection_mode`` (``"none"``, ``"single"``,
    ``"multi"``), ``item_style`` (``"card"``, ``"compact"``),
    ``enable_reorder``, ``enable_drag``, ``shrink_wrap``,
    ``physics``, and ``actions`` (toolbar action specs).

    Convenience factories ``gallery_grid``, ``gallery_masonry``,
    ``gallery_list``, ``gallery_carousel``, ``gallery_virtual_grid``, and
    ``gallery_virtual_list`` pre-set the ``layout`` prop.

    ```python
    import butterflyui as bui

    bui.Gallery(
        items=[
            bui.GalleryItem(id="1", url="https://picsum.photos/400", name="Sunset"),
            bui.GalleryItem(id="2", url="https://picsum.photos/401", name="Forest"),
        ],
        layout="grid",
        columns=3,
        spacing=8,
        events=["select", "open"],
    )
    ```

    Args:
        items:
            List of ``GalleryItem`` instances or raw dict mappings to display.
        layout:
            Display layout. Values: ``"grid"``, ``"masonry"``, ``"list"``,
            ``"carousel"``, ``"virtual_grid"``, ``"virtual_list"``.
            Defaults to ``"grid"``.
        columns:
            Number of columns for grid and virtual-grid layouts. Defaults
            to ``3``.
        spacing:
            Uniform gap in logical pixels between items; also used as
            ``main_axis_spacing`` fallback.
        main_axis_spacing:
            Gap along the main scroll axis (vertical for grids).
        cross_axis_spacing:
            Gap along the cross axis (horizontal for grids).
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "gallery"

    def __init__(
        self,
        *,
        items: Iterable[GalleryItem | Mapping[str, Any]] | None = None,
        layout: str | None = None,
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
        resolved_items: list[dict[str, Any]] | None = None
        if items is not None:
            resolved_items = []
            for item in items:
                if isinstance(item, GalleryItem):
                    resolved_items.append(item.to_json())
                elif isinstance(item, Mapping):
                    resolved_items.append(dict(item))
        merged = merge_props(
            props,
            items=resolved_items,
            layout=layout,
            columns=columns,
            spacing=spacing,
            main_axis_spacing=main_axis_spacing,
            cross_axis_spacing=cross_axis_spacing,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


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
