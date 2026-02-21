from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Literal

try:
    import tomllib
except ModuleNotFoundError:  # pragma: no cover - Python 3.10 fallback
    import tomli as tomllib  # type: ignore[no-redef]


RunTarget = Literal["desktop", "web"]
KNOWN_TARGETS: tuple[RunTarget, RunTarget] = ("desktop", "web")
DEFAULT_CONFIG_FILENAME = "butterflyui.toml"
_LOCAL_HOSTS = {"127.0.0.1", "localhost"}


@dataclass(frozen=True, slots=True)
class BootProfile:
    target: RunTarget
    renderer: str
    transport: str
    launches_runtime: bool
    requires_asset_server: bool
    enforce_local_host: bool
    default_host: str = "127.0.0.1"
    default_port: int = 8765
    default_path: str = "/ws"
    default_auto_install: bool = True


BOOT_PROFILES: dict[RunTarget, BootProfile] = {
    "desktop": BootProfile(
        target="desktop",
        renderer="flutter-desktop",
        transport="websocket",
        launches_runtime=True,
        requires_asset_server=False,
        enforce_local_host=False,
        default_host="127.0.0.1",
        default_port=8765,
        default_path="/ws",
        default_auto_install=True,
    ),
    "web": BootProfile(
        target="web",
        renderer="flutter-web",
        transport="websocket",
        launches_runtime=False,
        requires_asset_server=True,
        enforce_local_host=True,
        default_host="127.0.0.1",
        default_port=8765,
        default_path="/ws",
        default_auto_install=False,
    ),
}


@dataclass(slots=True)
class RunnerConfig:
    path: Path | None = None
    default_target: RunTarget | None = None
    default_entry: str | None = None
    target_defaults: dict[RunTarget, dict[str, Any]] = field(
        default_factory=lambda: {"desktop": {}, "web": {}}
    )

    def defaults_for_target(self, target: RunTarget) -> dict[str, Any]:
        return dict(self.target_defaults.get(target, {}))


@dataclass(frozen=True, slots=True)
class RuntimePlan:
    target: RunTarget
    profile: BootProfile
    config_path: Path | None
    source: Literal["explicit", "config", "default"]
    host: str
    port: int
    path: str
    token: str | None
    require_token: bool
    protocol: int
    target_fps: int
    hello_timeout: float | None
    first_render_timeout: float | None
    auto_install: bool

    def as_app_config_kwargs(self) -> dict[str, Any]:
        return {
            "host": self.host,
            "port": self.port,
            "path": self.path,
            "token": self.token,
            "require_token": self.require_token,
            "protocol": self.protocol,
            "target_fps": self.target_fps,
            "hello_timeout": self.hello_timeout,
            "first_render_timeout": self.first_render_timeout,
        }

    def local_endpoints(self) -> list[str]:
        return [f"127.0.0.1:{self.port}", f"localhost:{self.port}"]


_ALLOWED_TARGET_SETTING_KEYS = {
    "host",
    "port",
    "path",
    "token",
    "require_token",
    "protocol",
    "target_fps",
    "hello_timeout",
    "first_render_timeout",
    "auto_install",
}


def get_boot_profile(target: RunTarget | str) -> BootProfile:
    normalized = normalize_target(target, field_name="target")
    return BOOT_PROFILES[normalized]


def load_runner_config(config_path: str | Path | None = None) -> RunnerConfig:
    path = _resolve_config_path(config_path)
    if path is None:
        return RunnerConfig()

    try:
        raw = tomllib.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise ValueError(f"Failed to parse {path}: {exc}") from exc

    if not isinstance(raw, dict):
        raise ValueError(f"{path} must contain a TOML table at the root.")

    run_table = raw.get("run")
    if run_table is None:
        run_table = {}
    if not isinstance(run_table, dict):
        raise ValueError(f"{path} [run] must be a TOML table.")

    targets_table = raw.get("targets")
    if targets_table is None:
        targets_table = {}
    if not isinstance(targets_table, dict):
        raise ValueError(f"{path} [targets] must be a TOML table.")

    default_target: RunTarget | None = None
    if "target" in run_table:
        default_target = normalize_target(run_table.get("target"), field_name="run.target")

    default_entry: str | None = None
    if "entry" in run_table:
        entry = run_table.get("entry")
        if entry is None:
            default_entry = None
        elif isinstance(entry, str) and entry.strip():
            default_entry = entry.strip()
        else:
            raise ValueError(f"{path} run.entry must be a non-empty string.")

    target_defaults: dict[RunTarget, dict[str, Any]] = {"desktop": {}, "web": {}}
    for target in KNOWN_TARGETS:
        raw_target = targets_table.get(target, {})
        if raw_target is None:
            raw_target = {}
        if not isinstance(raw_target, dict):
            raise ValueError(f"{path} targets.{target} must be a TOML table.")
        unknown = sorted(set(raw_target.keys()) - _ALLOWED_TARGET_SETTING_KEYS)
        if unknown:
            joined = ", ".join(unknown)
            raise ValueError(
                f"{path} targets.{target} has unknown keys: {joined}. "
                f"Allowed keys: {', '.join(sorted(_ALLOWED_TARGET_SETTING_KEYS))}."
            )
        target_defaults[target] = dict(raw_target)

    return RunnerConfig(
        path=path,
        default_target=default_target,
        default_entry=default_entry,
        target_defaults=target_defaults,
    )


def resolve_run_target(
    *,
    explicit_target: RunTarget | str | None,
    config: RunnerConfig,
    fallback_target: RunTarget = "desktop",
) -> tuple[RunTarget, Literal["explicit", "config", "default"]]:
    if explicit_target is not None:
        return normalize_target(explicit_target, field_name="target"), "explicit"
    if config.default_target is not None:
        return config.default_target, "config"
    return fallback_target, "default"


def build_runtime_plan(
    *,
    target: RunTarget | str | None = None,
    config_path: str | Path | None = None,
    overrides: dict[str, Any] | None = None,
    fallback_target: RunTarget = "desktop",
) -> RuntimePlan:
    config = load_runner_config(config_path)
    if overrides:
        unknown = sorted(set(overrides.keys()) - _ALLOWED_TARGET_SETTING_KEYS)
        if unknown:
            joined = ", ".join(unknown)
            raise TypeError(
                f"Unknown runtime option(s): {joined}. "
                f"Allowed options: {', '.join(sorted(_ALLOWED_TARGET_SETTING_KEYS))}."
            )
    resolved_target, source = resolve_run_target(
        explicit_target=target,
        config=config,
        fallback_target=fallback_target,
    )
    profile = get_boot_profile(resolved_target)

    settings: dict[str, Any] = {
        "host": profile.default_host,
        "port": profile.default_port,
        "path": profile.default_path,
        "token": None,
        "require_token": False,
        "protocol": 1,
        "target_fps": 60,
        "hello_timeout": 10.0,
        "first_render_timeout": 10.0,
        "auto_install": profile.default_auto_install,
    }
    settings.update(config.defaults_for_target(resolved_target))
    if overrides:
        settings.update(overrides)

    host = _normalize_host(settings.get("host"), profile=profile)
    port = _coerce_port(settings.get("port"))
    path = _normalize_path(settings.get("path"))
    token = _coerce_optional_string(settings.get("token"))
    require_token = bool(settings.get("require_token", False))
    protocol = _coerce_positive_int(settings.get("protocol"), field_name="protocol")
    target_fps = _coerce_positive_int(settings.get("target_fps"), field_name="target_fps")
    hello_timeout = _coerce_optional_float(settings.get("hello_timeout"), field_name="hello_timeout")
    first_render_timeout = _coerce_optional_float(
        settings.get("first_render_timeout"),
        field_name="first_render_timeout",
    )
    auto_install = bool(settings.get("auto_install", profile.default_auto_install))

    return RuntimePlan(
        target=resolved_target,
        profile=profile,
        config_path=config.path,
        source=source,
        host=host,
        port=port,
        path=path,
        token=token,
        require_token=require_token,
        protocol=protocol,
        target_fps=target_fps,
        hello_timeout=hello_timeout,
        first_render_timeout=first_render_timeout,
        auto_install=auto_install,
    )


def normalize_target(value: Any, *, field_name: str) -> RunTarget:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{field_name} must be 'desktop' or 'web'.")
    normalized = value.strip().lower()
    if normalized not in KNOWN_TARGETS:
        raise ValueError(f"{field_name} must be 'desktop' or 'web'.")
    return normalized  # type: ignore[return-value]


def _resolve_config_path(config_path: str | Path | None) -> Path | None:
    if config_path is not None:
        path = Path(config_path).expanduser().resolve()
        if not path.exists():
            raise ValueError(f"Config file does not exist: {path}")
        return path

    default = (Path.cwd() / DEFAULT_CONFIG_FILENAME).resolve()
    if default.exists():
        return default
    return None


def _normalize_host(value: Any, *, profile: BootProfile) -> str:
    if value is None:
        host = profile.default_host
    elif isinstance(value, str):
        host = value.strip()
    else:
        host = str(value).strip()
    if not host:
        host = profile.default_host
    if "://" in host:
        raise ValueError(
            "host must be a plain host value (for example 127.0.0.1 or localhost), "
            "not a URL."
        )
    if profile.enforce_local_host and host not in _LOCAL_HOSTS:
        raise ValueError(
            f"Target '{profile.target}' only supports local hosts "
            "(127.0.0.1 or localhost)."
        )
    return host


def _coerce_port(value: Any) -> int:
    try:
        port = int(value)
    except (TypeError, ValueError) as exc:
        raise ValueError("port must be an integer.") from exc
    if port < 1 or port > 65535:
        raise ValueError("port must be between 1 and 65535.")
    return port


def _normalize_path(value: Any) -> str:
    if value is None:
        return "/ws"
    if not isinstance(value, str):
        value = str(value)
    path = value.strip()
    if not path:
        return "/ws"
    if not path.startswith("/"):
        path = f"/{path}"
    return path


def _coerce_optional_string(value: Any) -> str | None:
    if value is None:
        return None
    if not isinstance(value, str):
        value = str(value)
    out = value.strip()
    return out or None


def _coerce_positive_int(value: Any, *, field_name: str) -> int:
    try:
        out = int(value)
    except (TypeError, ValueError) as exc:
        raise ValueError(f"{field_name} must be an integer.") from exc
    if out <= 0:
        raise ValueError(f"{field_name} must be greater than 0.")
    return out


def _coerce_optional_float(value: Any, *, field_name: str) -> float | None:
    if value is None:
        return None
    try:
        out = float(value)
    except (TypeError, ValueError) as exc:
        raise ValueError(f"{field_name} must be a number or null.") from exc
    if out <= 0:
        raise ValueError(f"{field_name} must be greater than 0 when provided.")
    return out


__all__ = [
    "BOOT_PROFILES",
    "BootProfile",
    "DEFAULT_CONFIG_FILENAME",
    "KNOWN_TARGETS",
    "RunTarget",
    "RunnerConfig",
    "RuntimePlan",
    "build_runtime_plan",
    "get_boot_profile",
    "load_runner_config",
    "normalize_target",
    "resolve_run_target",
]
