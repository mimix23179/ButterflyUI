from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["Option"]

@butterfly_control('option', positional_fields=('label',))
class Option(FormFieldControl):
    """
    Single selectable option item for use inside list or select controls.

    Renders a ``ListTile``-style item with an optional leading icon,
    description subtitle, and checkbox/radio indicator depending on
    the parent context.  Tapping the item emits a ``select`` event
    carrying ``label`` and ``value``.  Setting ``selected`` pre-checks
    the item; setting ``enabled`` to ``False`` makes it non-interactive.

    Example:

    ```python
    import butterflyui as bui

    bui.Option(
        "Python",
        value="python",
        description="General-purpose scripting language",
        icon="code",
    )
    ```
    """

    description: str | None = None
    """
    Secondary subtitle text rendered below the label.
    """

    selected: bool | None = None
    """
    If ``True``, the option is pre-selected.
    """

    def emit(self, session: Any, event: str = "select", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
