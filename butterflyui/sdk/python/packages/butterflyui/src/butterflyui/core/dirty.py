from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Iterable

__all__ = [
    "DirtyState",
    "DirtyTrackingMixin",
    "DirtyPropsDict",
    "DirtyChildrenList",
]


@dataclass(slots=True)
class DirtyState:
    props: set[str] = field(default_factory=set)
    children: bool = False
    events: bool = False

    def clear(self) -> None:
        self.props.clear()
        self.children = False
        self.events = False


class DirtyTrackingMixin:
    _dirty_state: DirtyState
    _suspend_dirty_tracking: bool

    def mark_dirty(self, name: str) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        if not hasattr(self, "_dirty_state"):
            self._dirty_state = DirtyState()
        self._dirty_state.props.add(str(name))

    def mark_children_dirty(self) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        if not hasattr(self, "_dirty_state"):
            self._dirty_state = DirtyState()
        self._dirty_state.children = True

    def mark_events_dirty(self) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        if not hasattr(self, "_dirty_state"):
            self._dirty_state = DirtyState()
        self._dirty_state.events = True

    def clear_dirty(self) -> None:
        if not hasattr(self, "_dirty_state"):
            self._dirty_state = DirtyState()
        self._dirty_state.clear()

    def dirty_snapshot(self) -> DirtyState:
        if not hasattr(self, "_dirty_state"):
            self._dirty_state = DirtyState()
        state = self._dirty_state
        return DirtyState(props=set(state.props), children=state.children, events=state.events)


class DirtyPropsDict(dict[str, Any]):
    def __init__(self, owner: DirtyTrackingMixin, values: dict[str, Any] | None = None) -> None:
        self._owner = owner
        super().__init__()
        if values:
            super().update(values)

    def _mark(self, keys: Iterable[Any]) -> None:
        for key in keys:
            self._owner.mark_dirty(str(key))

    def __setitem__(self, key: str, value: Any) -> None:
        old = self.get(key, None)
        existed = key in self
        super().__setitem__(key, value)
        if (not existed) or old != value:
            self._mark((key,))

    def __delitem__(self, key: str) -> None:
        super().__delitem__(key)
        self._mark((key,))

    def pop(self, key: str, default: Any = ...):  # type: ignore[override]
        if key in self:
            value = super().pop(key)
            self._mark((key,))
            return value
        if default is ...:
            raise KeyError(key)
        return default

    def popitem(self):  # type: ignore[override]
        key, value = super().popitem()
        self._mark((key,))
        return key, value

    def clear(self) -> None:  # type: ignore[override]
        if not self:
            return
        keys = list(self.keys())
        super().clear()
        self._mark(keys)

    def setdefault(self, key: str, default: Any = None) -> Any:  # type: ignore[override]
        if key in self:
            return self[key]
        super().setdefault(key, default)
        self._mark((key,))
        return self[key]

    def update(self, *args: Any, **kwargs: Any) -> None:  # type: ignore[override]
        values = dict(*args, **kwargs)
        changed: list[str] = []
        for key, value in values.items():
            old = self.get(key, None)
            existed = key in self
            super().__setitem__(key, value)
            if (not existed) or old != value:
                changed.append(str(key))
        if changed:
            self._mark(changed)


class DirtyChildrenList(list[Any]):
    def __init__(self, owner: DirtyTrackingMixin, values: Iterable[Any] | None = None) -> None:
        self._owner = owner
        super().__init__(values or [])

    def _mark(self) -> None:
        self._owner.mark_children_dirty()

    def __setitem__(self, index, value) -> None:  # type: ignore[override]
        super().__setitem__(index, value)
        self._mark()

    def __delitem__(self, index) -> None:  # type: ignore[override]
        super().__delitem__(index)
        self._mark()

    def append(self, value: Any) -> None:  # type: ignore[override]
        super().append(value)
        self._mark()

    def extend(self, values: Iterable[Any]) -> None:  # type: ignore[override]
        values = list(values)
        if not values:
            return
        super().extend(values)
        self._mark()

    def insert(self, index: int, value: Any) -> None:  # type: ignore[override]
        super().insert(index, value)
        self._mark()

    def remove(self, value: Any) -> None:  # type: ignore[override]
        super().remove(value)
        self._mark()

    def pop(self, index: int = -1) -> Any:  # type: ignore[override]
        value = super().pop(index)
        self._mark()
        return value

    def clear(self) -> None:  # type: ignore[override]
        if not self:
            return
        super().clear()
        self._mark()

    def reverse(self) -> None:  # type: ignore[override]
        super().reverse()
        self._mark()

    def sort(self, *args: Any, **kwargs: Any) -> None:  # type: ignore[override]
        super().sort(*args, **kwargs)
        self._mark()
