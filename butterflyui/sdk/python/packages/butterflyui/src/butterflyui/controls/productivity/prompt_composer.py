from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .message_composer import MessageComposer

__all__ = ["PromptComposer"]

class PromptComposer(MessageComposer):
    """
    AI-prompt composer with a labeled send area and optional attachment support.

    A specialization of ``MessageComposer`` tailored for prompt-entry UIs
    (e.g. LLM chat interfaces). Adds ``prompt_label`` to annotate the
    composer with a role or model name. Inherits all ``MessageComposer``
    properties.

    ```python
    import butterflyui as bui

    bui.PromptComposer(
        placeholder="Ask me anything…",
        prompt_label="Copilot",
        clear_on_send=True,
    )
    ```

    Args:
        value:
            Initial text content of the composer.
        placeholder:
            Hint text shown when the composer is empty.
        send_label:
            Label or icon identifier for the send button.
        emit_on_change:
            When ``True`` a change event is emitted on every keystroke.
        clear_on_send:
            When ``True`` the input is cleared after the send action.
        min_lines:
            Minimum number of visible text lines.
        max_lines:
            Maximum number of visible text lines before scrolling.
        show_attach:
            When ``True`` an attachment button is shown.
        prompt_label:
            Label shown above or beside the composer identifying the
            prompt context or AI role.
    """

    control_type = "prompt_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        prompt_label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            prompt_label=prompt_label,
            **kwargs,
        )
        Component.__init__(self, props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def attach(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "attach", {})
