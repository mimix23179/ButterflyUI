from __future__ import annotations

import sys

from common import ensure_artifact_root, load_control_records, write_json, write_markdown


def count_arg_entries(doc: str, arg_name: str) -> int:
    return sum(1 for line in doc.splitlines() if line.strip() == f"{arg_name}:")


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()
    failures: list[dict[str, object]] = []
    warnings: list[dict[str, object]] = []

    for record in records:
        for field in record.fields:
            if not field.doc.strip():
                failures.append(
                    {
                        "path": record.rel_path,
                        "class": record.name,
                        "field": field.name,
                        "reason": "missing_field_doc",
                    }
                )
        for field_name, reasons in record.weak_field_docs.items():
            target = warnings if set(reasons) == {"too_short"} else failures
            target.append(
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "field": field_name,
                    "reason": f"weak_field_doc:{','.join(reasons)}",
                }
            )
        for arg_name, reasons in record.weak_args_docs.items():
            target = warnings if set(reasons) == {"too_short"} else failures
            target.append(
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "field": arg_name,
                    "reason": f"weak_args_doc:{','.join(reasons)}",
                }
            )
        if count_arg_entries(record.class_doc, "events") > 1:
            failures.append(
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "field": "Args",
                    "reason": "duplicate_events_entry",
                }
            )

    write_json(
        artifact_root / "verify_field_doc_quality.json",
        {"failures": failures, "warnings": warnings},
    )
    lines = [
        "# Field Doc Quality Verification",
        "",
        f"- Failures: `{len(failures)}`",
        f"- Warnings: `{len(warnings)}`",
        "",
    ]
    for failure in failures[:500]:
        lines.append(
            f"- [{failure['path']}] `{failure['class']}.{failure['field']}`: "
            f"`{failure['reason']}`"
        )
    if warnings:
        lines.extend(["", "## Warnings", ""])
        for warning in warnings[:500]:
            lines.append(
                f"- [{warning['path']}] `{warning['class']}.{warning['field']}`: "
                f"`{warning['reason']}`"
            )
    write_markdown(artifact_root / "verify_field_doc_quality.md", "\n".join(lines))

    if failures:
        print(f"Field doc verification failed with {len(failures)} issues.")
        sys.exit(1)

    print("Field doc verification passed.")


if __name__ == "__main__":
    main()
