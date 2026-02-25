from __future__ import annotations

import importlib
import re
import sys
from pathlib import Path
from textwrap import dedent

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
SUBMODULES_DIR = PY_SRC / "butterflyui" / "controls" / "candy" / "submodules"
ROOT_INIT_PATH = PY_SRC / "butterflyui" / "controls" / "candy" / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "candy"
    / "candy_registry.dart"
)
SPECIAL_FILES = {"control.py", "schema.py", "components.py", "__init__.py", "family.py"}

CANDY_MODULES = [
    "align",
    "animation",
    "aspect_ratio",
    "avatar",
    "badge",
    "border",
    "button",
    "canvas",
    "card",
    "center",
    "clip",
    "column",
    "container",
    "decorated_box",
    "effects",
    "fitted_box",
    "gradient",
    "icon",
    "motion",
    "outline",
    "overflow_box",
    "particles",
    "row",
    "shadow",
    "spacer",
    "stack",
    "surface",
    "text",
    "transition",
    "wrap",
]

MODULE_ALLOWED_KEYS = {
    "button": {"label", "text", "icon", "loading", "disabled", "radius", "padding", "bgcolor", "text_color"},
    "card": {"elevation", "radius", "padding", "margin", "bgcolor"},
    "column": {"spacing", "alignment", "main_axis", "cross_axis"},
    "container": {"width", "height", "padding", "margin", "alignment", "bgcolor", "radius"},
    "row": {"spacing", "alignment", "main_axis", "cross_axis"},
    "stack": {"alignment", "fit"},
    "surface": {"bgcolor", "elevation", "radius", "border_color", "border_width"},
    "wrap": {"spacing", "run_spacing", "alignment", "run_alignment"},
    "align": {"alignment", "width_factor", "height_factor"},
    "center": {"width_factor", "height_factor"},
    "spacer": {"width", "height", "flex"},
    "aspect_ratio": {"ratio", "value"},
    "overflow_box": {"alignment", "min_width", "max_width", "min_height", "max_height"},
    "fitted_box": {"fit", "alignment", "clip_behavior"},
    "effects": {"shimmer", "blur", "opacity", "overlay"},
    "particles": {"count", "speed", "size", "gravity", "drift", "overlay", "colors"},
    "border": {"color", "width", "radius", "side", "padding"},
    "shadow": {"color", "blur", "spread", "dx", "dy"},
    "outline": {"outline_color", "outline_width", "radius"},
    "gradient": {"variant", "colors", "stops", "begin", "end", "angle"},
    "animation": {"duration_ms", "curve", "opacity", "scale", "autoplay", "loop", "reverse"},
    "transition": {"duration_ms", "curve", "preset", "key"},
    "canvas": {"width", "height", "commands"},
    "clip": {"shape", "clip_shape", "clip_behavior", "radius"},
    "decorated_box": {"bgcolor", "gradient", "border_color", "border_width", "radius", "shadow"},
    "badge": {"label", "text", "value", "color", "bgcolor", "text_color", "radius"},
    "avatar": {"src", "label", "text", "size", "color", "bgcolor"},
    "icon": {"icon", "size", "color"},
    "text": {"text", "value", "color", "font_size", "size", "font_weight", "weight", "align", "max_lines", "overflow"},
    "motion": {"duration_ms", "curve", "opacity", "scale", "autoplay", "loop", "reverse"},
}

TYPE_TO_PY = {
    "any": "object",
    "bool": "bool",
    "string": "str",
    "num": "int | float",
    "int": "int",
    "map": "Mapping[str, object]",
    "list": "list[object]",
    "events": "Iterable[str]",
    "state": "str",
    "color": "str | int",
    "dimension": "int | float | str",
    "alignment": "str | Mapping[str, object] | list[object]",
    "padding": "int | float | Mapping[str, object] | list[object]",
}


def _pascal(token: str) -> str:
    return "".join(part[:1].upper() + part[1:] for part in token.split("_") if part)


def _to_python_hint(type_name: str) -> str:
    return TYPE_TO_PY.get(type_name, "object")


def _load_module_payload_types() -> dict[str, dict[str, str]]:
    if str(PY_SRC) not in sys.path:
        sys.path.insert(0, str(PY_SRC))
    try:
        module = importlib.import_module("butterflyui.controls.candy.submodules.schema")
    except Exception:
        return {}
    payload_types = getattr(module, "MODULE_PAYLOAD_TYPES", {})
    if isinstance(payload_types, dict):
        out: dict[str, dict[str, str]] = {}
        for key, value in payload_types.items():
            if isinstance(key, str) and isinstance(value, dict):
                out[key] = {
                    str(prop): str(type_name)
                    for prop, type_name in value.items()
                    if isinstance(prop, str)
                }
        return out
    return {}


def _module_text(
    module: str,
    class_name: str,
    module_keys: list[str],
    module_key_types: dict[str, str],
) -> str:
    lines = [
        "from __future__ import annotations",
        "",
        "from collections.abc import Mapping",
        "from typing import Iterable",
        "",
        "from .control import CandySubmodule",
        "from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES",
        "",
        f'MODULE_TOKEN = "{module}"',
        "",
        "",
        f"class {class_name}(CandySubmodule):",
        f'    """Candy submodule host control for `{module}`."""',
        "",
        f'    control_type = "candy_{module}"',
        '    umbrella = "candy"',
        "    module_token = MODULE_TOKEN",
        "    canonical_module = MODULE_TOKEN",
        "",
        "    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))",
        "    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))",
        "    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))",
        "    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))",
        "",
        "    def __init__(",
        "        self,",
        "        *children: object,",
        "        payload: Mapping[str, object] | None = None,",
        "        props: Mapping[str, object] | None = None,",
        "        style: Mapping[str, object] | None = None,",
        "        strict: bool = False,",
    ]
    for key in module_keys:
        hint = _to_python_hint(str(module_key_types.get(key, "any")))
        lines.append(f"        {key}: {hint} | None = None,")
    lines.extend(
        [
            "        **kwargs: object,",
            "    ) -> None:",
            "        resolved_payload = dict(payload or {})",
        ]
    )
    for key in module_keys:
        lines.append(f"        if {key} is not None:")
        lines.append(f'            resolved_payload["{key}"] = {key}')
    lines.extend(
        [
            "        super().__init__(",
            "            *children,",
            "            payload=resolved_payload,",
            "            props=props,",
            "            style=style,",
            "            strict=strict,",
            "            **kwargs,",
            "        )",
            "",
            "    def set_module_props(self, session: object, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        update_payload = dict(payload or {})",
            "        if kwargs:",
            "            update_payload.update(kwargs)",
            "        return self.set_payload(session, update_payload)",
            "",
            "    def emit_module_event(self, session: object, event: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        return self.emit_event(session, event, payload, **kwargs)",
            "",
            "    def run_module_action(self, session: object, action: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        return self.run_action(session, action, payload, **kwargs)",
            "",
            "    def contract(self) -> dict[str, object]:",
            "        return self.describe_contract()",
            "",
            "",
            f'__all__ = ["{class_name}"]',
        ]
    )
    return "\n".join(lines) + "\n"


def _components_text(modules: list[str], class_names: dict[str, str]) -> str:
    imports = "\n".join(f"from .{module} import {class_names[module]}" for module in modules)
    mapping = "\n".join(f'    "{module}": {class_names[module]},' for module in modules)
    exports = "\n".join(f'    "{class_names[module]}",' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        f"{imports}\n\n"
        "MODULE_COMPONENTS = {\n"
        f"{mapping}\n"
        "}\n\n"
        "globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})\n\n"
        "__all__ = [\n"
        '    "MODULE_COMPONENTS",\n'
        f"{exports}\n"
        "]\n"
    )


def _init_text() -> str:
    return dedent(
        """
        from __future__ import annotations

        from .components import MODULE_COMPONENTS
        from .components import __all__ as _component_all
        from .components import *
        from .schema import CONTROL_PREFIX, MODULE_CANONICAL, MODULE_CLASS_NAMES, MODULE_TOKENS, SUPPORTED_EVENTS

        __all__ = [
            "CONTROL_PREFIX",
            "MODULE_TOKENS",
            "MODULE_CANONICAL",
            "SUPPORTED_EVENTS",
            "MODULE_CLASS_NAMES",
            "MODULE_COMPONENTS",
            *_component_all,
        ]
        """
    ).strip() + "\n"


def _family_text() -> str:
    return dedent(
        """
        from __future__ import annotations

        from .components import MODULE_COMPONENTS
        from .components import __all__ as _component_all
        from .components import *

        __all__ = ["MODULE_COMPONENTS", *_component_all]
        """
    ).strip() + "\n"


def _root_init_text(modules: list[str], class_names: dict[str, str]) -> str:
    class_imports = ",\n    ".join(class_names[module] for module in modules)
    bind_lines: list[str] = []
    for module in modules:
        cls = class_names[module]
        bind_lines.append(f"Candy.{module}: type[{cls}] = {cls}")
        bind_lines.append(f"Candy.{cls}: type[{cls}] = {cls}")
    module_exports = ",\n    ".join(f'"{class_names[module]}"' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .control import Candy, CandySchemaError, CandyTheme\n"
        "from .submodules import (\n"
        f"    {class_imports},\n"
        ")\n"
        "from .schema import (\n"
        "    EVENTS,\n"
        "    MODULES,\n"
        "    REGISTRY_MANIFEST_LISTS,\n"
        "    REGISTRY_ROLE_ALIASES,\n"
        "    SCHEMA_VERSION,\n"
        "    STATES,\n"
        ")\n\n"
        f"{chr(10).join(bind_lines)}\n\n"
        "__all__ = [\n"
        '    "CandySchemaError",\n'
        '    "CandyTheme",\n'
        '    "Candy",\n'
        '    "SCHEMA_VERSION",\n'
        '    "MODULES",\n'
        '    "STATES",\n'
        '    "EVENTS",\n'
        '    "REGISTRY_ROLE_ALIASES",\n'
        '    "REGISTRY_MANIFEST_LISTS",\n'
        '    "MODULE_COMPONENTS",\n'
        f"    {module_exports},\n"
        "]\n"
    )


def _parse_dart_registry_modules(path: Path, variable_name: str) -> set[str]:
    text = path.read_text(encoding="utf-8")
    pattern = rf"{re.escape(variable_name)}\s*=\s*\{{(.*?)\}};"
    match = re.search(pattern, text, re.S)
    if not match:
        raise RuntimeError(f"Could not parse Dart registry set: {variable_name}")
    return set(re.findall(r"'([a-z0-9_]+)'", match.group(1)))


def main() -> None:
    modules = list(CANDY_MODULES)
    class_names = {module: _pascal(module) for module in modules}
    module_payload_types = _load_module_payload_types()

    SUBMODULES_DIR.mkdir(parents=True, exist_ok=True)

    for file_path in SUBMODULES_DIR.glob("*.py"):
        if file_path.name in SPECIAL_FILES:
            continue
        if file_path.stem not in modules:
            file_path.unlink()

    for module in modules:
        class_name = class_names[module]
        module_keys = sorted(MODULE_ALLOWED_KEYS.get(module, set()))
        module_path = SUBMODULES_DIR / f"{module}.py"
        module_path.write_text(
            _module_text(
                module,
                class_name,
                module_keys,
                module_payload_types.get(module, {}),
            ),
            encoding="utf-8",
        )

    (SUBMODULES_DIR / "components.py").write_text(_components_text(modules, class_names), encoding="utf-8")
    (SUBMODULES_DIR / "__init__.py").write_text(_init_text(), encoding="utf-8")
    (SUBMODULES_DIR / "family.py").write_text(_family_text(), encoding="utf-8")
    ROOT_INIT_PATH.write_text(_root_init_text(modules, class_names), encoding="utf-8")

    dart_modules = _parse_dart_registry_modules(DART_REGISTRY, "candyRegistryModules")
    py_modules = set(modules)
    missing_in_dart = sorted(py_modules - dart_modules)
    missing_in_py = sorted(dart_modules - py_modules)
    if missing_in_dart or missing_in_py:
        raise RuntimeError(
            "Candy Python/Dart registry mismatch: "
            f"missing_in_dart={missing_in_dart}, missing_in_py={missing_in_py}"
        )

    print(f"Wired Candy submodules: {len(modules)} modules")


if __name__ == "__main__":
    main()
