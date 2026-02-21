"""ButterflyUI Python SDK.

ButterflyUI is a UI app-building package driven by a ButterflyUI Flutter runtime.
Python controls the runtime through a live session channel.
"""

from __future__ import annotations

from .version import get_version, __version__

# Automatically initialize 60 FPS performance when ButterflyUI is imported
from .core.performance import PerformanceConfig

PerformanceConfig.initialize()

from .app import (
    App,
    AppConfig,
    BaseApp,
    ButterflyUIDesktop,
    ButterflyUIError,
    ButterflyUISession,
    ButterflyUIWeb,
    Page,
    RunTarget,
    RuntimeApp,
    RuntimePlan,
    app,
    run,
    run_desktop,
    run_web,
)
from .core import Breakpoints, Component, Control
from .core.animation import AnimationSpec
from .core.performance import PerformanceConfig, performance_config, enable_60fps
from .controls import *  # noqa: F401,F403
from .controls import __all__ as _controls_all
from .state import Computed, DerivedState, Signal, State, effect
from .callbacks import Update, update, NO_UPDATE, TaskQueue, Progress as ProgressHandle, bind_event
from .assets import AssetServer, data_uri_from_base64, file_payload_to_src, files_payload_to_srcs
from .style_packs import (
    STYLE_PACKS,
    DEFAULT_STYLE_PACK,
    list_style_packs,
    register_style_pack,
    list_custom_style_packs,
)

__all__ = [
    "get_version",
    "__version__",
    "AppConfig",
    "RuntimeApp",
    "App",
    "Page",
    "BaseApp",
    "ButterflyUIWeb",
    "ButterflyUIDesktop",
    "ButterflyUISession",
    "ButterflyUIError",
    "RunTarget",
    "RuntimePlan",
    "run",
    "app",
    "run_web",
    "run_desktop",
    "Component",
    "Control",
    "Breakpoints",
    "AnimationSpec",
    "PerformanceConfig",
    "performance_config",
    "enable_60fps",
    "State",
    "DerivedState",
    "Signal",
    "Computed",
    "effect",
    "Update",
    "update",
    "NO_UPDATE",
    "TaskQueue",
    "ProgressHandle",
    "bind_event",
    "AssetServer",
    "data_uri_from_base64",
    "file_payload_to_src",
    "files_payload_to_srcs",
    "STYLE_PACKS",
    "DEFAULT_STYLE_PACK",
    "list_style_packs",
    "register_style_pack",
    "list_custom_style_packs",
]

for _name in _controls_all:
    if _name not in __all__:
        __all__.append(_name)
