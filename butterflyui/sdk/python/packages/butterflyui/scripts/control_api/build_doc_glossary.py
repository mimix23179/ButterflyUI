from __future__ import annotations

from common import (
    BOOL_FIELD_HINTS,
    GENERIC_FIELD_DOCS,
    STATE_STYLE_DOCS,
    TOKEN_BUCKET_TEMPLATES,
    ensure_artifact_root,
    write_json,
)


def main() -> None:
    artifact_root = ensure_artifact_root()
    payload = {
        "generic_fields": GENERIC_FIELD_DOCS,
        "state_styles": STATE_STYLE_DOCS,
        "boolean_fields": BOOL_FIELD_HINTS,
        "token_buckets": TOKEN_BUCKET_TEMPLATES,
    }
    write_json(artifact_root / "doc_glossary.json", payload)
    print("Wrote doc glossary.")


if __name__ == "__main__":
    main()
