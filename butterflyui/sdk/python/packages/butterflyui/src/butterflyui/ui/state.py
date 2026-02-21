from __future__ import annotations

import asyncio
from dataclasses import dataclass
from typing import Any, Callable, Generic, Optional, TypeVar, TYPE_CHECKING

from .control import Component
from ..runtime import get_current_session

if TYPE_CHECKING:
    from ..app import ButterflyUISession

T = TypeVar("T")
U = TypeVar("U")

__all__ = ["State", "DerivedState", "Signal", "Computed", "effect"]


@dataclass(slots=True)
class _Binding(Generic[T]):
    component: Component
    prop: str
    session: ButterflyUISession | None
    transform: Callable[[T], Any] | None

    def apply(self, value: T) -> None:
        out = self.transform(value) if self.transform is not None else value
        self.component.patch(session=self.session, **{self.prop: out})


class State(Generic[T]):
    """Minimal reactive state helper for ButterflyUI components."""

    def __init__(self, value: T) -> None:
        self._value = value
        self._bindings: list[_Binding[T]] = []
        self._watchers: list[Callable[[T], Any]] = []

    @property
    def value(self) -> T:
        return self._value

    @value.setter
    def value(self, value: T) -> None:
        self.set(value)

    def set(self, value: T) -> None:
        self._value = value
        for binding in list(self._bindings):
            binding.apply(value)
        for watcher in list(self._watchers):
            watcher(value)

    def update(self, fn: Callable[[T], T]) -> None:
        self.set(fn(self._value))

    def bind(
        self,
        component: Component,
        prop: str,
        *,
        session: ButterflyUISession | None = None,
        transform: Callable[[T], Any] | None = None,
        immediate: bool = True,
    ) -> None:
        """Bind a raw prop key (e.g., content_padding) to this state."""
        resolved = session or get_current_session()
        binding = _Binding(component=component, prop=str(prop), session=resolved, transform=transform)
        self._bindings.append(binding)
        if immediate:
            binding.apply(self._value)

    def bind_to(
        self,
        component: Component,
        prop: Optional[str] = None,
        *,
        session: ButterflyUISession | None = None,
        transform: Callable[[T], Any] | None = None,
        immediate: bool = True,
    ) -> None:
        """Bind using a default prop for the component type when not specified."""
        resolved_prop = prop or _DEFAULT_PROP.get(component.control_type, "value")
        self.bind(component, resolved_prop, session=session, transform=transform, immediate=immediate)

    def watch(self, handler: Callable[[T], Any]) -> None:
        self._watchers.append(handler)

    def derive(self, transform: Callable[[T], U]) -> "DerivedState[U]":
        return DerivedState(self, transform)

    def effect(
        self,
        handler: Callable[[T], Any],
        *,
        session: ButterflyUISession | None = None,
        immediate: bool = False,
    ) -> Callable[[T], Any]:
        """Run a side-effect when the state changes."""
        resolved = session or get_current_session()

        def _runner(value: T) -> None:
            result = handler(value)
            if asyncio.iscoroutine(result):
                if resolved is not None and hasattr(resolved, "spawn"):
                    resolved.spawn(result)
                else:
                    try:
                        loop = asyncio.get_running_loop()
                    except RuntimeError:
                        loop = None
                    if loop is not None:
                        loop.create_task(result)
                    else:
                        asyncio.run(result)

        self.watch(_runner)
        if immediate:
            _runner(self._value)
        return handler


class DerivedState(State[U]):
    """Read-only state derived from another State."""

    def __init__(self, source: State[T], transform: Callable[[T], U]) -> None:
        self._source = source
        self._transform = transform
        super().__init__(transform(source.value))
        self._source.watch(self._on_source_change)

    def _on_source_change(self, value: T) -> None:
        super().set(self._transform(value))

    def set(self, value: U) -> None:
        raise RuntimeError("DerivedState is read-only")


class Signal(State[T]):
    """Alias for State to align with signal terminology."""


class Computed(DerivedState[U]):
    """Alias for DerivedState to align with computed terminology."""


def effect(state: State[T], handler: Callable[[T], Any], *, session: ButterflyUISession | None = None, immediate: bool = False) -> None:
    """Module-level helper to register a side-effect."""
    state.effect(handler, session=session, immediate=immediate)


_DEFAULT_PROP: dict[str, str] = {
    "text": "text",
    "markdown": "value",
    "markdown_view": "value",
    "html": "html",
    "html_view": "html",
    "code": "value",
    "code_block": "value",
    "json_view": "value",
    "progress": "value",
    "text_field": "value",
    "text_area": "value",
    "search_box": "value",
    "path_field": "value",
    "checkbox": "value",
    "switch": "value",
    "slider": "value",
    "numeric_field": "value",
    "select": "value",
    "radio": "value",
    "check_list": "values",
    "multi_pick": "values",
    "tabs": "index",
    "view_stack": "index",
    "image": "src",
    "gallery": "images",
    "audio": "src",
    "video": "src",
    "table": "rows",
    "message_composer": "value",
    "file_picker": "files",
    "log_viewer": "entries",
    "code_buffer": "text",
    "code_document": "text",
    "editor_view": "text",
    "editor_surface": "text",
    "multi_cursor_controller": "cursors",
    "syntax_layer": "tokens",
    "fold_layer": "ranges",
    "semantic_layer": "items",
    "code_category_layer": "items",
    "ownership_marker": "items",
    "virtual_file_system": "nodes",
    "editor_intent_router": "shortcuts",
    "focus_mode_controller": "enabled",
    "control_preset": "props",
    "behavior_mixins": "mixins",
    "gutter": "line_count",
    "symbol_tree": "nodes",
    "outline_view": "nodes",
    "breadcrumb_bar": "items",
    "status_bar": "items",
    "command_palette": "commands",
    "diagnostic_stream": "entries",
    "execution_lane": "entries",
    "preview_surface": "status",
    "native_preview_host": "process_id",
    "state_snapshot": "snapshots",
    "hot_reload_boundary": "enabled",
    "semantic_search": "query",
    "scoped_search_replace": "query",
    "intent_router": "intents",
    "preview_intent_interceptor": "intents",
    "preview_presets": "presets",
    "layout_freeze": "enabled",
    "time_travel_lite": "steps",
    "live_control_picker": "active",
    "preview_error_overlay": "visible",
    "search_everything_panel": "query",
    "state_inspector": "value",
    "intent_panel": "intents",
}
