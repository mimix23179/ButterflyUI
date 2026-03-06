from __future__ import annotations

import ast

from common import (
    CONTROL_ROOT,
    ensure_artifact_root,
    format_merge_assignment,
    iter_control_files,
    read_source,
    replace_source_span,
    source_indent_for_line,
    write_markdown,
    write_source,
)


def main() -> None:
    artifact_root = ensure_artifact_root()
    changed: list[str] = []

    for path in iter_control_files():
        source = read_source(path)
        tree = ast.parse(source)
        updated = source
        file_changed = False

        class_nodes = [node for node in tree.body if isinstance(node, ast.ClassDef)]
        for class_node in class_nodes:
            init_node = next(
                (node for node in class_node.body if isinstance(node, ast.FunctionDef) and node.name == "__init__"),
                None,
            )
            if init_node is None:
                continue
            body_calls = [
                node
                for node in init_node.body
                if isinstance(node, ast.Expr) and isinstance(node.value, ast.Call)
            ]
            for expr_node in reversed(body_calls):
                call = expr_node.value
                if not (
                    isinstance(call.func, ast.Attribute)
                    and call.func.attr == "__init__"
                    and isinstance(call.func.value, ast.Call)
                    and isinstance(call.func.value.func, ast.Name)
                    and call.func.value.func.id == "super"
                ):
                    continue
                props_kw = next((kw for kw in call.keywords if kw.arg == "props"), None)
                if props_kw is None or not isinstance(props_kw.value, ast.Call):
                    continue
                if not (isinstance(props_kw.value.func, ast.Name) and props_kw.value.func.id == "merge_props"):
                    continue
                if "merged = merge_props(" in ast.get_source_segment(updated, init_node):
                    continue

                merge_segment = ast.get_source_segment(updated, props_kw.value)
                if not merge_segment:
                    continue
                indent = source_indent_for_line(updated, expr_node.lineno)
                assignment = format_merge_assignment(merge_segment, indent=indent)
                updated = replace_source_span(
                    updated,
                    start_line=props_kw.value.lineno,
                    start_col=props_kw.value.col_offset,
                    end_line=props_kw.value.end_lineno,
                    end_col=props_kw.value.end_col_offset,
                    replacement="merged",
                )
                updated = replace_source_span(
                    updated,
                    start_line=expr_node.lineno,
                    start_col=0,
                    end_line=expr_node.lineno,
                    end_col=0,
                    replacement=assignment + "\n",
                )
                file_changed = True
                break

        if file_changed and updated != source:
            write_source(path, updated)
            changed.append(path.relative_to(CONTROL_ROOT).as_posix())

    lines = [
        "# Constructor Standardization Report",
        "",
        f"- Files updated: `{len(changed)}`",
        "",
    ]
    for rel_path in changed:
        lines.append(f"- `{rel_path}`")
    write_markdown(artifact_root / "constructor_standardization_report.md", "\n".join(lines))
    print(f"Standardized constructors in {len(changed)} files.")


if __name__ == "__main__":
    main()
