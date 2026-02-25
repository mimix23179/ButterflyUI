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

Terminal.capabilities = Capabilities
Terminal.Capabilities = Capabilities
Terminal.command_builder = CommandBuilder
Terminal.CommandBuilder = CommandBuilder
Terminal.flow_gate = FlowGate
Terminal.FlowGate = FlowGate
Terminal.output_mapper = OutputMapper
Terminal.OutputMapper = OutputMapper
Terminal.presets = Presets
Terminal.Presets = Presets
Terminal.progress = Progress
Terminal.Progress = Progress
Terminal.progress_view = ProgressView
Terminal.ProgressView = ProgressView
Terminal.prompt = Prompt
Terminal.Prompt = Prompt
Terminal.raw_view = RawView
Terminal.RawView = RawView
Terminal.replay = Replay
Terminal.Replay = Replay
Terminal.session = Session
Terminal.Session = Session
Terminal.stdin = Stdin
Terminal.Stdin = Stdin
Terminal.stdin_injector = StdinInjector
Terminal.StdinInjector = StdinInjector
Terminal.stream = Stream
Terminal.Stream = Stream
Terminal.stream_view = StreamView
Terminal.StreamView = StreamView
Terminal.tabs = Tabs
Terminal.Tabs = Tabs
Terminal.timeline = Timeline
Terminal.Timeline = Timeline
Terminal.view = View
Terminal.View = View
Terminal.workbench = Workbench
Terminal.Workbench = Workbench
Terminal.process_bridge = ProcessBridge
Terminal.ProcessBridge = ProcessBridge
Terminal.execution_lane = ExecutionLane
Terminal.ExecutionLane = ExecutionLane
Terminal.log_viewer = LogViewer
Terminal.LogViewer = LogViewer
Terminal.log_panel = LogPanel
Terminal.LogPanel = LogPanel

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
