from __future__ import annotations

from .editor_workspace import EditorWorkspace

__all__ = ["WorkbenchEditor"]


class WorkbenchEditor(EditorWorkspace):
    """Alias for :class:`EditorWorkspace` using ``control_type='workbench_editor'``."""

    control_type = "workbench_editor"

