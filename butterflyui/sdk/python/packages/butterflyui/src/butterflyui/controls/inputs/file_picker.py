from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FilePicker"]

class FilePicker(Component):
    """
    Native file and directory picker button.

    Renders a button (or inline trigger widget) that opens the
    platform’s native file-picker dialog when tapped or when
    :meth:`pick` / :meth:`pick_files` is called from Python.  The
    result is returned via an ``"result"`` runtime event and can also
    be fetched imperatively with :meth:`get_files`.  Setting
    ``save_file`` switches the dialog to save mode.

    ```python
    import butterflyui as bui

    picker = bui.FilePicker(
        label="Choose CSV",
        file_type="any",
        extensions=["csv"],
        multiple=False,
    )
    ```

    Args:
        label:
            Button / field label displayed in the UI.
        file_type:
            MIME category hint — e.g. ``"image"``, ``"video"``,
            ``"audio"``, ``"any"``.
        extensions:
            List of allowed extensions without the dot
            (e.g. ``["txt", "md"]``).
        allowed_extensions:
            Alias for ``extensions``.
        multiple:
            If ``True``, the user can select multiple files.
        allow_multiple:
            Alias for ``multiple``.
        with_data:
            If ``True``, file bytes are included in the result payload.
        with_path:
            If ``True``, absolute file paths are included in the result
            payload.
        enabled:
            If ``False``, the picker is non-interactive.
        mode:
            Picker mode override — ``"open"``, ``"save"``, or
            ``"directory"``.
        pick_directory:
            If ``True``, forces directory-selection mode.
        save_file:
            If ``True``, the dialog opens in save mode.
        file_name:
            Default file name pre-filled in save dialogs.
        dialog_title:
            Title string shown in the native file-picker dialog.
        initial_directory:
            Absolute path of the directory the dialog starts in.
        lock_parent_window:
            If ``True``, the parent window is blocked while the picker
            dialog is open (Windows only).
    """
    control_type = "file_picker"

    def __init__(
        self,
        label: str | None = None,
        *,
        file_type: str | None = None,
        extensions: list[str] | None = None,
        allowed_extensions: list[str] | None = None,
        multiple: bool | None = None,
        allow_multiple: bool | None = None,
        with_data: bool | None = None,
        with_path: bool | None = None,
        enabled: bool | None = None,
        mode: str | None = None,
        pick_directory: bool | None = None,
        save_file: bool | None = None,
        file_name: str | None = None,
        dialog_title: str | None = None,
        initial_directory: str | None = None,
        lock_parent_window: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_extensions = (
            extensions if extensions is not None else allowed_extensions
        )
        merged = merge_props(
            props,
            label=label,
            file_type=file_type,
            extensions=resolved_extensions,
            allowed_extensions=resolved_extensions,
            multiple=multiple if multiple is not None else allow_multiple,
            allow_multiple=allow_multiple if allow_multiple is not None else multiple,
            with_data=with_data,
            with_path=with_path,
            enabled=enabled,
            mode=mode,
            pick_directory=pick_directory,
            save_file=save_file,
            file_name=file_name,
            dialog_title=dialog_title,
            initial_directory=initial_directory,
            lock_parent_window=lock_parent_window,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

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
