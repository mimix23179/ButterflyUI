from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .file_picker import FilePicker
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["DirectoryPicker"]

@butterfly_control('directory_picker', positional_fields=('label',))
class DirectoryPicker(FormFieldControl):
    """
    File picker pre-configured to select a single directory.

    Convenience subclass of :class:`FilePicker` with ``file_type``,
    ``mode``, and ``pick_directory`` pre-set.  All methods inherited
    from :class:`FilePicker` (``pick``, ``pick_directory``,
    ``get_files``, ``clear``) are available.

    Example:

    ```python
    import butterflyui as bui

    bui.DirectoryPicker(label="Choose output folder")
    ```
    """

    mode: Any | None = None
    """
    Mode value forwarded to the `directory_picker` runtime control.
    """

    pick_directory: Any | None = None
    """
    Pick directory value forwarded to the `directory_picker` runtime control.
    """

    initial_directory: Any | None = None
    """
    Initial directory value forwarded to the `directory_picker` runtime control.
    """

    dialog_title: Any | None = None
    """
    Dialog title value forwarded to the `directory_picker` runtime control.
    """

    lock_parent_window: Any | None = None
    """
    Lock parent window value forwarded to the `directory_picker` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `directory_picker` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `directory_picker` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `directory_picker` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `directory_picker` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `directory_picker` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `directory_picker` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `directory_picker` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `directory_picker` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `directory_picker` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `directory_picker` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `directory_picker` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `directory_picker` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `directory_picker` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `directory_picker` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `directory_picker` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `directory_picker` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `directory_picker` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `directory_picker` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `directory_picker` runtime control.
    """
