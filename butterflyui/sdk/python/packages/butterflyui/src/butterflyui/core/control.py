from __future__ import annotations

from dataclasses import dataclass, field
import inspect
import keyword
import traceback
import uuid
import sysconfig
from collections.abc import Mapping
from enum import Enum
from functools import wraps
from pathlib import Path
from typing import Any, TYPE_CHECKING
import weakref

if TYPE_CHECKING:
    from ..app import ButterflyUISession

_LAYOUT_PARAM_SPECS: tuple[tuple[str, Any, Any], ...] = (
    ("expand", bool, False),
    ("flex", int | None, None),
    ("width", float | str | None, None),
    ("height", float | str | None, None),
    ("min_width", float | str | None, None),
    ("min_height", float | str | None, None),
    ("max_width", float | str | None, None),
    ("max_height", float | str | None, None),
    ("padding", Any, None),
    ("margin", Any, None),
    ("alignment", Any, None),
    ("animation", Any, None),
)
_LAYOUT_KEYS = {name for name, _, _ in _LAYOUT_PARAM_SPECS}
_BUTTERFLYUI_ROOT = Path(__file__).resolve().parent.parent
_STDLIB_ROOTS: tuple[Path, ...] = ()
try:
    paths = sysconfig.get_paths()
    roots: list[Path] = []
    for key in ("stdlib", "platstdlib"):
        value = paths.get(key)
        if isinstance(value, str) and value:
            try:
                roots.append(Path(value).resolve())
            except Exception:
                continue
    _STDLIB_ROOTS = tuple(roots)
except Exception:
    _STDLIB_ROOTS = ()
_CONTROL_REGISTRY: "weakref.WeakValueDictionary[str, Control]" = weakref.WeakValueDictionary()


def _is_internal_path(path: str | None) -> bool:
    if not path:
        return False
    if path.startswith("<") and path.endswith(">"):
        return True
    try:
        resolved = Path(path).resolve()
    except Exception:
        return False
    try:
        if resolved.is_relative_to(_BUTTERFLYUI_ROOT):
            return True
    except Exception:
        try:
            resolved.relative_to(_BUTTERFLYUI_ROOT)
            return True
        except Exception:
            pass
    for root in _STDLIB_ROOTS:
        try:
            if resolved.is_relative_to(root):
                return True
        except Exception:
            try:
                resolved.relative_to(root)
                return True
            except Exception:
                continue
    parts = {part.lower() for part in resolved.parts}
    if "site-packages" in parts or "dist-packages" in parts:
        return True
    return False


def _capture_source() -> dict[str, Any] | None:
    frames = traceback.extract_stack()
    for frame in reversed(frames):
        if _is_internal_path(frame.filename):
            continue
        return {"path": frame.filename, "line": frame.lineno, "function": frame.name}
    return None


def _register_control(control: "Control") -> None:
    try:
        _CONTROL_REGISTRY[control.control_id] = control
    except Exception:
        pass


def _get_control_by_id(control_id: str) -> "Control | None":
    return _CONTROL_REGISTRY.get(str(control_id))


def _coerce_int(value: Any) -> Any:
    try:
        return int(value)
    except Exception:
        return value


def _coerce_float(value: Any) -> Any:
    try:
        return float(value)
    except Exception:
        return value


def _apply_layout_props(props: dict[str, Any], layout: Mapping[str, Any]) -> None:
    if not layout:
        return
    for key, value in layout.items():
        if value is None:
            continue
        if key == "expand":
            props["expand"] = bool(value)
        elif key == "flex":
            props["flex"] = _coerce_int(value)
        elif key == "animation":
            props["animation"] = coerce_json_value(value)
        elif key in {"width", "height", "min_width", "min_height", "max_width", "max_height"}:
            props[key] = _coerce_float(value)
        else:
            props[key] = value


def _merge_props(target: dict[str, Any], extra: Mapping[str, Any], *, override: bool = False) -> None:
    if not extra:
        return
    for key, value in extra.items():
        if value is None:
            continue
        if override or key not in target:
            target[key] = value


def _coerce_state_value(value: Any) -> tuple[bool, Any]:
    try:
        from ..state import State
    except Exception:
        return False, value
    if isinstance(value, State):
        return True, value.value
    return False, value


def _text_child(value: Any) -> dict[str, Any]:
    from butterflyui.controls.display import Text

    return Text(str(value)).to_json()


def coerce_control_map(control: Mapping[str, Any]) -> dict[str, Any]:
    out: dict[str, Any] = dict(control)
    props = out.get("props")
    if isinstance(props, Mapping):
        out["props"] = coerce_json_value(props)
    elif props is not None:
        out["props"] = coerce_json_value(props)
    children = out.get("children")
    if isinstance(children, list):
        coerced: list[dict[str, Any]] = []
        for child in children:
            child_json = coerce_child_json(child)
            if child_json is not None:
                coerced.append(child_json)
        out["children"] = coerced
    return out


def coerce_child_json(child: Any) -> dict[str, Any] | None:
    if child is None:
        return None
    if isinstance(child, bool):
        return None
    if isinstance(child, Control):
        return child.to_json()
    if isinstance(child, Mapping):
        return coerce_control_map(child)
    is_state, value = _coerce_state_value(child)
    if is_state:
        return _text_child(value)
    if isinstance(child, (str, int, float)):
        return _text_child(child)
    return _text_child(child)


def coerce_json_value(value: Any) -> Any:
    if value is None:
        return None
    if isinstance(value, Control):
        return value.to_json()
    if isinstance(value, Mapping):
        if "type" in value:
            return coerce_control_map(value)
        return {str(key): coerce_json_value(val) for key, val in value.items()}
    if isinstance(value, (list, tuple, set)):
        return [coerce_json_value(item) for item in value]
    is_state, state_value = _coerce_state_value(value)
    if is_state:
        return coerce_json_value(state_value)
    if isinstance(value, Enum):
        return value.value
    if hasattr(value, "__butterflyui_json__"):
        return coerce_json_value(value.__butterflyui_json__())
    if isinstance(value, (str, int, float, bool)):
        return value
    return str(value)


def _schema_annotation(schema: Mapping[str, Any]) -> Any:
    schema_type = schema.get("type")
    if isinstance(schema_type, list):
        return Any
    if schema_type == "string":
        return str
    if schema_type == "number":
        return float
    if schema_type == "integer":
        return int
    if schema_type == "boolean":
        return bool
    if schema_type == "array":
        items = schema.get("items")
        item_type = _schema_annotation(items) if isinstance(items, Mapping) else Any
        try:
            return list[item_type]
        except Exception:
            return list
    if schema_type == "object":
        return dict[str, Any]
    return Any


def _is_valid_param_name(name: str) -> bool:
    return name.isidentifier() and not keyword.iskeyword(name)


def _build_schema_signature(signature: inspect.Signature, control_type: str) -> inspect.Signature | None:
    try:
        from .schema import CONTROL_SCHEMAS
        from .style import Style
    except Exception:
        return None
    schema = CONTROL_SCHEMAS.get(control_type, {})
    props_schema = schema.get("properties", {}) if isinstance(schema, Mapping) else {}
    required = set(schema.get("required", [])) if isinstance(schema, Mapping) else set()

    params = list(signature.parameters.values())
    param_names = {param.name for param in params}
    var_kw = next((param for param in params if param.kind == inspect.Parameter.VAR_KEYWORD), None)
    if var_kw is not None:
        params.remove(var_kw)

    for prop_name, prop_schema in props_schema.items():
        if prop_name in param_names:
            continue
        if not _is_valid_param_name(str(prop_name)):
            continue
        default = inspect._empty if prop_name in required else None
        annotation = _schema_annotation(prop_schema) if isinstance(prop_schema, Mapping) else Any
        params.append(
            inspect.Parameter(
                prop_name,
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=default,
                annotation=annotation,
            )
        )
        param_names.add(prop_name)

    for name, annotation, default in _LAYOUT_PARAM_SPECS:
        if name in param_names or name in props_schema:
            continue
        params.append(
            inspect.Parameter(
                name,
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=default,
                annotation=annotation,
            )
        )
        param_names.add(name)

    if "props" not in param_names:
        params.append(
            inspect.Parameter(
                "props",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=None,
                annotation=Mapping[str, Any] | None,
            )
        )
        param_names.add("props")
    
    if "style" not in param_names:
        params.append(
            inspect.Parameter(
                "style",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=None,
                annotation=Style | None,
            )
        )
        param_names.add("style")

    if "strict" not in param_names:
        params.append(
            inspect.Parameter(
                "strict",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=False,
                annotation=bool,
            )
        )
        param_names.add("strict")
    if var_kw is not None:
        params.append(var_kw)
    return signature.replace(parameters=params)


@dataclass(slots=True, init=False)
class Control:
    control_type: str
    control_id: str = field(default_factory=lambda: uuid.uuid4().hex)
    props: dict[str, Any] = field(default_factory=dict)
    children: list["Control"] = field(default_factory=list)
    meta: dict[str, Any] = field(default_factory=dict)

    def __init__(
        self,
        control_type: str,
        *,
        control_id: str | None = None,
        props: Mapping[str, Any] | None = None,
        children: list["Control"] | None = None,
        meta: Mapping[str, Any] | None = None,
        style: Any | None = None,
        strict: bool = False,
        **extra_props: Any,
    ) -> None:
        self.control_type = str(control_type)
        self.control_id = str(control_id) if control_id else uuid.uuid4().hex
        self.props = {}
        self.children = list(children) if children else []
        self.meta = dict(meta) if isinstance(meta, Mapping) else {}

        if isinstance(props, Mapping):
            _merge_props(self.props, props, override=True)

        layout_kwargs: dict[str, Any] = {}
        if extra_props:
            for key in list(extra_props):
                if key in _LAYOUT_KEYS:
                    layout_kwargs[key] = extra_props.pop(key)

        if style is not None:
            try:
                from .style import Style
                if isinstance(style, Style):
                    _merge_props(self.props, style.to_json(), override=True)
                elif isinstance(style, Mapping):
                    _merge_props(self.props, style, override=True)
            except Exception:
                pass

        if extra_props:
            _merge_props(self.props, extra_props, override=True)

        if layout_kwargs:
            _apply_layout_props(self.props, layout_kwargs)

        if strict:
            from .schema import ensure_valid_props

            ensure_valid_props(self.control_type, self.props, strict=True)

    def to_json(self) -> dict[str, Any]:
        merged_children = list(self.children)

        def is_control_like(value: Any) -> bool:
            if isinstance(value, Control):
                return True
            if isinstance(value, Mapping) and "type" in value:
                return True
            return False

        def add_child(target: list[Any], value: Any) -> None:
            if not is_control_like(value):
                return
            if isinstance(value, Control):
                if any(value is existing for existing in target):
                    return
            elif any(isinstance(existing, Mapping) and existing == value for existing in target):
                return
            target.append(value)

        if not merged_children:
            try:
                slot_children: list[Any] = []
                control_type = str(self.control_type)
                props_child = self.props.get("child")
                props_children = self.props.get("children")

                if control_type in ("app_bar", "top_bar"):
                    leading = self.props.get("leading")
                    actions = self.props.get("actions")
                    if leading is not None:
                        add_child(slot_children, leading)
                    if actions is not None:
                        if isinstance(actions, (list, tuple)):
                            for item in actions:
                                add_child(slot_children, item)
                        else:
                            add_child(slot_children, actions)
                elif control_type == "overlay":
                    base_child = self.props.get("base_child")
                    overlay_child = self.props.get("overlay_child")
                    if base_child is not None:
                        add_child(slot_children, base_child)
                    if overlay_child is not None:
                        add_child(slot_children, overlay_child)
                elif control_type == "drag_payload":
                    if props_child is not None:
                        add_child(slot_children, props_child)
                    feedback = self.props.get("feedback")
                    if feedback is not None:
                        add_child(slot_children, feedback)
                    ghost = self.props.get("child_when_dragging")
                    if ghost is not None:
                        add_child(slot_children, ghost)
                else:
                    if props_child is not None:
                        add_child(slot_children, props_child)
                    if props_children is not None:
                        if isinstance(props_children, (list, tuple)):
                            for item in props_children:
                                add_child(slot_children, item)
                        else:
                            add_child(slot_children, props_children)

                if slot_children:
                    merged_children = slot_children
            except Exception:
                pass
        payload = {
            "id": self.control_id,
            "type": self.control_type,
            "props": coerce_json_value(self.props),
            "children": [
                child
                for child in (coerce_child_json(c) for c in merged_children)
                if child is not None
            ],
        }
        if self.meta:
            payload["meta"] = coerce_json_value(self.meta)
        return payload

    def to_dict(self) -> dict[str, Any]:
        """Alias for to_json() for compatibility with older control code."""
        return self.to_json()

    def _get(self, key: str, default: Any = None) -> Any:
        return self.props.get(key, default)

    def _set(self, key: str, value: Any) -> None:
        if value is None:
            self.props.pop(key, None)
        else:
            self.props[key] = value

    def _on(self, event: str, handler: Any, session: "ButterflyUISession | None" = None, **kwargs: Any) -> Any:
        if session is None:
            try:
                from ..runtime import get_current_session
                session = get_current_session()
            except Exception:
                session = None
        if session is None:
            return None
        return self.on_event(session, event, handler, **kwargs)

    def __init_subclass__(cls, **kwargs: Any) -> None:
        super(Control, cls).__init_subclass__(**kwargs)
        init = cls.__init__
        if getattr(init, "_butterflyui_wrapped", False):
            return
        signature = inspect.signature(init)
        param_names = {param.name for param in signature.parameters.values()}
        has_var_kw = any(param.kind == inspect.Parameter.VAR_KEYWORD for param in signature.parameters.values())

        @wraps(init)
        def wrapped(self: "Control", *args: Any, **kwargs: Any) -> None:
            extra_props = None
            if "props" not in param_names:
                extra_props = kwargs.pop("props", None)
            
            style = None
            if "style" not in param_names:
                style = kwargs.pop("style", None)
            
            strict = bool(kwargs.pop("strict", False)) if "strict" not in param_names else False

            layout_kwargs: dict[str, Any] = {}
            for key in _LAYOUT_KEYS:
                if key in kwargs and key not in param_names:
                    layout_kwargs[key] = kwargs.pop(key)

            extra_kwargs: dict[str, Any] = {}
            if not has_var_kw:
                for key in list(kwargs):
                    if key not in param_names:
                        extra_kwargs[key] = kwargs.pop(key)

            init(self, *args, **kwargs)

            if style:
                try:
                    from .style import Style
                    if isinstance(style, Style):
                         _merge_props(self.props, style.to_json(), override=False)
                    elif isinstance(style, Mapping):
                         _merge_props(self.props, style, override=False)
                except ImportError:
                    pass

            if extra_props:
                if isinstance(extra_props, Mapping):
                    _merge_props(self.props, extra_props, override=False)
            if extra_kwargs:
                _merge_props(self.props, extra_kwargs, override=False)
            if layout_kwargs:
                _apply_layout_props(self.props, layout_kwargs)

            if strict:
                from .schema import ensure_valid_props

                ensure_valid_props(self.control_type, self.props, strict=True)

            try:
                meta = self.meta if isinstance(self.meta, dict) else {}
                if meta is not self.meta:
                    self.meta = meta
                if "source" not in meta:
                    source = _capture_source()
                    if source:
                        meta["source"] = source
            except Exception:
                pass

            if not getattr(cls, "_butterflyui_signature_ready", False):
                schema_sig = _build_schema_signature(signature, self.control_type)
                if schema_sig is not None:
                    wrapped.__signature__ = schema_sig
                cls._butterflyui_signature_ready = True

            try:
                _register_control(self)
            except Exception:
                pass

        wrapped._butterflyui_wrapped = True  # type: ignore[attr-defined]
        cls.__init__ = wrapped  # type: ignore[assignment]

    def patch(self, *, session: "ButterflyUISession | None" = None, **props: Any) -> None:
        """Update props in-place and optionally notify the runtime."""
        if not props:
            return
        for key, value in props.items():
            if value is None:
                self.props.pop(key, None)
            else:
                self.props[key] = value
        if session is not None:
            session.update_props(self.control_id, coerce_json_value(props))

    # ---- Imperative actions (invoke channel) ----

    def invoke(
        self,
        session: "ButterflyUISession",
        method: str,
        args: Mapping[str, Any] | None = None,
        *,
        timeout: float | None = 10.0,
        **kwargs: Any,
    ) -> dict[str, Any]:
        return session.invoke(self.control_id, method, dict(args or {}), timeout=timeout, **kwargs)

    async def invoke_async(
        self,
        session: "ButterflyUISession",
        method: str,
        args: dict[str, Any] | None = None,
        *,
        timeout: float | None = 10.0,
        **kwargs: Any,
    ) -> dict[str, Any]:
        return await session.invoke_async(self.control_id, method, dict(args or {}), timeout=timeout, **kwargs)

    def request_focus(self, session: "ButterflyUISession", *, timeout: float | None = 10.0) -> dict[str, Any]:
        # Ensure the runtime installs the focus machinery.
        self.patch(session=session, focusable=True)
        return self.invoke(session, "request_focus", timeout=timeout)

    def next_focus(self, session: "ButterflyUISession", *, timeout: float | None = 10.0) -> dict[str, Any]:
        self.patch(session=session, focusable=True)
        return self.invoke(session, "next_focus", timeout=timeout)

    def previous_focus(self, session: "ButterflyUISession", *, timeout: float | None = 10.0) -> dict[str, Any]:
        self.patch(session=session, focusable=True)
        return self.invoke(session, "previous_focus", timeout=timeout)

    def unfocus(self, session: "ButterflyUISession", *, timeout: float | None = 10.0) -> dict[str, Any]:
        return self.invoke(session, "unfocus", timeout=timeout)

    # ---- Scrolling (invoke channel) ----

    def get_scroll_metrics(self, session: "ButterflyUISession", *, timeout: float | None = 10.0) -> dict[str, Any]:
        return self.invoke(session, "get_scroll_metrics", timeout=timeout)

    def scroll_to(
        self,
        session: "ButterflyUISession",
        *,
        offset: float | None = None,
        x: float | None = None,
        y: float | None = None,
        animate: bool = True,
        duration_ms: int = 250,
        curve: str = "ease",
        clamp: bool = True,
        timeout: float | None = 10.0,
    ) -> dict[str, Any]:
        args: dict[str, Any] = {
            "animate": bool(animate),
            "duration_ms": int(duration_ms),
            "curve": str(curve),
            "clamp": bool(clamp),
        }
        if offset is not None:
            args["offset"] = float(offset)
        if x is not None:
            args["x"] = float(x)
        if y is not None:
            args["y"] = float(y)
        return self.invoke(session, "scroll_to", args, timeout=timeout)

    def scroll_by(
        self,
        session: "ButterflyUISession",
        *,
        delta: float | None = None,
        dx: float | None = None,
        dy: float | None = None,
        animate: bool = True,
        duration_ms: int = 250,
        curve: str = "ease",
        clamp: bool = True,
        timeout: float | None = 10.0,
    ) -> dict[str, Any]:
        args: dict[str, Any] = {
            "animate": bool(animate),
            "duration_ms": int(duration_ms),
            "curve": str(curve),
            "clamp": bool(clamp),
        }
        if delta is not None:
            args["delta"] = float(delta)
        if dx is not None:
            args["dx"] = float(dx)
        if dy is not None:
            args["dy"] = float(dy)
        return self.invoke(session, "scroll_by", args, timeout=timeout)

    def scroll_to_start(
        self,
        session: "ButterflyUISession",
        *,
        animate: bool = True,
        duration_ms: int = 250,
        curve: str = "ease",
        timeout: float | None = 10.0,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_to_start",
            {"animate": bool(animate), "duration_ms": int(duration_ms), "curve": str(curve)},
            timeout=timeout,
        )

    def scroll_to_end(
        self,
        session: "ButterflyUISession",
        *,
        animate: bool = True,
        duration_ms: int = 250,
        curve: str = "ease",
        timeout: float | None = 10.0,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_to_end",
            {"animate": bool(animate), "duration_ms": int(duration_ms), "curve": str(curve)},
            timeout=timeout,
        )

    @property
    def padding(self) -> Any | None:
        return self.props.get("padding")

    @padding.setter
    def padding(self, value: Any | None) -> None:
        if value is None:
            self.props.pop("padding", None)
        else:
            self.props["padding"] = value

    @property
    def margin(self) -> Any | None:
        return self.props.get("margin")

    @margin.setter
    def margin(self, value: Any | None) -> None:
        if value is None:
            self.props.pop("margin", None)
        else:
            self.props["margin"] = value

    @property
    def animation(self) -> Any | None:
        return self.props.get("animation")

    @animation.setter
    def animation(self, value: Any | None) -> None:
        if value is None:
            self.props.pop("animation", None)
        else:
            self.props["animation"] = coerce_json_value(value)

    @property
    def width(self) -> float | None:
        v = self.props.get("width")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @width.setter
    def width(self, value: float | None) -> None:
        if value is None:
            self.props.pop("width", None)
        else:
            self.props["width"] = float(value)

    @property
    def height(self) -> float | None:
        v = self.props.get("height")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @height.setter
    def height(self, value: float | None) -> None:
        if value is None:
            self.props.pop("height", None)
        else:
            self.props["height"] = float(value)

    @property
    def min_width(self) -> float | None:
        v = self.props.get("min_width")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @min_width.setter
    def min_width(self, value: float | None) -> None:
        if value is None:
            self.props.pop("min_width", None)
        else:
            self.props["min_width"] = float(value)

    @property
    def min_height(self) -> float | None:
        v = self.props.get("min_height")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @min_height.setter
    def min_height(self, value: float | None) -> None:
        if value is None:
            self.props.pop("min_height", None)
        else:
            self.props["min_height"] = float(value)

    @property
    def max_width(self) -> float | None:
        v = self.props.get("max_width")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @max_width.setter
    def max_width(self, value: float | None) -> None:
        if value is None:
            self.props.pop("max_width", None)
        else:
            self.props["max_width"] = float(value)

    @property
    def max_height(self) -> float | None:
        v = self.props.get("max_height")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @max_height.setter
    def max_height(self, value: float | None) -> None:
        if value is None:
            self.props.pop("max_height", None)
        else:
            self.props["max_height"] = float(value)

    @property
    def aspect_ratio(self) -> float | None:
        v = self.props.get("aspect_ratio")
        if v is None:
            return None
        try:
            return float(v)
        except Exception:
            return None

    @aspect_ratio.setter
    def aspect_ratio(self, value: float | None) -> None:
        if value is None:
            self.props.pop("aspect_ratio", None)
        else:
            self.props["aspect_ratio"] = float(value)

    @property
    def alignment(self) -> str | None:
        v = self.props.get("alignment")
        return v if isinstance(v, str) else None

    @alignment.setter
    def alignment(self, value: str | None) -> None:
        if value is None:
            self.props.pop("alignment", None)
        else:
            self.props["alignment"] = value

    @property
    def flex(self) -> int | None:
        v = self.props.get("flex")
        if v is None:
            return None
        try:
            return int(v)
        except Exception:
            return None

    @flex.setter
    def flex(self, value: int | None) -> None:
        if value is None:
            self.props.pop("flex", None)
        else:
            self.props["flex"] = int(value)

    @property
    def expand(self) -> bool:
        return bool(self.props.get("expand", False))

    @expand.setter
    def expand(self, value: bool) -> None:
        self.props["expand"] = bool(value)

    def on_event(
        self,
        session: "ButterflyUISession",
        event: str,
        handler: Any,
        *,
        inputs: Any = None,
        outputs: Any = None,
        state: Any = None,
        progress: Any = None,
        queue: Any = None,
    ) -> Any:
        from ..callbacks import bind_event

        # Ensure both the canonical event name and any legacy aliases are
        # subscribed and bound to the same handler.
        event_names = self._expand_event_aliases(event)
        dispatch: Any = None
        for i, name in enumerate(event_names):
            self._subscribe_event(session, name)
            bound = bind_event(
                session,
                self,
                name,
                handler,
                inputs=inputs,
                outputs=outputs,
                state=state,
                progress=progress,
                queue=queue,
            )
            if i == 0:
                dispatch = bound
        return dispatch

    @staticmethod
    def _expand_event_aliases(event: str) -> list[str]:
        """Return canonical, legacy, and snake/camel aliases for an event name."""

        name = str(event)

        aliases: list[str] = []

        def add(value: str) -> None:
            if value and value not in aliases:
                aliases.append(value)

        def to_snake(value: str) -> str:
            out = []
            for i, ch in enumerate(value):
                if ch == "-":
                    out.append("_")
                    continue
                if ch.isupper():
                    if i > 0 and value[i - 1] not in "_-":
                        out.append("_")
                    out.append(ch.lower())
                else:
                    out.append(ch)
            return "".join(out)

        def to_camel(value: str) -> str:
            if "_" not in value:
                return value
            parts = [p for p in value.split("_") if p]
            if not parts:
                return value
            return parts[0] + "".join(part[:1].upper() + part[1:] for part in parts[1:])

        add(name)

        # Canonical hover events and legacy hover aliases.
        if name in ("hover_enter", "enter"):
            add("hover_enter")
            add("enter")
        if name in ("hover_exit", "exit"):
            add("hover_exit")
            add("exit")
        if name in ("hover_move", "hover"):
            add("hover_move")
            add("hover")

        snake = to_snake(name)
        camel = to_camel(snake)
        add(snake)
        add(camel)

        # Common legacy forms used by some controls.
        if snake == "replace_all":
            add("replaceAll")
        if snake == "suggestion_select":
            add("suggestionSelect")
        if snake == "filter_remove":
            add("filterRemove")
        if snake == "intent_change":
            add("intentChange")
        if snake == "provider_change":
            add("providerChange")
        if snake == "close":
            add("dismiss")
        if snake == "dismiss":
            add("close")

        return aliases

    def _subscribe_event(self, session: "ButterflyUISession", event: str) -> None:
        """Ensure the runtime knows this control should emit an event.

        ButterflyUI uses a lightweight subscription model: controls include an `events`
        list in props, and the Flutter runtime only installs event listeners for
        events present in that list.
        """

        # Expand to include any legacy aliases so the runtime installs all
        # relevant listeners.
        names = self._expand_event_aliases(event)
        current = self.props.get("events")
        events: list[str]
        if isinstance(current, list):
            events = [str(v) for v in current if v is not None]
        elif current is None:
            events = []
        else:
            events = [str(current)]
        changed = False
        for name in names:
            if name not in events:
                events.append(name)
                changed = True
        if changed:
            # Update local state immediately.
            self.props["events"] = events
            # If the runtime is already connected, also notify it.
            try:
                session.update_props(self.control_id, {"events": events})
            except Exception:
                pass

    # ---- Universal event helpers (unified API) ----

    def on_click(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "click", handler, **kwargs)

    def on_tap(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "click", handler, **kwargs)

    def on_double_click(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "double_click", handler, **kwargs)

    def on_long_press(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "long_press", handler, **kwargs)

    def on_press(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "press", handler, **kwargs)

    def on_shortcut(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "shortcut", handler, **kwargs)

    def on_select(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "select", handler, **kwargs)

    def on_close(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "close", handler, **kwargs)

    def on_open(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "open", handler, **kwargs)

    def on_command(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "command", handler, **kwargs)

    def on_intent(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "intent", handler, **kwargs)

    def on_toggle_fold(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "toggle_fold", handler, **kwargs)

    def on_hover_enter(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "hover_enter", handler, **kwargs)

    def on_hover_exit(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "hover_exit", handler, **kwargs)

    def on_hover_move(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "hover_move", handler, **kwargs)

    def on_focus(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "focus", handler, **kwargs)

    def on_blur(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "blur", handler, **kwargs)

    def on_key_down(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "key_down", handler, **kwargs)

    def on_key_up(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "key_up", handler, **kwargs)

    def on_change(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "change", handler, **kwargs)

    def on_submit(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "submit", handler, **kwargs)

    def on_scroll_start(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scroll_start", handler, **kwargs)

    def on_scroll(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scroll", handler, **kwargs)

    def on_scroll_end(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scroll_end", handler, **kwargs)

    def on_resize(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "resize", handler, **kwargs)

    def on_context_menu(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "context_menu", handler, **kwargs)

    def on_pan_start(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "pan_start", handler, **kwargs)

    def on_pan_update(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "pan_update", handler, **kwargs)

    def on_pan_end(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "pan_end", handler, **kwargs)

    def on_scale_start(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scale_start", handler, **kwargs)

    def on_scale_update(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scale_update", handler, **kwargs)

    def on_scale_end(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "scale_end", handler, **kwargs)

    def click(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "click", handler, **kwargs)

    def change(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "change", handler, **kwargs)

    def submit(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "submit", handler, **kwargs)

    def select(self, session: "ButterflyUISession", handler: Any, **kwargs: Any) -> Any:
        return self.on_event(session, "select", handler, **kwargs)


Component = Control

__all__ = ["Control", "Component"]
