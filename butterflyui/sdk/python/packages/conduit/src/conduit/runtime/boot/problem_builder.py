from __future__ import annotations

import os
import traceback
from pathlib import Path
from typing import Any


def build_problem(
    exc: BaseException,
    *,
    title: str | None = None,
    severity: str = "error",
) -> dict[str, Any] | None:
    if not _should_emit_problem(exc):
        return None
    tb = exc.__traceback__
    frames = traceback.extract_tb(tb) if tb is not None else []
    workspace_root = _workspace_root()
    venv_names = _venv_names()

    files: list[dict[str, Any]] = []
    related_files: list[str] = []
    primary_file: dict[str, Any] | None = None

    for frame in frames:
        path = Path(frame.filename)
        if not _is_workspace_python(path, workspace_root, venv_names):
            continue
        snippet = _build_snippet(path, frame.lineno)
        entry = {
            "path": str(path),
            "line": frame.lineno,
            "column": getattr(frame, "colno", None),
            "function": frame.name,
            "snippet": snippet,
        }
        files.append(entry)
        if str(path) not in related_files:
            related_files.append(str(path))
        primary_file = entry

    error_class = exc.__class__.__name__
    error_kind = _classify_error(exc)
    error_classes = [error_class]
    message = str(exc) or error_class
    if message and message != error_class:
        error_text = f"{error_class}: {message}"
    else:
        error_text = error_class
    traceback_text = "".join(traceback.format_exception(type(exc), exc, tb))

    payload = {
        "title": title or "Runtime problem",
        "message": message,
        "severity": severity,
        "traceback": traceback_text,
        "files": files,
        "related_files": related_files,
        "error_classes": error_classes,
        "error_class": error_class,
        "error_kind": error_kind,
        "error": error_text,
    }

    if primary_file is not None:
        payload.update(
            {
                "file": primary_file.get("path"),
                "line": primary_file.get("line"),
                "column": primary_file.get("column"),
                "snippet": primary_file.get("snippet"),
            }
        )

    return payload


def build_runtime_stall_problem(
    *,
    timeout: float,
    has_root: bool,
    has_screen: bool,
    has_overlay: bool,
    has_splash: bool,
) -> dict[str, Any]:
    payload_sent = has_root or has_screen or has_overlay or has_splash
    if payload_sent:
        message = (
            f"The runtime did not render the first frame within {timeout:.1f} seconds."
        )
        hint = "The UI payload was sent, but the runtime never acknowledged a render."
    else:
        message = (
            "No UI payload was sent before runtime.ready. "
            "Call page.update() and set page.root or page.screen."
        )
        hint = "The runtime is waiting for a first render payload."

    error_class = "RuntimeStall"
    return {
        "title": "Runtime stall",
        "message": message,
        "severity": "error",
        "traceback": "",
        "files": [],
        "related_files": [],
        "error_classes": [error_class],
        "error_class": error_class,
        "error_kind": "stall",
        "error": f"{error_class}: {message}",
        "hint": hint,
    }


def _workspace_root() -> Path | None:
    env_root = os.environ.get("CONDUIT_WORKSPACE")
    if env_root:
        try:
            return Path(env_root).resolve()
        except Exception:
            return None
    try:
        return Path.cwd().resolve()
    except Exception:
        return None


def _venv_names() -> set[str]:
    names = {".venv", "venv", "env", ".env"}
    env_name = os.environ.get("CONDUIT_VENV_NAME")
    if env_name:
        names.add(env_name)
    venv_path = os.environ.get("VIRTUAL_ENV")
    if venv_path:
        names.add(Path(venv_path).name)
    return {name for name in names if name}


def _is_workspace_python(path: Path, workspace_root: Path | None, venv_names: set[str]) -> bool:
    if path.suffix != ".py":
        return False
    try:
        resolved = path.resolve()
    except Exception:
        return False
    if workspace_root is not None:
        try:
            resolved.relative_to(workspace_root)
        except ValueError:
            return False
    for part in resolved.parts:
        if part in venv_names:
            return False
        if part in ("site-packages", "dist-packages"):
            return False
    return True


def _build_snippet(path: Path, lineno: int | None, *, context: int = 2) -> str | None:
    if lineno is None:
        return None
    try:
        text = path.read_text(encoding="utf-8")
    except Exception:
        try:
            text = path.read_text(encoding="latin-1")
        except Exception:
            return None
    lines = text.splitlines()
    if lineno < 1 or lineno > len(lines):
        return None
    start = max(1, lineno - context)
    end = min(len(lines), lineno + context)
    width = len(str(end))
    snippet_lines: list[str] = []
    for line_no in range(start, end + 1):
        prefix = ">" if line_no == lineno else " "
        code = lines[line_no - 1].rstrip("\n")
        snippet_lines.append(f"{prefix}{line_no:>{width}} | {code}")
    return "\n".join(snippet_lines)


def _classify_error(exc: BaseException) -> str:
    lowered = exc.__class__.__name__.lower()
    if lowered in {"attributeerror"}:
        return "attribute"
    if lowered in {"typeerror"}:
        return "type"
    if lowered in {"argumenterror", "valueerror"}:
        return "argument"
    if lowered in {"importerror", "modulenotfounderror"}:
        return "import"
    if _is_event_loop_error(exc):
        return "event_loop"
    if _is_connection_error(exc):
        return "connection"
    return "runtime"


def _should_emit_problem(exc: BaseException) -> bool:
    if isinstance(exc, AttributeError):
        return True
    if exc.__class__.__name__.lower() == "argumenterror":
        return True
    if _is_event_loop_error(exc):
        return True
    if _is_connection_error(exc):
        return True
    return False


def _is_event_loop_error(exc: BaseException) -> bool:
    if not isinstance(exc, RuntimeError):
        return False
    message = str(exc).lower()
    return "event loop" in message or "loop is closed" in message


def _is_connection_error(exc: BaseException) -> bool:
    name = exc.__class__.__name__.lower()
    if "websocket" in name or "connection" in name or "socket" in name:
        return True
    if isinstance(exc, (ConnectionError, TimeoutError, BrokenPipeError)):
        return True
    if isinstance(exc, OSError):
        message = str(exc).lower()
        return (
            "connection" in message
            or "socket" in message
            or "broken pipe" in message
            or "timed out" in message
        )
    return False
