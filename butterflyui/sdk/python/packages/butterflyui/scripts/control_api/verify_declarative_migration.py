from __future__ import annotations

import sys

from common import ensure_artifact_root, load_control_records, summarize_counts, write_json, write_markdown


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()
    failures = [
        {
            "path": record.rel_path,
            "class": record.name,
            "constructor_style": record.constructor_style,
        }
        for record in records
        if record.constructor_style == "inline_merge"
    ]

    write_json(
        artifact_root / "verify_declarative_migration.json",
        {
            "constructor_style_counts": summarize_counts(records, attr="constructor_style"),
            "failures": failures,
        },
    )

    lines = [
        "# Constructor Verification",
        "",
        f"- Inline `merge_props(...)` calls inside `super().__init__`: `{len(failures)}`",
        "",
        "## Constructor Styles",
        "",
    ]
    for name, count in summarize_counts(records, attr="constructor_style").items():
        lines.append(f"- `{name}`: `{count}`")
    if failures:
        lines.extend(["", "## Remaining Inline Merge Cases", ""])
        for failure in failures:
            lines.append(f"- [{failure['path']}] `{failure['class']}`")
    write_markdown(artifact_root / "verify_declarative_migration.md", "\n".join(lines))

    if failures:
        print(f"Constructor verification failed with {len(failures)} inline merge cases.")
        sys.exit(1)

    print("Constructor verification passed.")


if __name__ == "__main__":
    main()
