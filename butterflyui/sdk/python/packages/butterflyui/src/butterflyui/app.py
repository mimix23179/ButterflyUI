"""ButterflyUI app entrypoints (transport-only bootstrap).

This module intentionally keeps the runtime surface minimal for step 1.
"""

from __future__ import annotations

from dataclasses import dataclass
import asyncio
import json
import logging
import sys
import warnings
from typing import Any, Awaitable, Callable, Optional, Iterable
import uuid
import threading
import hashlib

import time

from .runtime.transport.websocket import WebSocketRuntimeServer
from .runtime.boot import build_problem, build_runtime_stall_problem
from .runtime import set_current_session
from .runtime.runner import RunTarget, RuntimePlan, build_runtime_plan
from .core.control import Control, coerce_json_value
from .core.performance import PerformanceConfig
from .controls.candy.control import CandyTheme
from .controls._shared import modifier_capabilities_manifest

import butterflyui_desktop

_log = logging.getLogger(__name__)


class ButterflyUIError(RuntimeError):
	"""Base error for ButterflyUI app/runtime failures."""


@dataclass(slots=True)
class AppConfig:
	host: str = "127.0.0.1"
	port: int = 8765
	path: str = "/ws"
	token: str | None = None
	require_token: bool = False
	protocol: int = 1
	target_fps: int = 60
	hello_timeout: float | None = 10.0
	first_render_timeout: float | None = 10.0


class ButterflyUISession:
	"""Represents an active runtime transport session (step 1 only)."""

	def __init__(self, server: WebSocketRuntimeServer, config: AppConfig) -> None:
		self._server = server
		self._config = config
		self._max_fps: int = int(getattr(server, "target_fps", 60) or 60)
		if self._max_fps <= 0:
			self._max_fps = 60
		self._frame_interval_s: float = 1.0 / float(self._max_fps)
		self._patch_buffer: dict[str, dict[str, Any]] = {}
		self._patch_flush_handle: asyncio.Handle | None = None
		self._last_patch_flush: float = 0.0
		self.session_id: str | None = None
		self.hello_payload: dict[str, Any] | None = None
		self.connected: bool = False
		self._event_handlers: dict[tuple[str, str], list[Callable[[dict[str, Any]], Any]]] = {}
		self._values: dict[str, dict[str, Any]] = {}
		self._pending_invokes: dict[str, asyncio.Future[dict[str, Any]]] = {}
		self._last_root: dict[str, Any] | None = None
		self._last_screen: dict[str, Any] | None = None
		self._last_overlay: dict[str, Any] | None = None
		self._last_splash: dict[str, Any] | None = None
		self._style_pack_revision_applied: int | None = None
		self._style_pack_hash_applied: str | None = None
		self._first_render_event = asyncio.Event()
		self._stall_task: asyncio.Task[Any] | None = None
		self._stall_timeout_s: float | None = (
			float(config.first_render_timeout)
			if config.first_render_timeout is not None
			else None
		)
		# Initialize 60 FPS performance tracking for this session
		PerformanceConfig.initialize()

	@property
	def server(self) -> WebSocketRuntimeServer:
		return self._server

	async def start(self) -> None:
		self._server._on_event = self._handle_event
		self._server._on_result = self._handle_invoke_result
		self._server._on_applied = self._handle_applied
		await self._server.start()

	async def wait_for_hello(self, timeout: float | None = None) -> dict[str, Any] | None:
		payload = await self._server.wait_for_hello(timeout=timeout)
		if payload is None:
			return None
		self.hello_payload = payload
		self.session_id = self._server.session_id
		self.connected = True
		return payload

	async def wait_for_disconnect(self) -> None:
		await self._server.wait_for_disconnect()

	async def stop(self) -> None:
		await self._server.stop()

	async def send_runtime_ready(self) -> None:
		payload = {"session_id": self.session_id}
		await self._server.send("runtime.ready", payload)

	async def send_runtime_problem(self, payload: dict[str, Any]) -> None:
		self._cancel_stall_watchdog()
		self._log_runtime_problem(payload)
		await self._server.send("runtime.problem", payload)

	def _cancel_stall_watchdog(self) -> None:
		task = self._stall_task
		if task is not None and not task.done():
			task.cancel()

	def _log_runtime_problem(self, payload: dict[str, Any]) -> None:
		try:
			title = payload.get("title") or "Runtime problem"
			traceback_text = payload.get("traceback") or ""
			message = payload.get("message") or payload.get("error") or ""
			if traceback_text:
				text = f"ButterflyUI runtime problem: {title}\n{traceback_text}"
			else:
				text = f"ButterflyUI runtime problem: {title}\n{message}"
			try:
				print(text, file=sys.stderr)
			except Exception:
				pass
			_log.error(text)
		except Exception:
			pass

	async def send_ui_reset(self) -> None:
		self._values.clear()
		await self._server.send("ui.reset", {})

	def start_first_render_watchdog(self) -> None:
		timeout = self._stall_timeout_s
		if timeout is None or timeout <= 0:
			return
		if self._first_render_event.is_set():
			return
		if self._stall_task is not None and not self._stall_task.done():
			return
		try:
			loop = asyncio.get_running_loop()
		except RuntimeError:
			return
		self._stall_task = loop.create_task(self._watch_first_render(timeout))

	def _handle_applied(self, payload: dict[str, Any]) -> None:
		revision = payload.get("style_pack_revision")
		if isinstance(revision, int):
			self._style_pack_revision_applied = revision
		hash_value = payload.get("style_pack_hash")
		if isinstance(hash_value, str) and hash_value:
			self._style_pack_hash_applied = hash_value
		if payload.get("first_render") or payload.get("has_root"):
			self._mark_first_render()

	def _mark_first_render(self) -> None:
		if self._first_render_event.is_set():
			return
		self._first_render_event.set()
		task = self._stall_task
		if task is not None and not task.done():
			task.cancel()

	async def _watch_first_render(self, timeout: float) -> None:
		try:
			await asyncio.wait_for(self._first_render_event.wait(), timeout=timeout)
			return
		except asyncio.TimeoutError:
			pass
		except asyncio.CancelledError:
			return

		payload = build_runtime_stall_problem(
			timeout=timeout,
			has_root=self._last_root is not None,
			has_screen=self._last_screen is not None,
			has_overlay=self._last_overlay is not None,
			has_splash=self._last_splash is not None,
		)
		await self.send_runtime_problem(payload)

	async def send_ui_apply(self, root: dict[str, Any]) -> None:
		self._last_root = root
		self._cache_tree(root)
		self._prune_runtime_caches()
		await self._server.send("ui.apply", {"root": root})

	async def send_ui_payload(self, payload: dict[str, Any]) -> None:
		has_tree_delta = any(key in payload for key in ("root", "screen", "overlay", "splash"))
		root = payload.get("root")
		if isinstance(root, dict):
			self._last_root = root
			self._cache_tree(root)
		elif "root" in payload:
			self._last_root = None

		screen = payload.get("screen")
		if isinstance(screen, dict):
			self._last_screen = screen
			self._cache_tree(screen)
		elif "screen" in payload:
			self._last_screen = None

		overlay = payload.get("overlay")
		if isinstance(overlay, dict):
			self._last_overlay = overlay
			self._cache_tree(overlay)
		elif "overlay" in payload:
			self._last_overlay = None

		splash = payload.get("splash")
		if isinstance(splash, dict):
			self._last_splash = splash
			self._cache_tree(splash)
		elif "splash" in payload:
			self._last_splash = None

		if has_tree_delta:
			self._prune_runtime_caches()

		await self._server.send("ui.apply", payload)

	async def send_ui_patch(self, control_id: str, props: dict[str, Any]) -> None:
		current = self._values.get(control_id)
		if current is not None:
			current.update(props)
		await self._server.send(
			"ui.apply",
			{"patch": {"id": control_id, "props": props}},
		)

	async def send_ui_patches(self, patches: list[dict[str, Any]]) -> None:
		if not patches:
			return
		await self._server.send("ui.apply", {"patches": patches})

	def _schedule_patch_flush(self) -> None:
		if self._patch_flush_handle is not None and not self._patch_flush_handle.cancelled():
			return
		try:
			loop = asyncio.get_running_loop()
		except RuntimeError:
			return

		now = time.monotonic()
		elapsed = now - self._last_patch_flush
		delay = self._frame_interval_s - elapsed
		if delay < 0:
			delay = 0.0

		self._patch_flush_handle = loop.call_later(delay, lambda: loop.create_task(self._flush_patch_buffer()))

	async def _flush_patch_buffer(self) -> None:
		self._patch_flush_handle = None
		if not self._patch_buffer:
			return
		patches: list[dict[str, Any]] = []
		for control_id, props in list(self._patch_buffer.items()):
			if not props:
				continue
			patches.append({"id": control_id, "props": props})
		self._patch_buffer.clear()
		self._last_patch_flush = time.monotonic()
		await self.send_ui_patches(patches)

	async def send_ui_snapshot(self) -> None:
		if (
			self._last_root is None
			and self._last_screen is None
			and self._last_overlay is None
			and self._last_splash is None
		):
			return
		payload: dict[str, Any] = {}
		if self._last_root is not None:
			payload["root"] = self._last_root
		if self._last_screen is not None:
			payload["screen"] = self._last_screen
		if self._last_overlay is not None:
			payload["overlay"] = self._last_overlay
		if self._last_splash is not None:
			payload["splash"] = self._last_splash
		await self.send_ui_reset()
		await self.send_ui_payload(payload)

	def update_props(self, control_id: str, props: dict[str, Any]) -> None:
		try:
			loop = asyncio.get_running_loop()
		except RuntimeError:
			warnings.warn("update_props called outside of runtime loop", RuntimeWarning)
			return

		# Coalesce patches and flush at most once per frame.
		control_key = str(control_id)
		buf = self._patch_buffer.setdefault(control_key, {})
		buf.update(props)
		# Keep the local value cache in sync for get_value() and bindings.
		current = self._values.get(control_key)
		if current is None:
			self._values[control_key] = dict(props)
		else:
			current.update(props)
		self._schedule_patch_flush()

	def wait_for_client(self, timeout: float | None = None) -> bool:
		"""Convenience synchronous method to check or wait for a connected client.

		If called with timeout==0 or timeout is None the method returns the
		current connected state immediately. If a positive timeout is provided and
		there is no running event loop in this thread the call will block up to
		`timeout` seconds waiting for a hello payload from the client. If called
		from inside the running event loop with timeout>0 this method will not
		block and simply return the current connection state (a warning is issued).
		"""
		# Fast path: immediate check
		if timeout is None or timeout == 0:
			return bool(self.connected)

		# If there's no running loop we can block synchronously using asyncio.run
		try:
			asyncio.get_running_loop()
		except RuntimeError:
			try:
				payload = asyncio.run(self._server.wait_for_hello(timeout=timeout))
				if payload is not None:
					self.hello_payload = payload
					self.session_id = self._server.session_id
					self.connected = True
					return True
				return bool(self.connected)
			except Exception:
				return bool(self.connected)

		# We're inside a running loop; cannot block here — return current state
		warnings.warn("wait_for_client called inside running loop with timeout>0; returning current connected state", RuntimeWarning)
		return bool(self.connected)

	def spawn(self, coro: Awaitable[Any] | Callable[..., Awaitable[Any]]) -> object:
		"""Spawn a background task for the provided coroutine.

		If called inside the runtime event loop this schedules the coroutine via
		create_task() and returns the Task. If called outside an event loop the
		coroutine is run in a background daemon thread and the Thread object is
		returned.
		"""
		# Accept either a coroutine function or coroutine object
		_cr = coro() if callable(coro) else coro
		try:
			loop = asyncio.get_running_loop()
			return loop.create_task(_cr)
		except RuntimeError:
			# No running loop; run the coroutine in a background thread
			def _runner():
				try:
					asyncio.run(_cr)
				except Exception:
					_log.exception("Background spawn failed")

			thr = threading.Thread(target=_runner, daemon=True)
			thr.start()
			return thr

	def invoke(
		self,
		control_id: str,
		method: str,
		args: dict[str, Any],
		*,
		timeout: float | None = None,
		**kwargs: Any,
	) -> dict[str, Any]:
		try:
			loop = asyncio.get_running_loop()
			warnings.warn(
				"invoke() called while event loop is running; returning Task. Use await invoke_async().",
				RuntimeWarning,
			)
			return loop.create_task(
				self.invoke_async(control_id, method, args, timeout=timeout, **kwargs)
			)
		except RuntimeError:
			return asyncio.run(
				self.invoke_async(control_id, method, args, timeout=timeout, **kwargs)
			)

	async def invoke_async(
		self,
		control_id: str,
		method: str,
		args: dict[str, Any],
		*,
		timeout: float | None = None,
		**kwargs: Any,
	) -> dict[str, Any]:
		loop = asyncio.get_running_loop()
		invoke_id = uuid.uuid4().hex
		fut: asyncio.Future[dict[str, Any]] = loop.create_future()
		self._pending_invokes[invoke_id] = fut
		payload = {
			"control_id": control_id,
			"method": method,
			"args": args,
		}
		await self._server.send("invoke", payload, msg_id=invoke_id)
		try:
			return await asyncio.wait_for(fut, timeout=timeout)
		finally:
			self._pending_invokes.pop(invoke_id, None)

	def subscribe_event(self, control_id: str, event: str) -> None:
		self._ensure_event_subscription(control_id, event)

	def on(self, control_id: str, event: str, handler: Callable[[dict[str, Any]], Any]) -> None:
		self._ensure_event_subscription(control_id, event)
		key = (str(control_id), str(event))
		handlers = self._event_handlers.setdefault(key, [])
		if handler not in handlers:
			handlers.append(handler)

	def _ensure_event_subscription(self, control_id: str, event: str) -> None:
		"""Best-effort subscription to ensure the runtime emits requested events."""
		from .core.control import _get_control_by_id

		names = self._expand_event_aliases(event)
		control = _get_control_by_id(str(control_id))
		if control is not None:
			for name in names:
				try:
					control._subscribe_event(self, name)
				except Exception:
					pass
			return

		# Fallback: update cached props if the control already exists in the UI tree.
		current = self._values.get(str(control_id), {})
		events_raw = current.get("events")
		if isinstance(events_raw, list):
			events = [str(v) for v in events_raw if v is not None]
		elif events_raw is None:
			events = []
		else:
			events = [str(events_raw)]
		changed = False
		for name in names:
			if name not in events:
				events.append(name)
				changed = True
		if changed:
			try:
				self.update_props(str(control_id), {"events": events})
			except Exception:
				pass

	@staticmethod
	def _expand_event_aliases(event: str) -> list[str]:
		name = str(event)

		aliases: list[str] = []

		def add(value: str) -> None:
			if value and value not in aliases:
				aliases.append(value)

		def to_snake(value: str) -> str:
			out: list[str] = []
			for i, ch in enumerate(value):
				if ch == "-":
					out.append("_")
					continue
				if ch.isupper():
					if i > 0 and value[i - 1] not in "_-":
						out.append("_")
					out.append(ch.lower())
				else:
					out.append(ch)
			return "".join(out)

		def to_camel(value: str) -> str:
			if "_" not in value:
				return value
			parts = [p for p in value.split("_") if p]
			if not parts:
				return value
			return parts[0] + "".join(part[:1].upper() + part[1:] for part in parts[1:])

		add(name)

		if name in ("hover_enter", "enter"):
			add("hover_enter")
			add("enter")
		if name in ("hover_exit", "exit"):
			add("hover_exit")
			add("exit")
		if name in ("hover_move", "hover"):
			add("hover_move")
			add("hover")

		snake = to_snake(name)
		camel = to_camel(snake)
		add(snake)
		add(camel)

		if snake == "replace_all":
			add("replaceAll")
		if snake == "suggestion_select":
			add("suggestionSelect")
		if snake == "filter_remove":
			add("filterRemove")
		if snake == "intent_change":
			add("intentChange")
		if snake == "provider_change":
			add("providerChange")
		if snake == "close":
			add("dismiss")
		if snake == "dismiss":
			add("close")

		return aliases

	def get_value(self, control: Any, *, prop: str = "value") -> Any:
		control_id = getattr(control, "control_id", None)
		if control_id is None:
			return None
		props = self._values.get(str(control_id), {})
		return props.get(prop)

	def _handle_event(self, payload: dict[str, Any]) -> None:
		control_id = payload.get("control_id")
		event = payload.get("event")
		if not control_id or not event:
			return
		msg = {
			"control_id": str(control_id),
			"control": str(control_id),
			"event": str(event),
			"payload": payload.get("payload") if isinstance(payload.get("payload"), dict) else {},
			"kind": payload.get("kind") or "ui",
		}
		handlers = list(self._event_handlers.get((msg["control_id"], msg["event"]), []))
		for handler in handlers:
			try:
				res = handler(msg)
				if asyncio.iscoroutine(res):
					asyncio.create_task(self._safe_coroutine(res))
			except Exception as exc:
				problem = build_problem(exc)
				if problem is not None:
					asyncio.create_task(self.send_runtime_problem(problem))
				else:
					continue

	def _handle_invoke_result(self, payload: dict[str, Any], reply_to: str | None) -> None:
		invoke_id = reply_to or payload.get("id")
		if not invoke_id:
			return
		fut = self._pending_invokes.get(str(invoke_id))
		if fut is None or fut.done():
			return
		fut.set_result(payload)

	async def _safe_coroutine(self, coro: Awaitable[Any]) -> None:
		try:
			await coro
		except Exception as exc:
			problem = build_problem(exc)
			if problem is not None:
				await self.send_runtime_problem(problem)
			else:
				return

	def _cache_tree(self, node: dict[str, Any]) -> None:
		for control in self._iter_control_nodes(node):
			control_id = control.get("id")
			if control_id is None:
				continue
			props = control.get("props")
			if isinstance(props, dict):
				self._values[str(control_id)] = dict(props)

	def _collect_control_ids(self, node: dict[str, Any], out: set[str]) -> None:
		for control in self._iter_control_nodes(node):
			control_id = control.get("id")
			if control_id is not None:
				out.add(str(control_id))

	def _iter_control_nodes(self, root: Any) -> Iterable[dict[str, Any]]:
		seen: set[int] = set()

		def is_control_like(value: Any) -> bool:
			return isinstance(value, dict) and (
				"id" in value and ("type" in value or "props" in value or "children" in value)
			)

		def walk(value: Any) -> Iterable[dict[str, Any]]:
			if isinstance(value, dict):
				marker = id(value)
				if marker in seen:
					return
				seen.add(marker)
				if is_control_like(value):
					yield value
				for nested in value.values():
					yield from walk(nested)
				return
			if isinstance(value, list):
				for nested in value:
					yield from walk(nested)

		yield from walk(root)

	def _prune_runtime_caches(self) -> None:
		active_ids: set[str] = set()
		for node in (self._last_root, self._last_screen, self._last_overlay, self._last_splash):
			if isinstance(node, dict):
				self._collect_control_ids(node, active_ids)

		if active_ids:
			self._values = {
				control_id: props
				for control_id, props in self._values.items()
				if control_id in active_ids
			}
			self._patch_buffer = {
				control_id: props
				for control_id, props in self._patch_buffer.items()
				if control_id in active_ids
			}
			self._event_handlers = {
				key: handlers
				for key, handlers in self._event_handlers.items()
				if key[0] in active_ids
			}
		else:
			self._values.clear()
			self._patch_buffer.clear()
			self._event_handlers.clear()


class WebSession(ButterflyUISession):
	"""WebSocket-based runtime session."""

	def __init__(self, config: AppConfig) -> None:
		server = WebSocketRuntimeServer(
			host=config.host,
			port=config.port,
			path=config.path,
			token=config.token,
			require_token=config.require_token,
			protocol=config.protocol,
			target_fps=config.target_fps,
		)
		super().__init__(server, config)

	@property
	def url(self) -> str:
		return self._server.url


class DesktopSession(WebSession):
	"""Desktop runtime session using butterflyui_desktop."""

	def __init__(self, config: AppConfig, *, auto_install: bool = True) -> None:
		super().__init__(config)
		self._auto_install = auto_install

	def launch_runtime(self, *, wait: bool = False, extra_args: Optional[list[str]] = None) -> Any:
		if butterflyui_desktop is None:
			raise ButterflyUIError("butterflyui_desktop is not available")
		if self._auto_install:
			butterflyui_desktop.install(force=False)
		host_port = f"{self._config.host}:{self._server.port}"
		return butterflyui_desktop.run(
			host_port=host_port,
			extra_args=extra_args,
			session_token=self._config.token,
			wait=wait,
		)


class BaseApp:
	"""Base app wrapper for future runtime features."""

	def __init__(self, main: Callable[["Page"], Any], config: AppConfig) -> None:
		self._main = main
		self._config = config

	def run(self) -> int:
		raise NotImplementedError

def _minimal_boot_root() -> dict[str, Any]:
	"""Fallback root to guarantee first render and avoid RuntimeStall."""
	return {
		"id": "__butterflyui_auto_root__",
		"type": "column",
		"props": {"spacing": 0},
		"children": [],
	}


class RuntimeApp(BaseApp):
	"""Runtime app entrypoint (transport-only step)."""

	def __init__(
		self,
		main: Callable[["Page"], Any],
		config: AppConfig,
		*,
		target: RunTarget = "desktop",
		auto_install: bool = True,
	) -> None:
		super().__init__(main, config)
		self._target = target
		self._desktop = target == "desktop"
		self._auto_install = bool(auto_install)
		# Initialize 60 FPS performance configuration
		PerformanceConfig.initialize()

	def run(self) -> int:
		async def _ensure_initial_state(page: "Page", session: ButterflyUISession) -> None:
			# Wait for any pending update() calls to complete
			await page.await_updates()
			if session._last_root is not None:
				return

			root_payload = page._coerce_root(page.root) if page.root is not None else None
			if page.root is not None and root_payload is None:
				warnings.warn(
					"Page.update() root is not serializable; using automatic boot root.",
					RuntimeWarning,
					stacklevel=3,
				)
			if root_payload is None:
				root_payload = _minimal_boot_root()

			extra: dict[str, Any] = {}
			if page.screen is not None:
				screen_payload = page._coerce_root(page.screen)
				if screen_payload is not None:
					extra["screen"] = screen_payload
			if page.overlay is not None:
				overlay_payload = page._coerce_root(page.overlay)
				if overlay_payload is not None:
					extra["overlay"] = overlay_payload
			if page.splash is not None:
				splash_payload = page._coerce_root(page.splash)
				if splash_payload is not None:
					extra["splash"] = splash_payload
			if page.title:
				extra["title"] = page.title
			if page.style_pack:
				extra["style_pack"] = page.style_pack
			if page._style_packs:
				extra["style_packs"] = list(page._style_packs.values())
			if page.bgcolor:
				extra["bgcolor"] = page.bgcolor
			if page.background is not None:
				extra["background"] = coerce_json_value(page.background)
			if page.candy is not None:
				if isinstance(page.candy, CandyTheme):
					tokens_payload = page.candy.to_json()
				elif isinstance(page.candy, dict):
					tokens_payload = dict(page.candy)
				else:
					tokens_payload = None
				if tokens_payload is not None:
					extra["candy"] = tokens_payload
					extra["tokens"] = tokens_payload
			if page.devtools is not None:
				extra["devtools"] = bool(page.devtools)
			if page.devtools_prefs:
				extra["devtools_prefs"] = dict(page.devtools_prefs)
			extra.update(page._runtime_metadata_payload())

			payload: dict[str, Any] = {"root": root_payload}
			payload.update(extra)

			await session.send_ui_reset()
			await session.send_ui_payload(payload)

		async def _run_async() -> None:
			session: ButterflyUISession
			if self._desktop:
				session = DesktopSession(self._config, auto_install=self._auto_install)
			else:
				session = WebSession(self._config)

			await session.start()
			host = str(getattr(session.server, "host", "127.0.0.1") or "127.0.0.1")
			port = int(getattr(session.server, "port", 8765) or 8765)
			_log.info("Runtime transport listening at %s:%s", host, port)

			if isinstance(session, DesktopSession):
				session.launch_runtime(wait=False)
			else:
				print(f"App running at: 127.0.0.1:{port}")
				print(f"App running at: localhost:{port}")
				if host not in ("127.0.0.1", "localhost"):
					print(f"App running at: {host}:{port}")

			await session.wait_for_hello(timeout=self._config.hello_timeout)

			page = Page(session=session)
			try:
				set_current_session(session)
				self._main(page)
			except Exception as exc:
				problem = build_problem(exc)
				if problem is not None:
					await session.send_runtime_problem(problem)
					await session.wait_for_disconnect()
					return
				# Suppressed error types should not block startup or surface logs.
				pass
			finally:
				set_current_session(None)

			await _ensure_initial_state(page, session)
			await session.send_runtime_ready()
			await session.send_ui_snapshot()
			session.start_first_render_watchdog()
			await session.wait_for_disconnect()

		asyncio.run(_run_async())
		return 0


class App(RuntimeApp):
	pass


class ButterflyUIWeb:
	"""Web session configuration helper."""

	def __init__(self, **kwargs: Any) -> None:
		self.config = AppConfig(**kwargs)

	def run(self, main: Callable[["Page"], Any]) -> int:
		return RuntimeApp(main, self.config, target="web").run()


class ButterflyUIDesktop:
	"""Desktop session configuration helper."""

	def __init__(self, **kwargs: Any) -> None:
		self.config = AppConfig(**kwargs)

	def run(self, main: Callable[["Page"], Any]) -> int:
		return RuntimeApp(main, self.config, target="desktop").run()


class Page:
	"""Minimal Page container for step 1 (no UI diffing yet)."""

	def __init__(self, *, session: ButterflyUISession) -> None:
		self.session = session
		self.title: str = ""
		self.root: Any = None
		self.screen: Any = None
		self.overlay: Any = None
		self.splash: Any = None
		self._overlay_cleared: bool = False
		self.bgcolor: str | None = None
		self.background: Any = None
		self.style_pack: str | None = None
		# Theme/accessory for Candy; can be a CandyTheme or a plain dict
		self.candy: CandyTheme | dict[str, Any] | None = None
		# Devtools visibility / prefs used by some demos
		self.devtools: bool | None = None
		self.devtools_prefs: dict[str, Any] = {}
		# Custom style pack specs to register with the runtime
		self._style_packs: dict[str, dict[str, Any]] = {}
		self._style_pack_revision: int = 0
		# Track pending update tasks to ensure they complete before runtime.ready
		self._pending_updates: list[asyncio.Task[Any]] = []
		self._pending_update_task: asyncio.Task[Any] | None = None
		self._queued_update_payload: dict[str, Any] | None = None

	def _bind_inline_handlers(self) -> None:
		visited: set[int] = set()

		def walk(node: Any) -> None:
			marker = id(node)
			if marker in visited:
				return
			visited.add(marker)

			if isinstance(node, Control):
				try:
					node.bind_inline_event_handlers(self.session)
				except Exception:
					pass
				for child in node.children:
					walk(child)
				for value in node.props.values():
					walk(value)
				return

			if isinstance(node, dict):
				for value in node.values():
					walk(value)
				return

			if isinstance(node, (list, tuple, set)):
				for item in node:
					walk(item)

		walk(self.root)
		walk(self.screen)
		walk(self.overlay)
		walk(self.splash)

	def update(self) -> None:
		"""Send the current page state to the runtime.

		Sends a payload that may include root, screen, overlay, splash, title,
		and candy/devtools metadata when available.
		"""
		if not self._has_payload():
			return

		root_payload = self._coerce_root(self.root) if self.root is not None else None
		# If root is present but not serializable, warn and abort.
		if self.root is not None and root_payload is None:
			warnings.warn("Page.update() root is not serializable", RuntimeWarning)
			return

		payload: dict[str, Any] = {}
		if root_payload is not None:
			payload["root"] = root_payload
		if self.screen is not None:
			screen_payload = self._coerce_root(self.screen)
			if screen_payload is not None:
				payload["screen"] = screen_payload
		if self.overlay is not None:
			overlay_payload = self._coerce_root(self.overlay)
			if overlay_payload is not None:
				payload["overlay"] = overlay_payload
		elif self._overlay_cleared:
			payload["overlay"] = None
			self._overlay_cleared = False
		if self.splash is not None:
			splash_payload = self._coerce_root(self.splash)
			if splash_payload is not None:
				payload["splash"] = splash_payload
		if self.title:
			payload["title"] = self.title
		if self.style_pack:
			payload["style_pack"] = self.style_pack
		if self._style_packs:
			payload["style_packs"] = list(self._style_packs.values())
		if self.bgcolor:
			payload["bgcolor"] = self.bgcolor
		if self.background is not None:
			payload["background"] = coerce_json_value(self.background)
		if self.candy is not None:
			if isinstance(self.candy, CandyTheme):
				tokens_payload = self.candy.to_json()
			elif isinstance(self.candy, dict):
				tokens_payload = dict(self.candy)
			else:
				tokens_payload = None
			if tokens_payload is not None:
				payload["candy"] = tokens_payload
				payload["tokens"] = tokens_payload
		if self.devtools is not None:
			payload["devtools"] = bool(self.devtools)
		if self.devtools_prefs:
			payload["devtools_prefs"] = dict(self.devtools_prefs)
		payload.update(self._runtime_metadata_payload())

		try:
			loop = asyncio.get_running_loop()
		except RuntimeError:
			warnings.warn("Page.update() called outside of runtime loop", RuntimeWarning)
			return
		if self._pending_update_task is not None and not self._pending_update_task.done():
			self._queued_update_payload = payload
			return

		# Store tasks so we can await them before sending runtime.ready.
		# Coalesce bursts of update() calls into sequential latest-payload sends.
		self._pending_update_task = loop.create_task(self._flush_updates(payload))
		self._pending_updates.append(self._pending_update_task)

	async def _flush_updates(self, initial_payload: dict[str, Any]) -> None:
		payload = initial_payload
		while True:
			self._bind_inline_handlers()
			await self.session.send_ui_payload(payload)
			next_payload = self._queued_update_payload
			self._queued_update_payload = None
			if next_payload is None:
				break
			payload = next_payload

	def clear_overlay(self) -> None:
		self.overlay = None
		self._overlay_cleared = True

	def clear_splash(self) -> None:
		self.splash = None

	def set_root(self, root: Any) -> None:
		"""Set the page root (does not automatically call update)."""
		self.root = root

	def set_splash(self, splash: Any) -> None:
		"""Set the splash content (does not automatically call update)."""
		self.splash = splash

	def set_overlay(self, overlay: Any) -> None:
		"""Set the overlay content (does not automatically call update)."""
		self.overlay = overlay
		self._overlay_cleared = False

	def set_screen(self, screen: Any) -> None:
		"""Set the screen layer (separate from root/overlay)."""
		self.screen = screen

	def set_style_pack(self, name: str | None) -> None:
		"""Set the style pack name to use on the runtime."""
		next_name = name or None
		if self.style_pack != next_name:
			self.style_pack = next_name
			self._mark_style_pack_changed()

	def register_style_pack(
		self,
		name: str,
		*,
		tokens: Any | None = None,
		base: str | None = None,
		background: Any | None = None,
		overrides: dict[str, Any] | None = None,
		components: dict[str, Any] | None = None,
		motion: dict[str, Any] | None = None,
		effects: dict[str, Any] | None = None,
	) -> dict[str, Any]:
		"""Register a custom style pack with the runtime."""
		from .style_packs import register_style_pack as _register_style_pack

		spec = _register_style_pack(
			name,
			tokens=tokens,
			base=base,
			background=coerce_json_value(background) if background is not None else None,
			overrides=overrides,
			components=components,
			motion=motion,
			effects=effects,
		)
		self._style_packs[str(spec.get("name") or name)] = dict(spec)
		self._mark_style_pack_changed()
		return spec

	def set_background(self, background: Any) -> None:
		"""Set a background spec for the runtime (color/gradient/image)."""
		self.background = background

	def set_bgcolor(self, color: str | None) -> None:
		"""Set a plain background color string for the runtime."""
		self.bgcolor = color

	def add(self, *children: Any) -> None:
		"""Add child(ren) into the page root. If no root exists the first
		child becomes the root; if multiple children are provided they are
	t	wrapped into a Column when needed."""
		if not children:
			return
		from .controls.layout import Column

		if self.root is None:
			if len(children) == 1:
				self.root = children[0]
			else:
				self.root = Column(*children)
			return

		# If root is a Component/Control, append new children to its children list
		if isinstance(self.root, Control):
			for child in children:
				if isinstance(child, Control):
					self.root.children.append(child)
				else:
					# Coerce non-Control children into text nodes
					from .controls.display import Text
					self.root.children.append(Text(str(child)))
			return

		# Fallback: replace root with a Column containing the previous root and new children
		try:
			self.root = Column(self.root, *children)
		except Exception:
			# If we can't wrap, just set the first child
			self.root = children[0]

	def set_devtools_prefs(self, **prefs: Any) -> None:
		"""Update the devtools prefs dict used by some demos."""
		if not prefs:
			return
		self.devtools_prefs.update(prefs)

	async def await_updates(self) -> None:
		"""Wait for all pending update tasks to complete.
		
		This ensures that UI updates sent via page.update() have completed
		before we proceed with sending runtime.ready to the Dart client.
		"""
		if not self._pending_updates:
			return
		await asyncio.gather(*self._pending_updates, return_exceptions=True)
		self._pending_updates.clear()
		self._pending_update_task = None
		self._queued_update_payload = None

	def _has_payload(self) -> bool:
		if self.root is not None or self.screen is not None or self.overlay is not None or self.splash is not None:
			return True
		if self._overlay_cleared:
			return True
		if self.title:
			return True
		if self.style_pack:
			return True
		if self._style_packs:
			return True
		if self.bgcolor:
			return True
		if self.background is not None:
			return True
		if self.candy is not None:
			return True
		if self.devtools is not None:
			return True
		if self.devtools_prefs:
			return True
		if self._style_pack_revision > 0:
			return True
		return False

	def _mark_style_pack_changed(self) -> None:
		self._style_pack_revision += 1

	def _style_pack_sync_hash(self) -> str:
		payload = {
			"style_pack": self.style_pack,
			"style_packs": self._style_packs,
		}
		raw = json.dumps(payload, sort_keys=True, separators=(",", ":"), default=str)
		return hashlib.sha256(raw.encode("utf-8")).hexdigest()[:16]

	def _runtime_metadata_payload(self) -> dict[str, Any]:
		protocol = int(getattr(getattr(self.session, "_config", None), "protocol", 1) or 1)
		return {
			"protocol_version": protocol,
			"contract_version": "whatwedid_v1",
			"modifier_capabilities": modifier_capabilities_manifest(),
			"style_pack_revision": self._style_pack_revision,
			"style_pack_hash": self._style_pack_sync_hash(),
		}

	def _coerce_root(self, value: Any) -> dict[str, Any] | None:
		if isinstance(value, Control):
			return value.to_json()
		if hasattr(value, "to_json"):
			try:
				payload = value.to_json()
				if isinstance(payload, dict):
					return payload
			except Exception:
				return None
		if isinstance(value, dict):
			return value
		return None


def _build_plan_for_app(
	*,
	target: RunTarget | str | None,
	config: str | None,
	kwargs: dict[str, Any],
) -> RuntimePlan:
	if "mode" in kwargs:
		raise TypeError('`mode=` is not supported. Use `target="desktop"` or `target="web"`.')
	if "desktop" in kwargs:
		raise TypeError('`desktop=` is not supported. Use `target="desktop"` or `target="web"`.')
	return build_runtime_plan(
		target=target,
		config_path=config,
		overrides=dict(kwargs),
	)


def run(
	main: Callable[[Page], Any],
	*,
	target: RunTarget | str | None = None,
	config: str | None = None,
	**kwargs: Any,
) -> int:
	"""Run a ButterflyUI app using deterministic target boot profiles."""
	plan = _build_plan_for_app(target=target, config=config, kwargs=kwargs)
	app_config = AppConfig(**plan.as_app_config_kwargs())
	return RuntimeApp(
		main,
		app_config,
		target=plan.target,
		auto_install=plan.auto_install,
	).run()


def app(
	main: Callable[[Page], Any],
	*,
	target: RunTarget | str | None = None,
	config: str | None = None,
	**kwargs: Any,
) -> int:
	"""Backward-compatible alias for :func:`run`."""
	return run(main, target=target, config=config, **kwargs)


def run_web(main: Callable[[Page], Any], **kwargs: Any) -> int:
	"""Run a ButterflyUI app in web target mode."""
	return run(main, target="web", **kwargs)


def run_desktop(main: Callable[[Page], Any], **kwargs: Any) -> int:
	"""Run a ButterflyUI app in desktop target mode."""
	return run(main, target="desktop", **kwargs)


__all__ = [
	"App",
	"AppConfig",
	"BaseApp",
	"ButterflyUIDesktop",
	"ButterflyUIError",
	"ButterflyUISession",
	"ButterflyUIWeb",
	"DesktopSession",
	"Page",
	"RunTarget",
	"RuntimeApp",
	"RuntimePlan",
	"WebSession",
	"app",
	"run",
	"run_web",
	"run_desktop",
]
