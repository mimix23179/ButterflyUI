from __future__ import annotations

from .rich_text_editor import RichTextEditor

__all__ = ["RTE"]


class RTE(RichTextEditor):
    """Alias for :class:`RichTextEditor` using ``control_type='rte'``."""

    control_type = "rte"

