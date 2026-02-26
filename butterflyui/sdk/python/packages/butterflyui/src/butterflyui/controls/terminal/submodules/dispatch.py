from __future__ import annotations

from typing import Dict, Optional

from .capabilities import Capabilities
from .command_builder import CommandBuilder
from .execution_lane import ExecutionLane
from .flow_gate import FlowGate
from .log_panel import LogPanel
from .log_viewer import LogViewer
from .output_mapper import OutputMapper
from .presets import Presets
from .process_bridge import ProcessBridge
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

# ---------------------------------------------------------------------------
# Categorised component dicts
# ---------------------------------------------------------------------------

VIEWS_COMPONENTS: Dict[str, type] = {
    'workbench': Workbench,
    'view': View,
    'stream_view': StreamView,
    'raw_view': RawView,
    'timeline': Timeline,
    'progress_view': ProgressView,
    'log_viewer': LogViewer,
    'log_panel': LogPanel,
    'replay': Replay,
    'stream': Stream,
    'progress': Progress,
}

INPUTS_COMPONENTS: Dict[str, type] = {
    'prompt': Prompt,
    'stdin': Stdin,
    'stdin_injector': StdinInjector,
    'command_builder': CommandBuilder,
    'flow_gate': FlowGate,
    'presets': Presets,
    'execution_lane': ExecutionLane,
    'tabs': Tabs,
    'session': Session,
}

PROVIDERS_COMPONENTS: Dict[str, type] = {
    'process_bridge': ProcessBridge,
    'output_mapper': OutputMapper,
    'capabilities': Capabilities,
}

# ---------------------------------------------------------------------------
# Category names and merged lookup
# ---------------------------------------------------------------------------

TERMINAL_CATEGORIES = ('views', 'inputs', 'providers')

_CATEGORY_MAP: Dict[str, Dict[str, type]] = {
    'views': VIEWS_COMPONENTS,
    'inputs': INPUTS_COMPONENTS,
    'providers': PROVIDERS_COMPONENTS,
}

MODULE_CATEGORY: Dict[str, str] = {
    module: category
    for category, modules in _CATEGORY_MAP.items()
    for module in modules
}

# ---------------------------------------------------------------------------
# Lookup helpers
# ---------------------------------------------------------------------------


def get_terminal_module_category(module: str) -> Optional[str]:
    """Return *'views'*, *'inputs'*, or *'providers'* for *module*, else None."""
    return MODULE_CATEGORY.get(module)


def get_terminal_component(module: str) -> Optional[type]:
    """Return the component class for *module* across all categories."""
    for components in _CATEGORY_MAP.values():
        if module in components:
            return components[module]
    return None


def get_terminal_views_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is a views module."""
    return VIEWS_COMPONENTS.get(module)


def get_terminal_inputs_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is an inputs module."""
    return INPUTS_COMPONENTS.get(module)


def get_terminal_providers_component(module: str) -> Optional[type]:
    """Return the component class for *module* if it is a providers module."""
    return PROVIDERS_COMPONENTS.get(module)


def get_terminal_category_components(category: str) -> Dict[str, type]:
    """Return the component dict for *category* ('views', 'inputs', 'providers')."""
    return dict(_CATEGORY_MAP.get(category, {}))


def is_terminal_views_module(module: str) -> bool:
    return module in VIEWS_COMPONENTS


def is_terminal_inputs_module(module: str) -> bool:
    return module in INPUTS_COMPONENTS


def is_terminal_providers_module(module: str) -> bool:
    return module in PROVIDERS_COMPONENTS


__all__ = [
    'VIEWS_COMPONENTS',
    'INPUTS_COMPONENTS',
    'PROVIDERS_COMPONENTS',
    'TERMINAL_CATEGORIES',
    'MODULE_CATEGORY',
    'get_terminal_module_category',
    'get_terminal_component',
    'get_terminal_views_component',
    'get_terminal_inputs_component',
    'get_terminal_providers_component',
    'get_terminal_category_components',
    'is_terminal_views_module',
    'is_terminal_inputs_module',
    'is_terminal_providers_module',
]
