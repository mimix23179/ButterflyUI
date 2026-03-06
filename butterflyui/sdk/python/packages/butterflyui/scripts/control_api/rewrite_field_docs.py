from __future__ import annotations

import ast

from common import (
    CONTROL_ROOT,
    ensure_artifact_root,
    iter_control_files,
    parse_args_section,
    read_source,
    render_class_docstring,
    render_doc_block,
    replace_args_section,
    replace_line_block,
    replace_source_span,
    rewrite_doc_text,
    write_markdown,
    write_source,
)


def main() -> None:
    artifact_root = ensure_artifact_root()
    changed_files: list[str] = []
    changed_docs: list[str] = []

    for path in iter_control_files():
        source = read_source(path)
        tree = ast.parse(source)
        updated = source
        changed = False

        class_nodes = [node for node in tree.body if isinstance(node, ast.ClassDef)]
        for class_node in sorted(class_nodes, key=lambda node: node.lineno, reverse=True):
            body = class_node.body
            args_replacements: dict[str, str] = {}
            field_annotations = {
                node.target.id: ast.unparse(node.annotation)
                for node in body
                if isinstance(node, ast.AnnAssign) and isinstance(node.target, ast.Name)
            }

            for index in range(len(body) - 1, -1, -1):
                node = body[index]
                if not isinstance(node, ast.AnnAssign) or not isinstance(node.target, ast.Name):
                    continue
                name = node.target.id
                annotation = field_annotations.get(name, "Any")
                follower = body[index + 1] if index + 1 < len(body) else None
                follower_is_doc = (
                    isinstance(follower, ast.Expr)
                    and isinstance(follower.value, ast.Constant)
                    and isinstance(follower.value.value, str)
                )
                current_doc = follower.value.value.strip() if follower_is_doc else ""
                rewritten = rewrite_doc_text(name, current_doc, class_node.name, annotation)
                if rewritten is None or rewritten == current_doc:
                    continue
                if follower_is_doc:
                    updated = replace_line_block(
                        updated,
                        follower.lineno,
                        follower.end_lineno,
                        render_doc_block(rewritten, indent=node.col_offset),
                    )
                else:
                    updated = replace_source_span(
                        updated,
                        start_line=node.end_lineno + 1,
                        start_col=0,
                        end_line=node.end_lineno + 1,
                        end_col=0,
                        replacement=render_doc_block(rewritten, indent=node.col_offset) + "\n",
                    )
                args_replacements[name] = rewritten
                changed_docs.append(
                    f"{path.relative_to(CONTROL_ROOT).as_posix()}::{class_node.name}.{name}"
                )
                changed = True

            doc_node = body[0] if body else None
            if (
                isinstance(doc_node, ast.Expr)
                and isinstance(doc_node.value, ast.Constant)
                and isinstance(doc_node.value.value, str)
            ):
                original_doc = ast.get_docstring(class_node) or ""
                order, args_docs = parse_args_section(original_doc)
                if order:
                    replacements = dict(args_docs)
                    for arg_name, arg_doc in args_docs.items():
                        rewritten = rewrite_doc_text(
                            arg_name,
                            arg_doc,
                            class_node.name,
                            field_annotations.get(arg_name, "Any"),
                        )
                        if rewritten is None or rewritten == arg_doc:
                            continue
                        replacements[arg_name] = rewritten
                        changed_docs.append(
                            f"{path.relative_to(CONTROL_ROOT).as_posix()}::{class_node.name}.{arg_name} (arg)"
                        )
                        changed = True
                    replacements.update(args_replacements)
                    new_doc = replace_args_section(original_doc, replacements)
                    if new_doc != original_doc:
                        updated = replace_line_block(
                            updated,
                            doc_node.lineno,
                            doc_node.end_lineno,
                            render_class_docstring(new_doc, indent=doc_node.col_offset),
                        )
                        changed = True

        if changed and updated != source:
            write_source(path, updated)
            changed_files.append(path.relative_to(CONTROL_ROOT).as_posix())

    report_lines = [
        "# Rewrite Report",
        "",
        f"- Files updated: `{len(changed_files)}`",
        f"- Field/arg docs rewritten: `{len(changed_docs)}`",
        "",
    ]
    for entry in changed_docs[:500]:
        report_lines.append(f"- `{entry}`")
    write_markdown(artifact_root / "rewrite_report.md", "\n".join(report_lines))
    print(f"Rewrote docs in {len(changed_files)} files.")


if __name__ == "__main__":
    main()
