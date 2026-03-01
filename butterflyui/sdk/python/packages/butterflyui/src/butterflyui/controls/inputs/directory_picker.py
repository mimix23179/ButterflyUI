from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .file_picker import FilePicker

__all__ = ["DirectoryPicker"]

class DirectoryPicker(FilePicker):
    """
    File picker pre-configured to select a single directory.

    Convenience subclass of :class:`FilePicker` with ``file_type``,
    ``mode``, and ``pick_directory`` pre-set.  All methods inherited
    from :class:`FilePicker` (``pick``, ``pick_directory``,
    ``get_files``, ``clear``) are available.

    ```python
    import butterflyui as bui

    bui.DirectoryPicker(label="Choose output folder")
    ```

    Args:
        label:
            Button/field label displayed in the UI.
    """
    control_type = "directory_picker"

    def __init__(
        self,
        label: str | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            file_type="directory",
            mode="directory",
            pick_directory=True,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
