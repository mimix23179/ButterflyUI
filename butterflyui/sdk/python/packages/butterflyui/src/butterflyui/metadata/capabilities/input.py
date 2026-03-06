from __future__ import annotations

INPUT_PROPS = (
    "value",
    "label",
    "placeholder",
    "helper_text",
    "error_text",
    "read_only",
    "dense",
)

FORM_FIELD_PROPS = (
    "name",
    "required",
    "debounce_ms",
    "helper",
    "error",
)

__all__ = ["FORM_FIELD_PROPS", "INPUT_PROPS"]
