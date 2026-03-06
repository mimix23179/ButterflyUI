from __future__ import annotations

from common import (
    control_records_as_json,
    ensure_artifact_root,
    load_control_records,
    summarize_counts,
    write_json,
    write_markdown,
)


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()

    write_json(
        artifact_root / "control_inventory.json",
        {"controls": control_records_as_json(records)},
    )

    init_counts = summarize_counts(records, attr="init_category")
    style_counts = summarize_counts(records, attr="constructor_style")
    lines = [
        "# Control Inventory",
        "",
        f"- Controls scanned: `{len(records)}`",
        f"- Controls with `__init__`: `{sum(1 for record in records if record.has_init)}`",
        "",
        "## Init Categories",
        "",
    ]
    for name, count in init_counts.items():
        lines.append(f"- `{name}`: `{count}`")
    lines.extend(["", "## Constructor Styles", ""])
    for name, count in style_counts.items():
        lines.append(f"- `{name}`: `{count}`")

    write_markdown(artifact_root / "control_inventory.md", "\n".join(lines))
    print(f"Wrote inventory for {len(records)} controls.")


if __name__ == "__main__":
    main()
