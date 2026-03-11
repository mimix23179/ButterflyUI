from __future__ import annotations

from dataclasses import dataclass, field
import inspect
import keyword
import traceback
import sysconfig
from collections.abc import Mapping
from enum import Enum
from functools import wraps
from pathlib import Path
from typing import Any, TYPE_CHECKING
import weakref

from .children import control_children_from_slots
from .dirty import DirtyChildrenList, DirtyPropsDict, DirtyState
from .ids import new_control_id
from .invocation import invoke_control_method, invoke_control_method_async

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
_AUTOPROP_EXCLUDE_NAMES = {
    "self",
    "control_type",
    "control_id",
    "meta",
    "props",
    "style",
    "strict",
    "child",
    "children",
    "children_args",
    "kwargs",
    "args",
}
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
_CONTROL_FIELD_DEFAULT_MISSING = object()
_CONTROL_FIELD_EXCLUDE_NAMES = {
    "control_type",
    "control_id",
    "props",
    "children",
    "meta",
}
_CONTROL_RUNTIME_ATTRS = {
    "__class__",
    "__dict__",
    "__weakref__",
    "__module__",
    "__doc__",
    "__annotations__",
    "__dataclass_fields__",
    "__dataclass_params__",
    "__orig_class__",
    "__slots__",
    "__match_args__",
    "control_type",
    "control_id",
    "props",
    "children",
    "meta",
}


def _collect_doc_only_field_names(cls: type["Control"]) -> frozenset[str]:
    names: list[str] = []
    seen: set[str] = set()
    for base in reversed(cls.__mro__):
        declared = getattr(base, "_butterflyui_doc_only_fields", ())
        if not isinstance(declared, (set, frozenset, list, tuple)):
            continue
        for name in declared:
            if not isinstance(name, str):
                continue
            if name.startswith("_") or name in _CONTROL_FIELD_EXCLUDE_NAMES:
                continue
            if name not in seen:
                names.append(name)
                seen.add(name)
    return frozenset(names)


def _collect_control_field_aliases(cls: type["Control"]) -> dict[str, str]:
    aliases: dict[str, str] = {}
    for base in reversed(cls.__mro__):
        declared = getattr(base, "_butterflyui_field_aliases", {})
        if not isinstance(declared, Mapping):
            continue
        for key, value in declared.items():
            if not isinstance(key, str) or not isinstance(value, str):
                continue
            if key.startswith("_") or key in _CONTROL_FIELD_EXCLUDE_NAMES:
                continue
            aliases[key] = value
    return aliases


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


def _collect_control_field_names(
    cls: type["Control"], *, doc_only_fields: frozenset[str] | None = None
) -> frozenset[str]:
    names: list[str] = []
    seen: set[str] = set()
    excluded = set(doc_only_fields or ())
    for base in reversed(cls.__mro__):
        annotations = getattr(base, "__annotations__", {})
        if not isinstance(annotations, dict):
            continue
        for name in annotations:
            if not isinstance(name, str):
                continue
            if name.startswith("_") or name in _CONTROL_FIELD_EXCLUDE_NAMES:
                continue
            if name in excluded:
                continue
            if name not in seen:
                names.append(name)
                seen.add(name)
    return frozenset(names)


def _collect_control_field_order(
    cls: type["Control"],
    *,
    doc_only_fields: frozenset[str] | None = None,
    include_doc_only: bool = False,
) -> tuple[str, ...]:
    names: list[str] = []
    seen: set[str] = set()
    excluded = set(doc_only_fields or ())
    for base in reversed(cls.__mro__):
        annotations = getattr(base, "__annotations__", {})
        if not isinstance(annotations, dict):
            continue
        for name in annotations:
            if not isinstance(name, str):
                continue
            if name.startswith("_") or name in _CONTROL_FIELD_EXCLUDE_NAMES:
                continue
            if not include_doc_only and name in excluded:
                continue
            if name not in seen:
                names.append(name)
                seen.add(name)
    return tuple(names)


def _control_field_default(cls: type["Control"], name: str) -> Any:
    for base in cls.__mro__:
        if name in getattr(base, "__dict__", {}):
            return inspect.getattr_static(base, name)
    return _CONTROL_FIELD_DEFAULT_MISSING


def _control_field_prop_name(cls: type["Control"], name: str) -> str:
    aliases = getattr(cls, "_butterflyui_field_aliases", {})
    if isinstance(aliases, Mapping):
        alias = aliases.get(name)
        if isinstance(alias, str) and alias:
            return alias
    if name.endswith("_") and len(name) > 1:
        return name[:-1]
    return name


def _signature_default(value: Any) -> Any:
    if value is _CONTROL_FIELD_DEFAULT_MISSING:
        return None
    if isinstance(value, (list, dict, set)):
        return None
    return value


def _build_control_class_signature(cls: type["Control"]) -> inspect.Signature | None:
    params: list[inspect.Parameter] = []
    positional_fields = tuple(getattr(cls, "_butterflyui_positional_fields", ()))
    field_order = getattr(cls, "_butterflyui_control_field_order", ())
    ordered_names = [
        *[name for name in field_order if name in positional_fields],
        *[name for name in field_order if name not in positional_fields],
    ]
    for name in ordered_names:
        default = _signature_default(_control_field_default(cls, name))
        annotation = Any
        for base in cls.__mro__:
            annotations = getattr(base, "__annotations__", {})
            if isinstance(annotations, dict) and name in annotations:
                annotation = annotations[name]
                break
        params.append(
            inspect.Parameter(
                name,
                kind=(
                    inspect.Parameter.POSITIONAL_OR_KEYWORD
                    if name in positional_fields
                    else inspect.Parameter.KEYWORD_ONLY
                ),
                default=default,
                annotation=annotation,
            )
        )

    param_names = {param.name for param in params}
    if "props" not in param_names:
        params.append(
            inspect.Parameter(
                "props",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=None,
                annotation=Mapping[str, Any] | None,
            )
        )
    if "style" not in param_names:
        params.append(
            inspect.Parameter(
                "style",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=None,
                annotation=Any | None,
            )
        )
    if "strict" not in param_names:
        params.append(
            inspect.Parameter(
                "strict",
                kind=inspect.Parameter.KEYWORD_ONLY,
                default=False,
                annotation=bool,
            )
        )
    return inspect.Signature(parameters=params)


def _build_declarative_control_init(cls: type["Control"]):
    positional_fields = tuple(getattr(cls, "_butterflyui_positional_fields", ()))
    doc_only_fields = frozenset(getattr(cls, "_butterflyui_doc_only_fields", ()))
    field_order = tuple(getattr(cls, "_butterflyui_control_field_order", ()))

    @wraps(Control.__init__)
    def generated(
        self: "Control",
        *args: Any,
        props: Mapping[str, Any] | None = None,
        style: Any | None = None,
        strict: bool = False,
        child: Any | None = None,
        children: Any | None = None,
        **kwargs: Any,
    ) -> None:
        field_values: dict[str, Any] = {}
        extra_children: list[Any] = []

        for index, value in enumerate(args):
            if index < len(positional_fields):
                field_values[positional_fields[index]] = value
            else:
                extra_children.append(value)

        for name in field_order:
            if name in kwargs and name not in field_values:
                field_values[name] = kwargs.pop(name)

        doc_values: dict[str, Any] = {}
        translated_kwargs: dict[str, Any] = {}
        for name, value in field_values.items():
            if name in doc_only_fields:
                doc_values[name] = value
                continue
            prop_name = _control_field_prop_name(cls, name)
            if prop_name == "child":
                if value is not None and child is None:
                    child = value
                continue
            if prop_name == "children":
                if value is not None and children is None:
                    children = value
                continue
            translated_kwargs[prop_name] = value

        resolved_children = children
        if extra_children:
            if resolved_children is None:
                resolved_children = list(extra_children)
            else:
                merged_children = list(resolved_children)
                merged_children.extend(extra_children)
                resolved_children = merged_children

        super(cls, self).__init__(
            child=child,
            children=resolved_children,
            props=props,
            style=style,
            strict=strict,
            **translated_kwargs,
            **kwargs,
        )

        for name, value in doc_values.items():
            object.__setattr__(self, name, value)

        init_hook = getattr(self, "init", None)
        if callable(init_hook):
            init_hook()

        try:
            _register_control(self)
        except Exception:
            pass
        try:
            self.clear_dirty()
        except Exception:
            pass

    generated._butterflyui_wrapped = True  # type: ignore[attr-defined]
    generated._butterflyui_generated = True  # type: ignore[attr-defined]
    return generated


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


def _coerce_style_payload(style: Any) -> dict[str, Any] | None:
    if style is None:
        return None
    payload: dict[str, Any] | None = None
    if isinstance(style, Mapping):
        payload = dict(style)
    elif hasattr(style, "to_json"):
        try:
            raw_payload = style.to_json()
        except Exception:
            return None
        if isinstance(raw_payload, Mapping):
            payload = dict(raw_payload)
    if payload is None:
        return None
    return _normalize_universal_prop_aliases(payload)


def _merge_local_style(
    props: dict[str, Any],
    style_payload: Mapping[str, Any] | None,
    *,
    override: bool,
) -> None:
    if not isinstance(style_payload, Mapping) or not style_payload:
        return
    existing = props.get("style")
    style_map = dict(existing) if isinstance(existing, Mapping) else {}
    for key, value in style_payload.items():
        if value is None:
            continue
        if override or key not in style_map:
            style_map[key] = value
    if style_map:
        props["style"] = style_map


def _normalize_universal_prop_aliases(props: Mapping[str, Any] | None) -> dict[str, Any]:
    if not isinstance(props, Mapping):
        return {}
    normalized = dict(props)
    classes = normalized.get("classes")
    class_name = normalized.pop("class_name", None)
    if classes is None:
        if class_name is not None:
            normalized["classes"] = class_name
    elif class_name is not None:
        if isinstance(classes, str):
            merged_classes: list[str] = classes.split()
        elif isinstance(classes, (list, tuple, set)):
            merged_classes = [str(item) for item in classes if item is not None]
        else:
            merged_classes = [str(classes)]
        if isinstance(class_name, str):
            merged_classes.extend(token for token in class_name.split() if token)
        elif isinstance(class_name, (list, tuple, set)):
            merged_classes.extend(str(item) for item in class_name if item is not None)
        else:
            merged_classes.append(str(class_name))
        seen: set[str] = set()
        ordered: list[str] = []
        for token in merged_classes:
            if token and token not in seen:
                ordered.append(token)
                seen.add(token)
        normalized["classes"] = ordered
    theme = normalized.pop("theme", None)
    if "style_pack" not in normalized and theme is not None:
        normalized["style_pack"] = theme
    style_value = normalized.get("style")
    if style_value is not None:
        style_payload = _coerce_style_payload(style_value)
        if style_payload is not None:
            normalized["style"] = style_payload
    return normalized


def _backfill_bound_init_props(
    target: dict[str, Any],
    signature: inspect.Signature,
    bound_arguments: Mapping[str, Any],
) -> None:
    if not isinstance(target, dict):
        return
    for name, parameter in signature.parameters.items():
        if name in _AUTOPROP_EXCLUDE_NAMES:
            continue
        if parameter.kind in (
            inspect.Parameter.VAR_POSITIONAL,
            inspect.Parameter.VAR_KEYWORD,
        ):
            continue
        if name not in bound_arguments:
            continue
        value = bound_arguments[name]
        if value is None:
            continue
        if callable(value):
            continue
        candidate_keys = [name]
        if name.endswith("_") and len(name) > 1:
            candidate_keys.append(name[:-1])
        if name == "from_":
            candidate_keys.append("from")
        for key in candidate_keys:
            if not key:
                continue
            if key not in target:
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
    if hasattr(value, "to_json"):
        try:
            return coerce_json_value(value.to_json())
        except Exception:
            pass
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


def prepare_control_class(cls: type["Control"]) -> type["Control"]:
    cls._butterflyui_doc_only_fields = _collect_doc_only_field_names(cls)
    cls._butterflyui_field_aliases = _collect_control_field_aliases(cls)
    cls._butterflyui_control_fields = _collect_control_field_names(
        cls, doc_only_fields=cls._butterflyui_doc_only_fields
    )
    cls._butterflyui_control_field_order = _collect_control_field_order(
        cls,
        doc_only_fields=cls._butterflyui_doc_only_fields,
        include_doc_only=True,
    )
    if "__init__" not in cls.__dict__:
        cls.__init__ = _build_declarative_control_init(cls)  # type: ignore[assignment]
        try:
            cls.__signature__ = _build_control_class_signature(cls)
        except Exception:
            pass
        return cls
    init = cls.__init__
    if getattr(init, "_butterflyui_generated", False):
        cls.__init__ = _build_declarative_control_init(cls)  # type: ignore[assignment]
        try:
            cls.__signature__ = _build_control_class_signature(cls)
        except Exception:
            pass
        return cls
    if getattr(init, "_butterflyui_wrapped", False):
        try:
            cls.__signature__ = _build_control_class_signature(cls)
        except Exception:
            pass
        return cls
    signature = inspect.signature(init)
    param_names = {param.name for param in signature.parameters.values()}
    has_var_kw = any(
        param.kind == inspect.Parameter.VAR_KEYWORD
        for param in signature.parameters.values()
    )

    @wraps(init)
    def wrapped(self: "Control", *args: Any, **kwargs: Any) -> None:
        init_args = args
        init_kwargs = dict(kwargs)
        extra_props = None
        if "props" not in param_names:
            extra_props = kwargs.pop("props", None)

        style = None
        if "style" not in param_names:
            style = kwargs.pop("style", None)

        strict = (
            bool(kwargs.pop("strict", False)) if "strict" not in param_names else False
        )

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

        style_payload = _coerce_style_payload(style)
        if style_payload is not None:
            _merge_local_style(self.props, style_payload, override=False)
            _merge_props(self.props, style_payload, override=False)

        if extra_props:
            if isinstance(extra_props, Mapping):
                _merge_props(self.props, extra_props, override=False)
        if extra_kwargs:
            _merge_props(self.props, extra_kwargs, override=False)
        if layout_kwargs:
            _apply_layout_props(self.props, layout_kwargs)
        try:
            bound = signature.bind_partial(self, *init_args, **init_kwargs)
        except Exception:
            bound = None
        if bound is not None:
            _backfill_bound_init_props(
                self.props,
                signature,
                bound.arguments,
            )

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

        try:
            cls.__signature__ = _build_control_class_signature(cls)
        except Exception:
            schema_sig = _build_schema_signature(signature, self.control_type)
            if schema_sig is not None:
                wrapped.__signature__ = schema_sig
        cls._butterflyui_signature_ready = True

        try:
            _register_control(self)
        except Exception:
            pass
        try:
            self.clear_dirty()
        except Exception:
            pass

    wrapped._butterflyui_wrapped = True  # type: ignore[attr-defined]
    cls.__init__ = wrapped  # type: ignore[assignment]
    try:
        cls.__signature__ = _build_control_class_signature(cls)
    except Exception:
        pass
    return cls


@dataclass(slots=True, init=False)
class Control:
    """Base runtime control node serialized to the Flutter client.

    Subclass constructors can stay ergonomic: when a subclass omits
    forwarding some init arguments into ``merge_props(...)``, ButterflyUI
    auto-backfills explicitly passed constructor args into ``props``.
    This keeps Python signatures/docstrings and runtime-usable arguments
    aligned across the large control catalog.
    """
    control_type: str
    control_id: str = field(default_factory=new_control_id)
    props: dict[str, Any] = field(default_factory=dict)
    children: list["Control"] = field(default_factory=list)
    meta: dict[str, Any] = field(default_factory=dict)

    def __init__(
        self,
        control_type: str | None = None,
        *,
        control_id: str | None = None,
        props: Mapping[str, Any] | None = None,
        children: list["Control"] | None = None,
        meta: Mapping[str, Any] | None = None,
        style: Any | None = None,
        strict: bool = False,
        **extra_props: Any,
    ) -> None:
        resolved_type = control_type
        if not resolved_type:
            resolved_type = getattr(self, "control_type", None)
        if not resolved_type:
            resolved_type = self.__class__.__name__.lower()
        self.control_type = str(resolved_type)
        self.control_id = str(control_id) if control_id else new_control_id()
        self._dirty_state = DirtyState()
        self._suspend_dirty_tracking = True
        self.props = DirtyPropsDict(self)
        self.children = DirtyChildrenList(self, children or [])
        self.meta = dict(meta) if isinstance(meta, Mapping) else {}
        self._inline_event_handlers: dict[str, Any] = {}
        self._inline_event_bound_sessions: set[str] = set()

        if isinstance(props, Mapping):
            _merge_props(
                self.props,
                _normalize_universal_prop_aliases(props),
                override=True,
            )

        layout_kwargs: dict[str, Any] = {}
        if extra_props:
            if "classes" not in extra_props and "class_name" in extra_props:
                extra_props["classes"] = extra_props.pop("class_name")
            if "style_pack" not in extra_props and "theme" in extra_props:
                extra_props["style_pack"] = extra_props.pop("theme")
            for key in list(extra_props):
                if key in _LAYOUT_KEYS:
                    layout_kwargs[key] = extra_props.pop(key)

        style_payload = _coerce_style_payload(style)
        if style_payload is not None:
            _merge_local_style(self.props, style_payload, override=True)
            _merge_props(self.props, style_payload, override=True)

        if extra_props:
            _merge_props(self.props, extra_props, override=True)

        if layout_kwargs:
            _apply_layout_props(self.props, layout_kwargs)

        if strict:
            from .schema import ensure_valid_props

            ensure_valid_props(self.control_type, self.props, strict=True)
        self._suspend_dirty_tracking = False
        self.clear_dirty()

    def add_inline_event_handler(self, event: str, handler: Any) -> None:
        if not callable(handler):
            return
        name = str(event).strip()
        if not name:
            return
        self._inline_event_handlers[name] = handler

    def bind_inline_event_handlers(self, session: "ButterflyUISession") -> None:
        if not self._inline_event_handlers:
            return
        session_key = str(id(session))
        if session_key in self._inline_event_bound_sessions:
            return
        for event, handler in self._inline_event_handlers.items():
            self.on_event(session, event, handler)
        self._inline_event_bound_sessions.add(session_key)

    def to_json(self) -> dict[str, Any]:
        merged_children = control_children_from_slots(str(self.control_type), self.props, list(self.children))
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

    def mark_dirty(self, name: str) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        self._dirty_state.props.add(str(name))

    def mark_children_dirty(self) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        self._dirty_state.children = True

    def mark_events_dirty(self) -> None:
        if getattr(self, "_suspend_dirty_tracking", False):
            return
        self._dirty_state.events = True

    def clear_dirty(self) -> None:
        self._dirty_state.clear()

    def collect_patch(self) -> dict[str, Any]:
        patch: dict[str, Any] = {}
        for name in sorted(self._dirty_state.props):
            patch[name] = coerce_json_value(self.props.get(name))
        if self._dirty_state.events and "events" not in patch:
            patch["events"] = coerce_json_value(self.props.get("events"))
        if self._dirty_state.children:
            merged_children = control_children_from_slots(
                str(self.control_type),
                self.props,
                list(self.children),
            )
            patch["children"] = [
                child
                for child in (coerce_child_json(c) for c in merged_children)
                if child is not None
            ]
        return patch

    def _get(self, key: str, default: Any = None) -> Any:
        return self.props.get(key, default)

    def _set(self, key: str, value: Any) -> None:
        if value is None:
            self.props.pop(key, None)
        else:
            self.props[key] = value
        if key == "events":
            self.mark_events_dirty()

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
        prepare_control_class(cls)

    def __getattribute__(self, name: str) -> Any:
        if name.startswith("_") or name in _CONTROL_RUNTIME_ATTRS:
            return object.__getattribute__(self, name)
        cls = object.__getattribute__(self, "__class__")
        field_names = getattr(cls, "_butterflyui_control_fields", ())
        if name in field_names:
            try:
                props = object.__getattribute__(self, "props")
            except AttributeError:
                return object.__getattribute__(self, name)
            prop_name = _control_field_prop_name(cls, name)
            if prop_name == "child":
                children = object.__getattribute__(self, "children")
                if children:
                    return children[0]
            if prop_name == "children":
                return object.__getattribute__(self, "children")
            if prop_name in props:
                return props.get(prop_name)
            default = _control_field_default(cls, name)
            if default is not _CONTROL_FIELD_DEFAULT_MISSING:
                return default
            return None
        return object.__getattribute__(self, name)

    def __setattr__(self, name: str, value: Any) -> None:
        if name.startswith("_") or name in _CONTROL_RUNTIME_ATTRS:
            object.__setattr__(self, name, value)
            return
        cls = object.__getattribute__(self, "__class__")
        field_names = getattr(cls, "_butterflyui_control_fields", ())
        if name in field_names:
            try:
                props = object.__getattribute__(self, "props")
            except AttributeError:
                object.__setattr__(self, name, value)
                return
            prop_name = _control_field_prop_name(cls, name)
            if prop_name == "child":
                children = object.__getattribute__(self, "children")
                if children:
                    children[0] = value
                elif value is None:
                    props.pop("child", None)
                else:
                    children.append(value)
                return
            if prop_name == "children":
                children = object.__getattribute__(self, "children")
                children.clear()
                if value is None:
                    props.pop("children", None)
                    return
                if isinstance(value, (list, tuple)):
                    children.extend(value)
                else:
                    children.append(value)
                return
            if value is None:
                props.pop(prop_name, None)
            else:
                props[prop_name] = value
            if prop_name == "events":
                self.mark_events_dirty()
            return
        object.__setattr__(self, name, value)

    def __delattr__(self, name: str) -> None:
        cls = object.__getattribute__(self, "__class__")
        field_names = getattr(cls, "_butterflyui_control_fields", ())
        if name in field_names:
            self.__setattr__(name, None)
            return
        object.__delattr__(self, name)

    def patch(self, *, session: "ButterflyUISession | None" = None, **props: Any) -> None:
        """Update props in-place and optionally notify the runtime."""
        if not props:
            return
        for key, value in props.items():
            if value is None:
                self.props.pop(key, None)
            else:
                self.props[key] = value
            if key == "events":
                self.mark_events_dirty()
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
        return invoke_control_method(session, self.control_id, method, args, timeout=timeout, **kwargs)

    async def invoke_async(
        self,
        session: "ButterflyUISession",
        method: str,
        args: dict[str, Any] | None = None,
        *,
        timeout: float | None = 10.0,
        **kwargs: Any,
    ) -> dict[str, Any]:
        return await invoke_control_method_async(session, self.control_id, method, args, timeout=timeout, **kwargs)

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
            self.mark_events_dirty()
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
