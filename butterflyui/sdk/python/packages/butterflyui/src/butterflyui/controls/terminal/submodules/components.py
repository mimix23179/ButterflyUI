from __future__ import annotations

from .capabilities import Capabilities
from .command_builder import CommandBuilder
from .flow_gate import FlowGate
from .output_mapper import OutputMapper
from .presets import Presets
from .progress import Progress
from .progress_view import ProgressView
from .prompt import Prompt
from .raw_view import RawView
from .replay import Replay
from .session import Session
from .stdin import Stdin
from .stdin_injector import StdinInjector
from .stream import Stream
from .stream_view import StreamView
from .tabs import Tabs
from .timeline import Timeline
from .view import View
from .workbench import Workbench
from .process_bridge import ProcessBridge
from .execution_lane import ExecutionLane
from .log_viewer import LogViewer
from .log_panel import LogPanel

MODULE_COMPONENTS = {
    'capabilities': Capabilities,
    'command_builder': CommandBuilder,
    'flow_gate': FlowGate,
    'output_mapper': OutputMapper,
    'presets': Presets,
    'progress': Progress,
    'progress_view': ProgressView,
    'prompt': Prompt,
    'raw_view': RawView,
    'replay': Replay,
    'session': Session,
    'stdin': Stdin,
    'stdin_injector': StdinInjector,
    'stream': Stream,
    'stream_view': StreamView,
    'tabs': Tabs,
    'timeline': Timeline,
    'view': View,
    'workbench': Workbench,
    'process_bridge': ProcessBridge,
    'execution_lane': ExecutionLane,
    'log_viewer': LogViewer,
    'log_panel': LogPanel,
}

globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})

__all__ = [
    'MODULE_COMPONENTS',
    'Capabilities',
    'CommandBuilder',
    'FlowGate',
    'OutputMapper',
    'Presets',
    'Progress',
    'ProgressView',
    'Prompt',
    'RawView',
    'Replay',
    'Session',
    'Stdin',
    'StdinInjector',
    'Stream',
    'StreamView',
    'Tabs',
    'Timeline',
    'View',
    'Workbench',
    'ProcessBridge',
    'ExecutionLane',
    'LogViewer',
    'LogPanel',
]
