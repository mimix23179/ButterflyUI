from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Terminal as _Terminal
from .submodules import (
    Capabilities,
    CommandBuilder,
    FlowGate,
    OutputMapper,
    Presets,
    Progress,
    ProgressView,
    Prompt,
    RawView,
    Replay,
    Session,
    Stdin,
    StdinInjector,
    Stream,
    StreamView,
    Tabs,
    Timeline,
    View,
    Workbench,
    ProcessBridge,
    ExecutionLane,
    LogViewer,
    LogPanel,
)
from .schema import (
    SCHEMA_VERSION,
    DEFAULT_ENGINE,
    MODULES,
    STATES,
    EVENTS,
    REGISTRY_ROLE_ALIASES,
    REGISTRY_MANIFEST_LISTS,
)

class Terminal(_Terminal):
    capabilities: type[Capabilities]
    Capabilities: type[Capabilities]
    command_builder: type[CommandBuilder]
    CommandBuilder: type[CommandBuilder]
    flow_gate: type[FlowGate]
    FlowGate: type[FlowGate]
    output_mapper: type[OutputMapper]
    OutputMapper: type[OutputMapper]
    presets: type[Presets]
    Presets: type[Presets]
    progress: type[Progress]
    Progress: type[Progress]
    progress_view: type[ProgressView]
    ProgressView: type[ProgressView]
    prompt: type[Prompt]
    Prompt: type[Prompt]
    raw_view: type[RawView]
    RawView: type[RawView]
    replay: type[Replay]
    Replay: type[Replay]
    session: type[Session]
    Session: type[Session]
    stdin: type[Stdin]
    Stdin: type[Stdin]
    stdin_injector: type[StdinInjector]
    StdinInjector: type[StdinInjector]
    stream: type[Stream]
    Stream: type[Stream]
    stream_view: type[StreamView]
    StreamView: type[StreamView]
    tabs: type[Tabs]
    Tabs: type[Tabs]
    timeline: type[Timeline]
    Timeline: type[Timeline]
    view: type[View]
    View: type[View]
    workbench: type[Workbench]
    Workbench: type[Workbench]
    process_bridge: type[ProcessBridge]
    ProcessBridge: type[ProcessBridge]
    execution_lane: type[ExecutionLane]
    ExecutionLane: type[ExecutionLane]
    log_viewer: type[LogViewer]
    LogViewer: type[LogViewer]
    log_panel: type[LogPanel]
    LogPanel: type[LogPanel]

__all__ = [
    "Terminal",
    "SCHEMA_VERSION",
    "DEFAULT_ENGINE",
    "MODULES",
    "STATES",
    "EVENTS",
    "REGISTRY_ROLE_ALIASES",
    "REGISTRY_MANIFEST_LISTS",
    "MODULE_COMPONENTS",
    "Capabilities",
    "CommandBuilder",
    "FlowGate",
    "OutputMapper",
    "Presets",
    "Progress",
    "ProgressView",
    "Prompt",
    "RawView",
    "Replay",
    "Session",
    "Stdin",
    "StdinInjector",
    "Stream",
    "StreamView",
    "Tabs",
    "Timeline",
    "View",
    "Workbench",
    "ProcessBridge",
    "ExecutionLane",
    "LogViewer",
    "LogPanel",
]
