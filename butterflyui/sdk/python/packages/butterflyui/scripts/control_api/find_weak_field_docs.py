from __future__ import annotations

from collections import Counter

from common import ensure_artifact_root, load_control_records, write_json, write_markdown


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()
    issues: list[dict[str, object]] = []
    counter: Counter[str] = Counter()

    for record in records:
        for field_name, reasons in record.weak_field_docs.items():
            issues.append(
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "field": field_name,
                    "kind": "field",
                    "reasons": reasons,
                }
            )
            counter.update(reasons)
        for arg_name, reasons in record.weak_args_docs.items():
            issues.append(
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "field": arg_name,
                    "kind": "arg",
                    "reasons": reasons,
                }
            )
            counter.update(reasons)

    issues.sort(key=lambda item: (item["path"], item["class"], item["field"], item["kind"]))
    write_json(artifact_root / "weak_field_docs.json", {"issues": issues, "counts": dict(counter)})

    lines = [
        "# Weak Field Docs",
        "",
        f"- Issues found: `{len(issues)}`",
        "",
        "## Reason Counts",
        "",
    ]
    for name, count in sorted(counter.items(), key=lambda item: (-item[1], item[0])):
        lines.append(f"- `{name}`: `{count}`")
    lines.extend(["", "## Samples", ""])
    for issue in issues[:100]:
        reasons = ", ".join(f"`{reason}`" for reason in issue["reasons"])
        lines.append(
            f"- [{issue['path']}] `{issue['class']}.{issue['field']}` "
            f"({issue['kind']}): {reasons}"
        )

    write_markdown(artifact_root / "weak_field_docs.md", "\n".join(lines))
    print(f"Flagged {len(issues)} weak docs.")


if __name__ == "__main__":
    main()
