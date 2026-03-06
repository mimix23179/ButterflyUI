from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["FilePicker"]

@butterfly_control('file_picker', positional_fields=('label',))
class FilePicker(FormFieldControl):
    """
    Native file and directory picker button.

    Renders a button (or inline trigger widget) that opens the
    platform’s native file-picker dialog when tapped or when
    :meth:`pick` / :meth:`pick_files` is called from Python.  The
    result is returned via an ``"result"`` runtime event and can also
    be fetched imperatively with :meth:`get_files`.  Setting
    ``save_file`` switches the dialog to save mode.

    Example:

    ```python
    import butterflyui as bui

    picker = bui.FilePicker(
        label="Choose CSV",
        file_type="any",
        extensions=["csv"],
        multiple=False,
    )
    ```
    """

    file_type: str | None = None
    """
    MIME category hint — e.g. ``"image"``, ``"video"``,
    ``"audio"``, ``"any"``.
    """

    extensions: list[str] | None = None
    """
    List of allowed extensions without the dot
    (e.g. ``["txt", "md"]``).
    """

    allowed_extensions: list[str] | None = None
    """
    Backward-compatible alias for ``extensions``. When both fields are provided, ``extensions`` takes precedence and this alias is kept only for compatibility.
    """

    multiple: bool | None = None
    """
    If ``True``, the user can select multiple files.
    """

    allow_multiple: bool | None = None
    """
    Backward-compatible alias for ``multiple``. When both fields are provided, ``multiple`` takes precedence and this alias is kept only for compatibility.
    """

    with_data: bool | None = None
    """
    If ``True``, file bytes are included in the result payload.
    """

    with_path: bool | None = None
    """
    If ``True``, absolute file paths are included in the result
    payload.
    """

    mode: str | None = None
    """
    Picker mode override — ``"open"``, ``"save"``, or
    ``"directory"``.
    """

    pick_directory: bool | None = None
    """
    If ``True``, forces directory-selection mode.
    """

    save_file: bool | None = None
    """
    If ``True``, the dialog opens in save mode.
    """

    file_name: str | None = None
    """
    Default file name pre-filled in save dialogs.
    """

    dialog_title: str | None = None
    """
    Title string shown in the native file-picker dialog.
    """

    initial_directory: str | None = None
    """
    Absolute path of the directory the dialog starts in.
    """

    lock_parent_window: bool | None = None
    """
    If ``True``, the parent window is blocked while the picker
    dialog is open (Windows only).
    """

    show_selection: Any | None = None
    """
    Show selection value forwarded to the `file_picker` runtime control.
    """

    def pick(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pick", {})

    def pick_files(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pick_files", {})

    def pick_directory(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pick_directory", {})

    def save(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "save_file", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_files(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_files", {})
