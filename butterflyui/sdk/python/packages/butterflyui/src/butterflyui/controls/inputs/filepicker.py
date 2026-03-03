from __future__ import annotations

from .file_picker import FilePicker

__all__ = ["Filepicker"]


class Filepicker(FilePicker):
    """Alias for :class:`FilePicker` using ``control_type='filepicker'``."""

    control_type = "filepicker"

