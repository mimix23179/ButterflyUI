from __future__ import annotations

import ast
from dataclasses import dataclass
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
CONTROL_ROOT = SCRIPT_DIR.parent / "src" / "butterflyui" / "controls"

MANUAL_FILES = {
    "_shared.py",
    "control.py",
    "layout_control.py",
    "scrollable_control.py",
    "input_control.py",
    "overlay_control.py",
    "scope_control.py",
    "effect_control.py",
}

SKIP_PARAMS = {
    "self",
    "props",
    "strict",
    "children",
    "children_args",
    "children_kwargs",
}

SKIP_FIELD_NAMES: set[str] = set()


@dataclass(frozen=True)
class ClassInfo:
    bases: tuple[str, ...]
    fields: frozenset[str]


def parse_args_section(doc: str) -> dict[str, str]:
    lines = doc.splitlines()
    args: dict[str, list[str]] = {}
    current: str | None = None
    in_args = False
    header_indent: int | None = None

    for raw in lines:
        if raw.strip() == "Args:":
            in_args = True
            current = None
            header_indent = None
            continue
        if not in_args:
            continue
        stripped = raw.strip()
        if not stripped:
            if current is not None and args[current] and args[current][-1] != "":
                args[current].append("")
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        if header_indent is None:
            if indent == 0:
                break
            header_indent = indent
        if indent < header_indent:
            break
        if indent == header_indent and stripped.endswith(":"):
            current = stripped[:-1]
            args[current] = []
            continue
        if current is None:
            continue
        description_indent = header_indent + 4
        text = raw[description_indent:] if indent >= description_indent else stripped
        args[current].append(text.rstrip())

    normalized: dict[str, str] = {}
    for name, doc_lines in args.items():
        while doc_lines and not doc_lines[-1]:
            doc_lines.pop()
        normalized[name] = "\n".join(doc_lines).strip()
    return normalized


def get_explicit_init(class_node: ast.ClassDef) -> ast.FunctionDef | None:
    for node in class_node.body:
        if isinstance(node, ast.FunctionDef) and node.name == "__init__":
            return node
    return None


def collect_merge_props_keywords(init_node: ast.FunctionDef) -> set[str]:
    keywords: set[str] = set()
    for node in ast.walk(init_node):
        if not isinstance(node, ast.Call):
            continue
        func = node.func
        if isinstance(func, ast.Name) and func.id == "merge_props":
            for keyword in node.keywords:
                if keyword.arg:
                    keywords.add(keyword.arg)
    return keywords


def collect_super_init_keywords(init_node: ast.FunctionDef) -> set[str]:
    keywords: set[str] = set()
    for node in ast.walk(init_node):
        if not isinstance(node, ast.Call):
            continue
        func = node.func
        if not (
            isinstance(func, ast.Attribute)
            and func.attr == "__init__"
            and isinstance(func.value, ast.Call)
            and isinstance(func.value.func, ast.Name)
            and func.value.func.id == "super"
        ):
            continue
        for keyword in node.keywords:
            if keyword.arg:
                keywords.add(keyword.arg)
    return keywords


def parameter_metadata(init_node: ast.FunctionDef) -> dict[str, tuple[str, str | None]]:
    params: dict[str, tuple[str, str | None]] = {}

    positional = list(init_node.args.args)
    positional_defaults = [None] * (len(positional) - len(init_node.args.defaults)) + list(
        init_node.args.defaults
    )
    for arg, default in zip(positional, positional_defaults):
        params[arg.arg] = (
            ast.unparse(arg.annotation) if arg.annotation is not None else "Any",
            ast.unparse(default) if default is not None else None,
        )

    for arg, default in zip(init_node.args.kwonlyargs, init_node.args.kw_defaults):
        params[arg.arg] = (
            ast.unparse(arg.annotation) if arg.annotation is not None else "Any",
            ast.unparse(default) if default is not None else None,
        )

    return params


def build_field_block(name: str, annotation: str, default: str | None, doc: str) -> str:
    assignment = f"{name}: {annotation}"
    if default is not None:
        assignment += f" = {default}"

    doc_lines = doc.splitlines() or [f"Documentation for `{name}`."]
    parts = [f"    {assignment}", '    """']
    for line in doc_lines:
        parts.append(f"    {line}" if line else "    ")
    parts.append('    """')
    return "\n".join(parts)


def _base_name(base: ast.expr) -> str:
    if isinstance(base, ast.Name):
        return base.id
    if isinstance(base, ast.Attribute):
        return base.attr
    return ast.unparse(base)


def build_class_index() -> dict[str, ClassInfo]:
    index: dict[str, ClassInfo] = {}
    for path in sorted(CONTROL_ROOT.rglob("*.py")):
        if path.name == "__init__.py":
            continue
        source = path.read_text(encoding="utf-8-sig")
        tree = ast.parse(source)
        for node in tree.body:
            if not isinstance(node, ast.ClassDef):
                continue
            index[node.name] = ClassInfo(
                bases=tuple(_base_name(base) for base in node.bases),
                fields=frozenset(
                    child.target.id
                    for child in node.body
                    if isinstance(child, ast.AnnAssign)
                    and isinstance(child.target, ast.Name)
                ),
            )
    return index


CLASS_INDEX = build_class_index()


def inherited_field_names(class_name: str, seen: set[str] | None = None) -> set[str]:
    info = CLASS_INDEX.get(class_name)
    if info is None:
        return set()

    seen = set() if seen is None else set(seen)
    fields: set[str] = set()
    for base in info.bases:
        if base in seen:
            continue
        base_info = CLASS_INDEX.get(base)
        if base_info is None:
            continue
        seen.add(base)
        fields.update(base_info.fields)
        fields.update(inherited_field_names(base, seen))
    return fields


def generate_class_fields(source: str, class_node: ast.ClassDef) -> str | None:
    init_node = get_explicit_init(class_node)
    if init_node is None:
        return None

    doc = ast.get_docstring(class_node)
    if not doc or "Args:" not in doc:
        return None

    args_docs = parse_args_section(doc)
    if not args_docs:
        return None

    field_names = collect_merge_props_keywords(init_node) | collect_super_init_keywords(
        init_node
    )
    if not field_names:
        return None

    params = parameter_metadata(init_node)
    existing_annassigns = {
        node.target.id
        for node in class_node.body
        if isinstance(node, ast.AnnAssign) and isinstance(node.target, ast.Name)
    }
    inherited_fields = inherited_field_names(class_node.name)

    field_blocks: list[str] = []
    for name, doc_text in args_docs.items():
        if not doc_text:
            continue
        if name in SKIP_PARAMS or name in SKIP_FIELD_NAMES:
            continue
        if name not in field_names:
            continue
        if name in existing_annassigns:
            continue
        if name in inherited_fields:
            continue
        if name not in params:
            continue
        annotation, default = params[name]
        field_blocks.append(build_field_block(name, annotation, default, doc_text))

    if not field_blocks:
        return None

    doc_node = class_node.body[0]
    assert isinstance(doc_node, ast.Expr)
    lines = source.splitlines()
    insertion_index = doc_node.end_lineno

    block = "\n\n" + "\n\n".join(field_blocks) + "\n"
    new_lines = lines[:insertion_index] + block.splitlines() + lines[insertion_index:]
    return "\n".join(new_lines) + ("\n" if source.endswith("\n") else "")


def process_file(path: Path) -> bool:
    rel = path.relative_to(CONTROL_ROOT)
    if rel.as_posix() in MANUAL_FILES or rel.name in MANUAL_FILES:
        return False

    source = path.read_text(encoding="utf-8-sig")
    tree = ast.parse(source)
    class_nodes = [node for node in tree.body if isinstance(node, ast.ClassDef)]
    if not class_nodes:
        return False

    updated = source
    changed = False
    for class_node in sorted(class_nodes, key=lambda node: node.lineno, reverse=True):
        next_source = generate_class_fields(updated, class_node)
        if next_source is None:
            continue
        updated = next_source
        changed = True

    if changed:
        path.write_text(updated, encoding="utf-8")
    return changed


def main() -> None:
    changed_files: list[str] = []
    for path in sorted(CONTROL_ROOT.rglob("*.py")):
        if path.name == "__init__.py":
            continue
        if process_file(path):
            changed_files.append(str(path.relative_to(CONTROL_ROOT)))

    print(f"Updated {len(changed_files)} control files.")
    for rel_path in changed_files:
        print(rel_path)


if __name__ == "__main__":
    main()
