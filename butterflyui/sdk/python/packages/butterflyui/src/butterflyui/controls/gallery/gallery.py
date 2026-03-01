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
