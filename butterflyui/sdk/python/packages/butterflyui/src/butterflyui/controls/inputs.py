from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Button",
    "TextField",
    "SearchBar",
    "FilePicker",
    "DirectoryPicker",
    "Checkbox",
    "Switch",
    "Radio",
    "Slider",
    "Select",
    "ChipGroup",
    "TagFilterBar",
]


class Button(Component):
    control_type = "button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        variant: str | None = None,
        window_action: str | None = None,
        window_action_delay_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else label
        merged = merge_props(
            props,
            label=resolved,
            text=resolved,
            value=value,
            variant=variant,
            window_action=window_action,
            window_action_delay_ms=window_action_delay_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class TextField(Component):
    control_type = "text_field"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            label=label,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class SearchBar(Component):
    control_type = "search_bar"

    def __init__(
        self,
        value: str | None = None,
        *,
        query: str | None = None,
        placeholder: str | None = None,
        hint: str | None = None,
        suggestions: list[Any] | None = None,
        filters: list[Any] | None = None,
        debounce_ms: int | None = None,
        show_clear: bool | None = None,
        show_suggestions: bool | None = None,
        max_suggestions: int | None = None,
        loading: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = query if query is not None else value
        merged = merge_props(
            props,
            value=resolved,
            query=resolved,
            placeholder=placeholder,
            hint=hint,
            suggestions=suggestions,
            filters=filters,
            debounce_ms=debounce_ms,
            show_clear=show_clear,
            show_suggestions=show_suggestions,
            max_suggestions=max_suggestions,
            loading=loading,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Checkbox(Component):
    control_type = "checkbox"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        tristate: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            tristate=tristate,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Switch(Component):
    control_type = "switch"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        inline: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            inline=inline,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Radio(Component):
    control_type = "radio"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        index: int | None = None,
        value: Any | None = None,
        label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            index=index,
            value=value,
            label=label,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Slider(Component):
    control_type = "slider"

    def __init__(
        self,
        value: float | None = None,
        *,
        min: float | None = None,
        max: float | None = None,
        divisions: int | None = None,
        label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            min=min,
            max=max,
            divisions=divisions,
            label=label,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Select(Component):
    control_type = "select"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        index: int | None = None,
        value: Any | None = None,
        label: str | None = None,
        hint: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            index=index,
            value=value,
            label=label,
            hint=hint,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class FilePicker(Component):
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


class DirectoryPicker(FilePicker):
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


class ChipGroup(Component):
    control_type = "chip_group"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        value: Any | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            value=value,
            values=values,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class TagFilterBar(Component):
    control_type = "tag_filter_bar"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            values=values,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)



