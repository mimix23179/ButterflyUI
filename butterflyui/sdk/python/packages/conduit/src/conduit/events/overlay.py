from __future__ import annotations

from typing import Any

from ..app import Page
from ..core.control import Component
from ..ui.events import register_action


@register_action("overlay.open")
def open_overlay(page: Page, overlay: Component, *, update: bool = True) -> Component:
    """Open an overlay by setting it on the page and optionally updating."""
    page.set_overlay(overlay)
    if update:
        page.update()
    return overlay


@register_action("overlay.close")
def close_overlay(page: Page, *, update: bool = True) -> None:
    """Close the active overlay and optionally update the runtime."""
    page.clear_overlay()
    if update:
        page.update()
