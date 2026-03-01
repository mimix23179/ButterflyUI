from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DownloadItem"]

class DownloadItem(Component):
    """
    Single download/transfer row showing progress, speed, ETA, and
    pause/resume state.

    The runtime renders a compact tile with a ``LinearProgressIndicator``
    and text labels derived from ``title``, ``subtitle``, ``speed``, and
    ``eta``.  The ``status`` string is displayed as a badge (e.g.
    *downloading*, *paused*, *done*).  Progress updates can be pushed
    via ``set_progress()`` and the paused flag toggled via
    ``set_paused()``.  Events emitted include ``"pause"``,
    ``"resume"``, ``"cancel"``, and ``"open"``.

    ```python
    import butterflyui as bui

    bui.DownloadItem(
        id="dl-1",
        title="archive.zip",
        subtitle="125 MB / 500 MB",
        progress=0.25,
        status="downloading",
        speed="12.5 MB/s",
        eta="30s",
    )
    ```

    Args:
        id: 
            Stable identifier for the download item, used in event payloads and invoke calls.
        title: 
            Primary label text displayed on the tile (typically the file name).
        subtitle: 
            Secondary detail text (e.g. transferred / total bytes).
        progress: 
            Fractional progress value in the range ``0.0`` – ``1.0``.
        status: 
            Human-readable status label such as ``"downloading"``, ``"paused"``, or ``"done"``.
        speed: 
            Transfer-speed text or numeric value displayed alongside the progress bar.
        eta: 
            Estimated remaining time text or numeric value.
        paused: 
            If ``True``, the item is presented in a paused visual state.
        url: 
            Source URL associated with the download (forwarded in event payloads).
        path: 
            Local destination path associated with the download.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "download_item"

    def __init__(
        self,
        *,
        id: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        progress: float | None = None,
        status: str | None = None,
        speed: str | None = None,
        eta: str | None = None,
        paused: bool | None = None,
        url: str | None = None,
        path: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            id=id,
            title=title,
            subtitle=subtitle,
            progress=progress,
            status=status,
            speed=speed,
            eta=eta,
            paused=paused,
            url=url,
            path=path,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_progress(self, session: Any, progress: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"progress": float(progress)})

    def set_paused(self, session: Any, paused: bool) -> dict[str, Any]:
        return self.invoke(session, "set_paused", {"paused": paused})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
