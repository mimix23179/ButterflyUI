from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ._shared import Component, collect_children, merge_props

__all__ = [
    "ALIAS_CONTROL_CLASSES",
    "ALIAS_CONTROL_EXPORTS",
]


class _AliasControl(Component):
    control_type = ""

    def __init__(
        self,
        *children: Any,
        child: Any | None = None,
        children_items: Iterable[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, **kwargs)
        resolved_children = collect_children(
            children,
            child=child,
            children=children_items,
        )
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


def _class_name(control_type: str) -> str:
    return "".join(part.capitalize() for part in control_type.split("_"))


_ALIAS_CONTROL_TYPES = (
    "code",
    "command_search",
    "diagnostics_panel",
    "diff",
    "dock",
    "dock_pane",
    "document_tab_strip",
    "editor_tabs",
    "empty_state_view",
    "explorer_tree",
    "ide",
    "log_panel",
    "log_viewer",
    "native_preview_host",
    "outline_view",
    "problem_screen",
    "rte",
    "selection_tools",
    "semantic_search",
    "smart_search_bar",
    "studio_actions_editor",
    "studio_asset_browser",
    "studio_bindings_editor",
    "studio_block_palette",
    "studio_builder",
    "studio_canvas",
    "studio_component_palette",
    "studio_inspector",
    "studio_outline_tree",
    "studio_project_panel",
    "studio_properties_panel",
    "studio_responsive_toolbar",
    "studio_tokens_editor",
    "transform_box",
    "tree",
    "webview_adapter",
    "workbench_editor",
    "workspace_explorer",
)

ALIAS_CONTROL_CLASSES: dict[str, type[_AliasControl]] = {}
ALIAS_CONTROL_EXPORTS: list[str] = []

for _control_type in _ALIAS_CONTROL_TYPES:
    _name = _class_name(_control_type)
    _cls = type(
        _name,
        (_AliasControl,),
        {
            "__module__": __name__,
            "__doc__": f"Alias control wrapper for `{_control_type}`.",
            "control_type": _control_type,
        },
    )
    globals()[_name] = _cls
    ALIAS_CONTROL_CLASSES[_name] = _cls
    ALIAS_CONTROL_EXPORTS.append(_name)

__all__.extend(ALIAS_CONTROL_EXPORTS)

