from __future__ import annotations

from .code_view import CodeView

__all__ = ["Code"]


class Code(CodeView):
    """Alias for :class:`CodeView` using ``control_type='code'``."""

    control_type = "code"

