from __future__ import annotations

from common import ensure_artifact_root, load_control_records, write_json


def main() -> None:
    artifact_root = ensure_artifact_root()
    records = load_control_records()
    payload = []
    for record in records:
        payload.append(
            {
                "path": record.rel_path,
                "class": record.name,
                "bases": record.bases,
                "control_type": record.control_type,
                "constructor_style": record.constructor_style,
                "init_category": record.init_category,
                "field_aliases": record.field_aliases,
                "doc_only_fields": record.doc_only_fields,
                "fields": [
                    {
                        "name": field.name,
                        "annotation": field.annotation,
                        "default": field.default,
                        "doc": field.doc,
                        "weak_reasons": record.weak_field_docs.get(field.name, []),
                    }
                    for field in record.fields
                ],
            }
        )

    write_json(artifact_root / "control_specs.json", {"controls": payload})
    print(f"Extracted specs for {len(payload)} controls.")


if __name__ == "__main__":
    main()
