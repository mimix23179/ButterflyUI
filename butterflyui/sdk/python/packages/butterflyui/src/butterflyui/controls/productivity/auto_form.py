from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["AutoForm"]

class AutoForm(Component):
    """
    Schema-driven form that auto-generates fields from a data schema.

    The runtime renders a complete form based on ``schema`` or an explicit
    ``fields`` list. ``values`` seeds initial field values. ``title`` and
    ``description`` add a header. ``layout`` and ``columns`` control the
    field arrangement. ``dense`` reduces padding; ``show_labels`` toggles
    label visibility; ``label_width`` fixes the label column width.
    ``validation_rules`` declares validation constraints; ``visibility_rules``
    conditionally show or hide fields.

    ```python
    import butterflyui as bui

    bui.AutoForm(
        schema={"name": "string", "age": "number"},
        submit_label="Save",
        events=["submit", "change"],
    )
    ```

    Args:
        schema:
            JSON-schema-style mapping that drives field generation.
        fields:
            Explicit list of field spec mappings, used instead of
            ``schema`` when provided.
        values:
            Initial values mapping keyed by field name.
        title:
            Optional heading displayed above the form.
        description:
            Optional description text below the title.
        submit_label:
            Label for the submit button.
        layout:
            Field layout mode. Values: ``"vertical"``, ``"horizontal"``.
        columns:
            Number of columns in a multi-column field grid.
        dense:
            When ``True`` reduces vertical padding between fields.
        show_labels:
            When ``False`` field labels are hidden.
        label_width:
            Fixed width in logical pixels for the label column.
        validation_rules:
            Mapping of field names to validation rule definitions.
        visibility_rules:
            Mapping of field names to conditional visibility expressions.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "auto_form"

    def __init__(
        self,
        *children: Any,
        schema: Mapping[str, Any] | None = None,
        fields: list[Mapping[str, Any]] | None = None,
        values: Mapping[str, Any] | None = None,
        title: str | None = None,
        description: str | None = None,
        submit_label: str | None = None,
        layout: str | None = None,
        columns: int | None = None,
        dense: bool | None = None,
        show_labels: bool | None = None,
        label_width: float | None = None,
        validation_rules: Mapping[str, Any] | None = None,
        visibility_rules: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            schema=schema,
            fields=fields,
            values=dict(values) if values is not None else None,
            title=title,
            description=description,
            submit_label=submit_label,
            layout=layout,
            columns=columns,
            dense=dense,
            show_labels=show_labels,
            label_width=label_width,
            validation_rules=dict(validation_rules) if validation_rules is not None else None,
            visibility_rules=dict(visibility_rules) if visibility_rules is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def set_values(self, session: Any, values: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": dict(values)})

    def set_field_value(self, session: Any, field: str, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_field_value", {"field": field, "value": value})

    def validate(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "validate", {})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
