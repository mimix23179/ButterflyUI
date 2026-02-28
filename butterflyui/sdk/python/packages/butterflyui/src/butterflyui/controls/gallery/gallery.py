"""
Gallery Control - A unified gallery control for displaying media items.

Gallery is a control that uses various existing components from ButterflyUI
to let users build gallery views for their programs. Users can create
different gallery layouts like grid, masonry, list, carousel, virtualGrid, virtualList.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Optional, Iterable, Mapping, List

from ...core import Control


# ============================================================================
# Gallery Layout Types
# ============================================================================

class GalleryLayoutType:
    """Gallery layout type enumeration."""
    GRID = "grid"
    MASONRY = "masonry"
    LIST = "list"
    CAROUSEL = "carousel"
    VIRTUAL_GRID = "virtual_grid"
    VIRTUAL_LIST = "virtual_list"

    @staticmethod
    def all() -> List[str]:
        return [
            GalleryLayoutType.GRID,
            GalleryLayoutType.MASONRY,
            GalleryLayoutType.LIST,
            GalleryLayoutType.CAROUSEL,
            GalleryLayoutType.VIRTUAL_GRID,
            GalleryLayoutType.VIRTUAL_LIST,
        ]


# ============================================================================
# Gallery Item Model
# ============================================================================

@dataclass
class GalleryItem:
    """Gallery item model for displaying media in gallery views."""
    id: str
    name: Optional[str] = None
    path: Optional[str] = None
    url: Optional[str] = None
    thumbnail_url: Optional[str] = None
    type: str = "image"
    metadata: Optional[dict[str, Any]] = None
    is_selected: bool = False
    is_loading: bool = False
    subtitle: Optional[str] = None
    description: Optional[str] = None
    author_name: Optional[str] = None
    author_avatar: Optional[str] = None
    like_count: Optional[int] = None
    view_count: Optional[int] = None
    created_at: Optional[str] = None
    aspect_ratio: Optional[float] = None
    tags: Optional[List[str]] = None
    status: Optional[str] = None

    def to_dict(self) -> dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        result = {"id": self.id}
        
        if self.name is not None:
            result["name"] = self.name
        if self.path is not None:
            result["path"] = self.path
        if self.url is not None:
            result["url"] = self.url
        if self.thumbnail_url is not None:
            result["thumbnailUrl"] = self.thumbnail_url
        if self.type != "image":
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
    def from_dict(data: dict[str, Any]) -> GalleryItem:
        """Create GalleryItem from dictionary."""
        return GalleryItem(
            id=data.get("id", ""),
            name=data.get("name"),
            path=data.get("path"),
            url=data.get("url"),
            thumbnail_url=data.get("thumbnailUrl") or data.get("thumbnail_url"),
            type=data.get("type", "image"),
            metadata=data.get("metadata"),
            is_selected=data.get("isSelected", False) or data.get("is_selected", False),
            is_loading=data.get("isLoading", False) or data.get("is_loading", False),
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

    def copy_with(
        self,
        id: Optional[str] = None,
        name: Optional[str] = None,
        path: Optional[str] = None,
        url: Optional[str] = None,
        thumbnail_url: Optional[str] = None,
        type: Optional[str] = None,
        metadata: Optional[dict[str, Any]] = None,
        is_selected: Optional[bool] = None,
        is_loading: Optional[bool] = None,
        subtitle: Optional[str] = None,
        description: Optional[str] = None,
        author_name: Optional[str] = None,
        author_avatar: Optional[str] = None,
        like_count: Optional[int] = None,
        view_count: Optional[int] = None,
        created_at: Optional[str] = None,
        aspect_ratio: Optional[float] = None,
        tags: Optional[List[str]] = None,
        status: Optional[str] = None,
    ) -> GalleryItem:
        """Create a copy with updated fields."""
        return GalleryItem(
            id=id if id is not None else self.id,
            name=name if name is not None else self.name,
            path=path if path is not None else self.path,
            url=url if url is not None else self.url,
            thumbnail_url=thumbnail_url if thumbnail_url is not None else self.thumbnail_url,
            type=type if type is not None else self.type,
            metadata=metadata if metadata is not None else self.metadata,
            is_selected=is_selected if is_selected is not None else self.is_selected,
            is_loading=is_loading if is_loading is not None else self.is_loading,
            subtitle=subtitle if subtitle is not None else self.subtitle,
            description=description if description is not None else self.description,
            author_name=author_name if author_name is not None else self.author_name,
            author_avatar=author_avatar if author_avatar is not None else self.author_avatar,
            like_count=like_count if like_count is not None else self.like_count,
            view_count=view_count if view_count is not None else self.view_count,
            created_at=created_at if created_at is not None else self.created_at,
            aspect_ratio=aspect_ratio if aspect_ratio is not None else self.aspect_ratio,
            tags=tags if tags is not None else self.tags,
            status=status if status is not None else self.status,
        )


# ============================================================================
# Gallery Control
# ============================================================================

@dataclass
class Gallery(Control):
    """
    Gallery is a control that displays media items in various layouts.
    
    Supports layouts: grid, masonry, list, carousel, virtualGrid, virtualList
    
    Example:
        Gallery(
            items=[...],
            layout="grid",
            columns=3,
            spacing=10,
        )
    """
    control_type: str = "gallery"
    
    # Items to display in the gallery
    items: Optional[Iterable[GalleryItem]] = None
    
    # Layout type: grid, masonry, list, carousel, virtual_grid, virtual_list
    layout: str = "grid"
    
    # Number of columns for grid layouts
    columns: Optional[int] = None
    
    # Spacing between items
    spacing: Optional[float] = None
    
    # Main axis spacing
    main_axis_spacing: Optional[float] = None
    
    # Cross axis spacing
    cross_axis_spacing: Optional[float] = None
    
    # Border radius for items
    radius: Optional[float] = None
    
    # Show selection checkbox
    show_selection: bool = False
    
    # Enable multi-select
    multi_select: bool = False
    
    # Show item actions (like, share, etc.)
    show_actions: bool = True
    
    # Show item metadata
    show_meta: bool = True
    
    # Scroll direction
    scroll_direction: str = "vertical"
    
    # Scroll physics (bouncing, clamping, never, always)
    physics: Optional[str] = None
    
    # Whether to shrink wrap the scroll view
    shrink_wrap: Optional[bool] = None
    
    # Children
    children: list[Control] = field(default_factory=list)

    def __init__(
        self,
        *children: Control,
        items: Optional[Iterable[GalleryItem]] = None,
        layout: str = "grid",
        columns: Optional[int] = None,
        spacing: Optional[float] = None,
        main_axis_spacing: Optional[float] = None,
        cross_axis_spacing: Optional[float] = None,
        radius: Optional[float] = None,
        show_selection: bool = False,
        multi_select: bool = False,
        show_actions: bool = True,
        show_meta: bool = True,
        scroll_direction: str = "vertical",
        physics: Optional[str] = None,
        shrink_wrap: Optional[bool] = None,
        children_list: Optional[Iterable[Control]] = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        self.items = items
        self.layout = layout
        self.columns = columns
        self.spacing = spacing
        self.main_axis_spacing = main_axis_spacing
        self.cross_axis_spacing = cross_axis_spacing
        self.radius = radius
        self.show_selection = show_selection
        self.multi_select = multi_select
        self.show_actions = show_actions
        self.show_meta = show_meta
        self.scroll_direction = scroll_direction
        self.physics = physics
        self.shrink_wrap = shrink_wrap

        merged_children = list(children)
        if children_list is not None:
            merged_children.extend(list(children_list))

        super().__init__(
            self.control_type,
            props=props,
            children=merged_children,
            style=style,
            strict=strict,
            **kwargs,
        )
        self.__post_init__()
    
    def __post_init__(self):
        # Convert items to list of dicts
        if self.items is not None:
            items_list = []
            for item in self.items:
                if isinstance(item, GalleryItem):
                    items_list.append(item.to_dict())
                else:
                    items_list.append(item)
            self.props["items"] = items_list
        
        if self.layout:
            self.props["layout"] = self.layout
        if self.columns is not None:
            self.props["columns"] = self.columns
        if self.spacing is not None:
            self.props["spacing"] = self.spacing
        if self.main_axis_spacing is not None:
            self.props["mainAxisSpacing"] = self.main_axis_spacing
        if self.cross_axis_spacing is not None:
            self.props["crossAxisSpacing"] = self.cross_axis_spacing
        if self.radius is not None:
            self.props["radius"] = self.radius
        if self.show_selection:
            self.props["showSelection"] = self.show_selection
        if self.multi_select:
            self.props["multiSelect"] = self.multi_select
        if not self.show_actions:
            self.props["showActions"] = self.show_actions
        if not self.show_meta:
            self.props["showMeta"] = self.show_meta
        if self.scroll_direction != "vertical":
            self.props["scrollDirection"] = self.scroll_direction
        if self.physics:
            self.props["physics"] = self.physics
        if self.shrink_wrap is not None:
            self.props["shrinkWrap"] = self.shrink_wrap
    
    def to_dict(self) -> dict[str, Any]:
        result = super().to_dict()
        # Add children
        if self.children:
            result["children"] = [child.to_dict() for child in self.children]
        return result


# ============================================================================
# GalleryScope Control
# ============================================================================

@dataclass
class GalleryScope(Control):
    """
    GalleryScope is a wrapper control that applies gallery configuration to its children.
    
    Use this to wrap components that should be displayed within a gallery context.
    
    Example:
        GalleryScope(
            layout="grid",
            columns=3,
            children=[...],
        )
    """
    control_type: str = "gallery_scope"
    
    # Layout type
    layout: str = "grid"
    
    # Number of columns
    columns: Optional[int] = None
    
    # Spacing between items
    spacing: Optional[float] = None
    
    # Main axis spacing
    main_axis_spacing: Optional[float] = None
    
    # Cross axis spacing
    cross_axis_spacing: Optional[float] = None
    
    # Border radius
    radius: Optional[float] = None
    
    # Children
    children: list[Control] = field(default_factory=list)

    def __init__(
        self,
        *children: Control,
        layout: str = "grid",
        columns: Optional[int] = None,
        spacing: Optional[float] = None,
        main_axis_spacing: Optional[float] = None,
        cross_axis_spacing: Optional[float] = None,
        radius: Optional[float] = None,
        children_list: Optional[Iterable[Control]] = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        self.layout = layout
        self.columns = columns
        self.spacing = spacing
        self.main_axis_spacing = main_axis_spacing
        self.cross_axis_spacing = cross_axis_spacing
        self.radius = radius

        merged_children = list(children)
        if children_list is not None:
            merged_children.extend(list(children_list))

        super().__init__(
            self.control_type,
            props=props,
            children=merged_children,
            style=style,
            strict=strict,
            **kwargs,
        )
        self.__post_init__()
    
    def __post_init__(self):
        if self.layout:
            self.props["layout"] = self.layout
        if self.columns is not None:
            self.props["columns"] = self.columns
        if self.spacing is not None:
            self.props["spacing"] = self.spacing
        if self.main_axis_spacing is not None:
            self.props["mainAxisSpacing"] = self.main_axis_spacing
        if self.cross_axis_spacing is not None:
            self.props["crossAxisSpacing"] = self.cross_axis_spacing
        if self.radius is not None:
            self.props["radius"] = self.radius
    
    def to_dict(self) -> dict[str, Any]:
        result = super().to_dict()
        # Add children
        if self.children:
            result["children"] = [child.to_dict() for child in self.children]
        return result


# ============================================================================
# Convenience Functions
# ============================================================================

def gallery_grid(
    *children: Control,
    columns: Optional[int] = None,
    spacing: Optional[float] = None,
    radius: Optional[float] = None,
) -> Gallery:
    """Create a grid gallery."""
    return Gallery(
        layout="grid",
        columns=columns,
        spacing=spacing,
        radius=radius,
        children=list(children),
    )


def gallery_masonry(
    *children: Control,
    columns: Optional[int] = None,
    spacing: Optional[float] = None,
) -> Gallery:
    """Create a masonry gallery."""
    return Gallery(
        layout="masonry",
        columns=columns,
        spacing=spacing,
        children=list(children),
    )


def gallery_list(
    *children: Control,
    spacing: Optional[float] = None,
) -> Gallery:
    """Create a list gallery."""
    return Gallery(
        layout="list",
        spacing=spacing,
        children=list(children),
    )


def gallery_carousel(
    *children: Control,
    spacing: Optional[float] = None,
) -> Gallery:
    """Create a carousel gallery."""
    return Gallery(
        layout="carousel",
        spacing=spacing,
        children=list(children),
    )


def gallery_virtual_grid(
    *children: Control,
    columns: Optional[int] = None,
    spacing: Optional[float] = None,
) -> Gallery:
    """Create a virtual grid gallery."""
    return Gallery(
        layout="virtual_grid",
        columns=columns,
        spacing=spacing,
        children=list(children),
    )


def gallery_virtual_list(
    *children: Control,
    spacing: Optional[float] = None,
) -> Gallery:
    """Create a virtual list gallery."""
    return Gallery(
        layout="virtual_list",
        spacing=spacing,
        children=list(children),
    )
