from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Button",
    "AsyncActionButton",
    "TextField",
    "TextArea",
    "TextFieldStyle",
    "NumericField",
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
    "DatePicker",
    "TimeSelect",
    "DateRangePicker",
    "MultiSelect",
    "Combobox",
    "ComboBox",
    "Dropdown",
    "EmojiPicker",
    "Filepicker",
    "FilterChipsBar",
    "MultiPick",
    "DateSelect",
    "DateRange",
    "DateSpan",
    "CheckList",
    "Chip",
    "TagChip",
    "CountStepper",
    "ElevatedButton",
    "IconButton",
    "IconPicker",
    "KeybindRecorder",
    "FieldGroup",
    "FilterDrawer",
    "Option",
    "SelectOption",
    "PathField",
    "SegmentBar",
    "SegmentedSwitch",
    "SpanSlider",
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


class AsyncActionButton(Button):
    control_type = "async_action_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        variant: str | None = None,
        busy: bool | None = None,
        loading: bool | None = None,
        disabled_while_busy: bool | None = None,
        busy_label: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant=variant,
            props=merge_props(
                props,
                busy=busy if busy is not None else loading,
                loading=loading if loading is not None else busy,
                disabled_while_busy=disabled_while_busy,
                busy_label=busy_label,
                events=events,
            ),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_busy(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_busy", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


class TextArea(Component):
    control_type = "text_area"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        label: str | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        enabled: bool | None = None,
        read_only: bool | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        events: list[str] | None = None,
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
            multiline=True,
            min_lines=min_lines,
            max_lines=max_lines,
            enabled=enabled,
            read_only=read_only,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TextFieldStyle(Component):
    control_type = "text_field_style"

    def __init__(
        self,
        *,
        variant: str | None = None,
        dense: bool | None = None,
        filled: bool | None = None,
        outlined: bool | None = None,
        radius: float | None = None,
        border_width: float | None = None,
        color: Any | None = None,
        border_color: Any | None = None,
        hint_color: Any | None = None,
        label_color: Any | None = None,
        text_color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            dense=dense,
            filled=filled,
            outlined=outlined,
            radius=radius,
            border_width=border_width,
            color=color,
            border_color=border_color,
            hint_color=hint_color,
            label_color=label_color,
            text_color=text_color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_variant(self, session: Any, variant: str) -> dict[str, Any]:
        return self.invoke(session, "set_variant", {"variant": variant})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class NumericField(Component):
    control_type = "numeric_field"

    def __init__(
        self,
        value: float | int | None = None,
        *,
        min: float | None = None,
        max: float | None = None,
        step: float | None = None,
        decimals: int | None = None,
        placeholder: str | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
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
            step=step,
            decimals=decimals,
            placeholder=placeholder,
            label=label,
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Option(Component):
    control_type = "option"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        description: str | None = None,
        icon: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            value=value,
            description=description,
            icon=icon,
            selected=selected,
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "select", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class SelectOption(Option):
    control_type = "select_option"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        description: str | None = None,
        icon: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            value=value,
            description=description,
            icon=icon,
            selected=selected,
            enabled=enabled,
            dense=dense,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class PathField(Component):
    control_type = "path_field"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        mode: str | None = None,
        file_type: str | None = None,
        extensions: list[str] | None = None,
        suggested_name: str | None = None,
        show_browse: bool | None = None,
        show_clear: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            placeholder=placeholder,
            mode=mode,
            file_type=file_type,
            extensions=extensions,
            suggested_name=suggested_name,
            show_browse=show_browse,
            show_clear=show_clear,
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


class SegmentedSwitch(Switch):
    control_type = "segmented_switch"

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
        super().__init__(
            value=value,
            label=label,
            inline=inline,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


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


class SegmentBar(Select):
    control_type = "segment_bar"

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
        super().__init__(
            options=options,
            index=index,
            value=value,
            label=label,
            hint=hint,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


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


class Filepicker(FilePicker):
    control_type = "filepicker"

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
        super().__init__(
            label=label,
            file_type=file_type,
            extensions=extensions,
            allowed_extensions=allowed_extensions,
            multiple=multiple,
            allow_multiple=allow_multiple,
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
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


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

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class FilterChipsBar(TagFilterBar):
    control_type = "filter_chips_bar"

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
        super().__init__(
            options=options,
            values=values,
            multi_select=multi_select,
            dense=dense,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class CheckList(Component):
    control_type = "check_list"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            values=values,
            dense=dense,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class SpanSlider(Component):
    control_type = "span_slider"

    def __init__(
        self,
        *,
        start: float | int | None = None,
        end: float | int | None = None,
        min: float | int | None = None,
        max: float | int | None = None,
        divisions: int | None = None,
        enabled: bool | None = None,
        labels: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            start=start,
            end=end,
            min=min,
            max=max,
            divisions=divisions,
            enabled=enabled,
            labels=labels,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, *, start: float | int, end: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"start": float(start), "end": float(end)})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Chip(Component):
    control_type = "chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            value=value,
            selected=selected,
            enabled=enabled,
            dismissible=dismissible,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TagChip(Component):
    control_type = "tag_chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        icon: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            value=value,
            selected=selected,
            enabled=enabled,
            dismissible=dismissible,
            color=color,
            icon=icon,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class CountStepper(Component):
    control_type = "count_stepper"

    def __init__(
        self,
        *,
        value: int | float | None = None,
        min: int | float | None = None,
        max: int | float | None = None,
        step: int | float | None = None,
        wrap: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
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
            step=step,
            wrap=wrap,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: int | float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def increment(self, session: Any, amount: int | float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if amount is not None:
            payload["amount"] = amount
        return self.invoke(session, "increment", payload)

    def decrement(self, session: Any, amount: int | float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if amount is not None:
            payload["amount"] = amount
        return self.invoke(session, "decrement", payload)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class DatePicker(Component):
    control_type = "date_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TimeSelect(Component):
    control_type = "time_select"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        minute_step: int | None = None,
        use_24h: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            placeholder=placeholder,
            minute_step=minute_step,
            use_24h=use_24h,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class DateRangePicker(Component):
    control_type = "date_range_picker"

    def __init__(
        self,
        *,
        start: str | None = None,
        end: str | None = None,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            start=start,
            end=end,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, start: str | None = None, end: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if start is not None:
            payload["start"] = start
        if end is not None:
            payload["end"] = end
        return self.invoke(session, "set_value", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class MultiSelect(Component):
    control_type = "multi_select"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        selected: list[Any] | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            values=values if values is not None else selected,
            selected=selected if selected is not None else values,
            label=label,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class MultiPick(MultiSelect):
    control_type = "multi_pick"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        selected: list[Any] | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            options=options,
            values=values,
            selected=selected,
            label=label,
            enabled=enabled,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class Combobox(Component):
    control_type = "combobox"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        groups: list[Mapping[str, Any]] | None = None,
        label: str | None = None,
        hint: str | None = None,
        placeholder: str | None = None,
        loading: bool | None = None,
        async_source: str | None = None,
        debounce_ms: int | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options if options is not None else items,
            items=items,
            groups=[dict(group) for group in (groups or [])],
            label=label,
            hint=hint if hint is not None else placeholder,
            placeholder=placeholder,
            loading=loading,
            async_source=async_source,
            debounce_ms=debounce_ms,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def set_loading(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_loading", {"value": bool(value)})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ComboBox(Combobox):
    control_type = "combo_box"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        groups: list[Mapping[str, Any]] | None = None,
        label: str | None = None,
        hint: str | None = None,
        placeholder: str | None = None,
        loading: bool | None = None,
        async_source: str | None = None,
        debounce_ms: int | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            options=options,
            items=items,
            groups=groups,
            label=label,
            hint=hint,
            placeholder=placeholder,
            loading=loading,
            async_source=async_source,
            debounce_ms=debounce_ms,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class Dropdown(Combobox):
    control_type = "dropdown"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        groups: list[Mapping[str, Any]] | None = None,
        label: str | None = None,
        hint: str | None = None,
        placeholder: str | None = None,
        loading: bool | None = None,
        async_source: str | None = None,
        debounce_ms: int | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            options=options,
            items=items,
            groups=groups,
            label=label,
            hint=hint,
            placeholder=placeholder,
            loading=loading,
            async_source=async_source,
            debounce_ms=debounce_ms,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class DateSelect(DatePicker):
    control_type = "date_select"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class DateRange(DateRangePicker):
    control_type = "date_range"

    def __init__(
        self,
        *,
        start: str | None = None,
        end: str | None = None,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            start=start,
            end=end,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class DateSpan(DateRangePicker):
    control_type = "date_span"

    def __init__(
        self,
        *,
        start: str | None = None,
        end: str | None = None,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            start=start,
            end=end,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class EmojiPicker(Component):
    control_type = "emoji_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        categories: list[str] | None = None,
        recent: list[str] | None = None,
        skin_tone: str | None = None,
        show_search: bool | None = None,
        show_recent: bool | None = None,
        category: str | None = None,
        query: str | None = None,
        include_metadata: bool | None = None,
        recent_limit: int | None = None,
        columns: int | None = None,
        items: list[str] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            categories=categories,
            recent=recent,
            skin_tone=skin_tone,
            show_search=show_search,
            show_recent=show_recent,
            category=category,
            query=query,
            include_metadata=include_metadata,
            recent_limit=recent_limit,
            columns=columns,
            items=items,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_category(self, session: Any, category: str) -> dict[str, Any]:
        return self.invoke(session, "set_category", {"category": category})

    def search(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "search", {"query": query})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class IconPicker(EmojiPicker):
    control_type = "icon_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        categories: list[str] | None = None,
        recent: list[str] | None = None,
        skin_tone: str | None = None,
        show_search: bool | None = None,
        show_recent: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            categories=categories,
            recent=recent,
            skin_tone=skin_tone,
            show_search=show_search,
            show_recent=show_recent,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class IconButton(Button):
    control_type = "icon_button"

    def __init__(
        self,
        icon: str | int | None = None,
        *,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=None,
            props=merge_props(
                props,
                icon=icon,
                tooltip=tooltip,
                size=size,
                color=color,
                enabled=enabled,
                events=events,
            ),
            style=style,
            strict=strict,
            **kwargs,
        )


class KeybindRecorder(Component):
    control_type = "keybind_recorder"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        enabled: bool | None = None,
        show_clear: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            enabled=enabled,
            show_clear=show_clear,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ElevatedButton(Button):
    control_type = "elevated_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="elevated",
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class FilledButton(Button):
    control_type = "filled_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="filled",
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class OutlinedButton(Button):
    control_type = "outlined_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="outlined",
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class TextButton(Button):
    control_type = "text_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="text",
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class FieldGroup(Component):
    control_type = "field_group"

    def __init__(
        self,
        *children: Any,
        label: str | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        spacing: float | None = None,
        required: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            helper_text=helper_text,
            error_text=error_text,
            spacing=spacing,
            required=required,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class FilterDrawer(Component):
    control_type = "filter_drawer"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        open: bool | None = None,
        schema: Mapping[str, Any] | None = None,
        state: Mapping[str, Any] | None = None,
        show_actions: bool | None = None,
        apply_label: str | None = None,
        clear_label: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            open=open,
            schema=dict(schema or {}),
            state=dict(state or {}),
            show_actions=show_actions,
            apply_label=apply_label,
            clear_label=clear_label,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, open: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"open": open})

    def set_state(self, session: Any, state: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state", {"state": dict(state)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})



