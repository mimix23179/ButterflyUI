from __future__ import annotations

from collections import Counter

from common import ensure_artifact_root, load_control_records, write_json, write_markdown


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()
    controls = [record for record in records if record.has_init]
    counts = Counter(record.init_category for record in controls)

    write_json(
        artifact_root / "init_pattern_inventory.json",
        {
            "counts": dict(counts),
            "controls": [
                {
                    "path": record.rel_path,
                    "class": record.name,
                    "init_category": record.init_category,
                    "constructor_style": record.constructor_style,
                    "params": record.init_params,
                }
                for record in controls
            ],
        },
    )

    lines = [
        "# Init Pattern Inventory",
        "",
        f"- Controls with `__init__`: `{len(controls)}`",
        "",
        "## Categories",
        "",
    ]
    for name, count in sorted(counts.items(), key=lambda item: (-item[1], item[0])):
        lines.append(f"- `{name}`: `{count}`")
    write_markdown(artifact_root / "init_pattern_inventory.md", "\n".join(lines))
    print(f"Classified {len(controls)} control constructors.")


if __name__ == "__main__":
    main()
