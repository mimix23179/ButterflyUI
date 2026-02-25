from __future__ import annotations

from .components import MODULE_COMPONENTS
from .control import Terminal
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

Terminal.capabilities: type[Capabilities] = Capabilities
Terminal.Capabilities: type[Capabilities] = Capabilities
Terminal.command_builder: type[CommandBuilder] = CommandBuilder
Terminal.CommandBuilder: type[CommandBuilder] = CommandBuilder
Terminal.flow_gate: type[FlowGate] = FlowGate
Terminal.FlowGate: type[FlowGate] = FlowGate
Terminal.output_mapper: type[OutputMapper] = OutputMapper
Terminal.OutputMapper: type[OutputMapper] = OutputMapper
Terminal.presets: type[Presets] = Presets
Terminal.Presets: type[Presets] = Presets
Terminal.progress: type[Progress] = Progress
Terminal.Progress: type[Progress] = Progress
Terminal.progress_view: type[ProgressView] = ProgressView
Terminal.ProgressView: type[ProgressView] = ProgressView
Terminal.prompt: type[Prompt] = Prompt
Terminal.Prompt: type[Prompt] = Prompt
Terminal.raw_view: type[RawView] = RawView
Terminal.RawView: type[RawView] = RawView
Terminal.replay: type[Replay] = Replay
Terminal.Replay: type[Replay] = Replay
Terminal.session: type[Session] = Session
Terminal.Session: type[Session] = Session
Terminal.stdin: type[Stdin] = Stdin
Terminal.Stdin: type[Stdin] = Stdin
Terminal.stdin_injector: type[StdinInjector] = StdinInjector
Terminal.StdinInjector: type[StdinInjector] = StdinInjector
Terminal.stream: type[Stream] = Stream
Terminal.Stream: type[Stream] = Stream
Terminal.stream_view: type[StreamView] = StreamView
Terminal.StreamView: type[StreamView] = StreamView
Terminal.tabs: type[Tabs] = Tabs
Terminal.Tabs: type[Tabs] = Tabs
Terminal.timeline: type[Timeline] = Timeline
Terminal.Timeline: type[Timeline] = Timeline
Terminal.view: type[View] = View
Terminal.View: type[View] = View
Terminal.workbench: type[Workbench] = Workbench
Terminal.Workbench: type[Workbench] = Workbench
Terminal.process_bridge: type[ProcessBridge] = ProcessBridge
Terminal.ProcessBridge: type[ProcessBridge] = ProcessBridge
Terminal.execution_lane: type[ExecutionLane] = ExecutionLane
Terminal.ExecutionLane: type[ExecutionLane] = ExecutionLane
Terminal.log_viewer: type[LogViewer] = LogViewer
Terminal.LogViewer: type[LogViewer] = LogViewer
Terminal.log_panel: type[LogPanel] = LogPanel
Terminal.LogPanel: type[LogPanel] = LogPanel

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
