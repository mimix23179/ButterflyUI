from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Chat",
    "ChatBubble",
    "MessageBubble",
    "CodeEditor",
    "Terminal",
    "TerminalHost",
    "TerminalTabStrip",
    "TerminalProcessBridge",
    "OutputPanel",
    "EditorTabStrip",
    "WorkspaceTree",
    "FileSystem",
    "ProblemsPanel",
    "EditorWorkspace",
    "OwnershipMarker",
    "ChatThread",
    "ChatMessage",
    "MessageComposer",
    "PromptComposer",
    "Form",
    "AutoForm",
    "SubmitScope",
    "FormField",
    "ValidationSummary",
]


class OwnershipMarker(Component):
    control_type = "ownership_marker"

    def __init__(
        self,
        *,
        document_id: str | None = None,
        items: list[Mapping[str, Any]] | None = None,
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
            document_id=document_id,
            items=[dict(item) for item in (items or [])],
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class CodeEditor(Component):
    control_type = "code_editor"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        code: str | None = None,
        language: str | None = None,
        read_only: bool | None = None,
        word_wrap: bool | None = None,
        line_numbers: bool | None = None,
        show_gutter: bool | None = None,
        show_minimap: bool | None = None,
        glyph_margin: bool | None = None,
        engine: str | None = None,
        webview_engine: str | None = None,
        document_uri: str | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = code if code is not None else (text if text is not None else value)
        merged = merge_props(
            props,
            value=resolved,
            text=resolved,
            code=resolved,
            language=language,
            read_only=read_only,
            word_wrap=word_wrap,
            line_numbers=line_numbers,
            show_gutter=show_gutter,
            show_minimap=show_minimap,
            glyph_margin=glyph_margin,
            engine=engine,
            webview_engine=webview_engine,
            document_uri=document_uri,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def select_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "select_all", {})

    def insert_text(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "insert_text", {"value": value})

    def format_document(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "format_document", {})

    def reveal_line(self, session: Any, line: int) -> dict[str, Any]:
        return self.invoke(session, "reveal_line", {"line": line})

    def set_markers(self, session: Any, markers: list[dict[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_markers", {"markers": markers})


class Terminal(Component):
    control_type = "terminal"

    def __init__(
        self,
        *,
        lines: list[Any] | None = None,
        events: list[Any] | None = None,
        output: str | None = None,
        raw_text: str | None = None,
        show_input: bool | None = None,
        read_only: bool | None = None,
        clear_on_submit: bool | None = None,
        strip_ansi: bool | None = None,
        auto_scroll: bool | None = None,
        wrap_lines: bool | None = None,
        max_lines: int | None = None,
        engine: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            lines=lines,
            events=events,
            output=output,
            raw_text=raw_text,
            show_input=show_input,
            read_only=read_only,
            clear_on_submit=clear_on_submit,
            strip_ansi=strip_ansi,
            auto_scroll=auto_scroll,
            wrap_lines=wrap_lines,
            max_lines=max_lines,
            engine=engine,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def write(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "write", {"value": value})

    def append_lines(self, session: Any, lines: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "append_lines", {"lines": lines})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def set_input(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_input", {"value": value})

    def set_read_only(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_read_only", {"value": value})

    def get_buffer(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_buffer", {})


class TerminalHost(Component):
    control_type = "terminal_host"

    def __init__(
        self,
        *,
        instances: list[dict[str, Any]] | None = None,
        active_id: str | None = None,
        cwd: str | None = None,
        output_channels: Mapping[str, Any] | None = None,
        active_output_channel: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            instances=instances,
            active_id=active_id,
            cwd=cwd,
            output_channels=output_channels,
            active_output_channel=active_output_channel,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def new_instance(self, session: Any, name: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if name is not None:
            payload["name"] = name
        return self.invoke(session, "new_instance", payload)

    def close_instance(self, session: Any, instance_id: str) -> dict[str, Any]:
        return self.invoke(session, "close_instance", {"id": instance_id})

    def set_active(self, session: Any, instance_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_active", {"id": instance_id})

    def run_command(self, session: Any, command: str, cwd: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"command": command}
        if cwd is not None:
            payload["cwd"] = cwd
        return self.invoke(session, "run_command", payload)

    def append_output(
        self,
        session: Any,
        *,
        text: str,
        channel: str | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {"text": text}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "append_output", payload)

    def get_instances(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_instances", {})


class TerminalTabStrip(Component):
    control_type = "terminal_tab_strip"

    def __init__(
        self,
        *,
        tabs: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, tabs=tabs, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class TerminalProcessBridge(Component):
    control_type = "terminal_process_bridge"

    def __init__(
        self,
        *,
        command: str | None = None,
        args: list[str] | None = None,
        cwd: str | None = None,
        env: Mapping[str, str] | None = None,
        auto_start: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            command=command,
            args=args,
            cwd=cwd,
            env=env,
            auto_start=auto_start,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def start(
        self,
        session: Any,
        *,
        command: str | None = None,
        args: list[str] | None = None,
        cwd: str | None = None,
        env: Mapping[str, str] | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if command is not None:
            payload["command"] = command
        if args is not None:
            payload["args"] = args
        if cwd is not None:
            payload["cwd"] = cwd
        if env is not None:
            payload["env"] = dict(env)
        return self.invoke(session, "start", payload)

    def stop(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "stop", {})

    def kill(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "kill", {})

    def restart(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "restart", {})

    def write_stdin(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "write_stdin", {"value": value})

    def is_running(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "is_running", {})


class OutputPanel(Component):
    control_type = "output_panel"

    def __init__(
        self,
        *,
        channels: Mapping[str, Any] | None = None,
        active_channel: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            channels=channels,
            active_channel=active_channel,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def append(self, session: Any, text: str, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"text": text}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "append", payload)

    def clear_channel(self, session: Any, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "clear_channel", payload)

    def set_channel(self, session: Any, channel: str) -> dict[str, Any]:
        return self.invoke(session, "set_channel", {"channel": channel})

    def get_channel(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_channel", {})


class EditorTabStrip(Component):
    control_type = "editor_tab_strip"

    def __init__(
        self,
        *,
        tabs: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, tabs=tabs, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class WorkspaceTree(Component):
    control_type = "workspace_tree"

    def __init__(
        self,
        *,
        nodes: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, nodes=nodes, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class FileSystem(Component):
    control_type = "file_system"

    def __init__(
        self,
        *,
        root: str | None = None,
        nodes: list[dict[str, Any]] | None = None,
        selected_path: str | None = None,
        show_hidden: bool | None = None,
        readonly: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            root=root,
            nodes=nodes,
            selected_path=selected_path,
            show_hidden=show_hidden,
            readonly=readonly,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected_path(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected_path", {"path": path})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ProblemsPanel(Component):
    control_type = "problems_panel"

    def __init__(
        self,
        *,
        problems: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, problems=problems, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class EditorWorkspace(Component):
    control_type = "editor_workspace"

    def __init__(
        self,
        *,
        documents: list[dict[str, Any]] | None = None,
        active_id: str | None = None,
        workspace_nodes: list[dict[str, Any]] | None = None,
        problems: list[dict[str, Any]] | None = None,
        show_explorer: bool | None = None,
        show_problems: bool | None = None,
        show_status_bar: bool | None = None,
        status_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            documents=documents,
            active_id=active_id,
            workspace_nodes=workspace_nodes,
            problems=problems,
            show_explorer=show_explorer,
            show_problems=show_problems,
            show_status_bar=show_status_bar,
            status_text=status_text,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ChatThread(Component):
    control_type = "chat_thread"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_messages(self, session: Any, messages: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_messages", {"messages": messages})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ChatMessage(Component):
    control_type = "chat_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            value=text,
            role=role,
            name=name,
            clickable=clickable,
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


class Chat(ChatThread):
    control_type = "chat"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class ChatBubble(ChatMessage):
    control_type = "chat_bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            text=text,
            role=role,
            name=name,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class MessageBubble(ChatMessage):
    control_type = "message_bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            text=text,
            role=role,
            name=name,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class MessageComposer(Component):
    control_type = "message_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class PromptComposer(MessageComposer):
    control_type = "prompt_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        prompt_label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            prompt_label=prompt_label,
            **kwargs,
        )
        Component.__init__(self, props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def attach(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "attach", {})


class Form(Component):
    control_type = "form"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        description: str | None = None,
        spacing: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            description=description,
            spacing=spacing,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class SubmitScope(Component):
    control_type = "submit_scope"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        enabled: bool | None = None,
        submit_on_enter: bool | None = None,
        submit_on_ctrl_enter: bool | None = None,
        debounce_ms: int | None = None,
        payload: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            submit_on_enter=submit_on_enter,
            submit_on_ctrl_enter=submit_on_ctrl_enter,
            debounce_ms=debounce_ms,
            payload=dict(payload) if payload is not None else None,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def submit(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "submit", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class AutoForm(Component):
    control_type = "auto_form"

    def __init__(
        self,
        *children: Any,
        schema: Mapping[str, Any] | None = None,
        fields: list[Mapping[str, Any]] | None = None,
        values: Mapping[str, Any] | None = None,
        title: str | None = None,
        description: str | None = None,
        submit_label: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            schema=schema,
            fields=fields,
            values=dict(values) if values is not None else None,
            title=title,
            description=description,
            submit_label=submit_label,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def set_values(self, session: Any, values: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": dict(values)})

    def validate(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "validate", {})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class FormField(Component):
    control_type = "form_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        label: str | None = None,
        description: str | None = None,
        required: bool | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            description=description,
            required=required,
            helper_text=helper_text,
            error_text=error_text,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class ValidationSummary(Component):
    control_type = "validation_summary"

    def __init__(
        self,
        *,
        title: str | None = None,
        errors: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, errors=errors, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)

