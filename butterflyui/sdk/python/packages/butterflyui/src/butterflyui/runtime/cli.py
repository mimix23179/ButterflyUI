from __future__ import annotations

import argparse
import importlib
import sys
from typing import Any, Callable

from ..app import Page, run as run_app
from .runner import KNOWN_TARGETS, RuntimePlan, build_runtime_plan, load_runner_config


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="butterflyui",
        description="ButterflyUI deterministic app runner",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    run_parser = subparsers.add_parser("run", help="Run a ButterflyUI app")
    _add_target_arguments(run_parser, include_entry=True)

    plan_parser = subparsers.add_parser("plan", help="Print resolved boot plan")
    _add_target_arguments(plan_parser, include_entry=False)

    return parser


def _add_target_arguments(parser: argparse.ArgumentParser, *, include_entry: bool) -> None:
    parser.add_argument(
        "target",
        nargs="?",
        choices=KNOWN_TARGETS,
        help="Run target (desktop or web). If omitted, ButterflyUI uses butterflyui.toml or defaults to desktop.",
    )
    parser.add_argument(
        "--config",
        dest="config_path",
        default=None,
        help="Path to butterflyui.toml (default: ./butterflyui.toml if present).",
    )
    if include_entry:
        parser.add_argument(
            "--entry",
            default=None,
            help="Entrypoint in module:function form (default: run.entry in butterflyui.toml or app:main).",
        )

    parser.add_argument("--host", default=None, help="Runtime host override.")
    parser.add_argument("--port", type=int, default=None, help="Runtime port override.")
    parser.add_argument("--path", default=None, help="Runtime websocket path override.")
    parser.add_argument("--token", default=None, help="Session token override.")
    parser.add_argument("--protocol", type=int, default=None, help="Protocol version override.")
    parser.add_argument("--target-fps", type=int, default=None, dest="target_fps")
    parser.add_argument("--hello-timeout", type=float, default=None, dest="hello_timeout")
    parser.add_argument(
        "--first-render-timeout",
        type=float,
        default=None,
        dest="first_render_timeout",
    )

    parser.add_argument("--require-token", dest="require_token", action="store_true")
    parser.add_argument("--no-require-token", dest="require_token", action="store_false")
    parser.set_defaults(require_token=None)

    parser.add_argument("--auto-install", dest="auto_install", action="store_true")
    parser.add_argument("--no-install", dest="auto_install", action="store_false")
    parser.set_defaults(auto_install=None)


def _collect_plan_overrides(args: argparse.Namespace) -> dict[str, Any]:
    overrides: dict[str, Any] = {}
    for key in (
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
    ):
        value = getattr(args, key, None)
        if value is not None:
            overrides[key] = value
    return overrides


def _load_entrypoint(entry: str) -> Callable[[Page], Any]:
    if ":" not in entry:
        raise ValueError(
            f"Invalid --entry value {entry!r}. Expected module:function (example: app:main)."
        )
    module_name, func_name = entry.split(":", 1)
    module_name = module_name.strip()
    func_name = func_name.strip()
    if not module_name or not func_name:
        raise ValueError(
            f"Invalid --entry value {entry!r}. Expected module:function (example: app:main)."
        )

    module = importlib.import_module(module_name)
    func = getattr(module, func_name, None)
    if func is None:
        raise AttributeError(f"Entrypoint {entry!r} not found.")
    if not callable(func):
        raise TypeError(f"Entrypoint {entry!r} is not callable.")
    return func


def _resolve_entry(config_path: str | None, explicit_entry: str | None) -> str:
    if explicit_entry:
        return explicit_entry.strip()
    config = load_runner_config(config_path)
    if config.default_entry:
        return config.default_entry
    return "app:main"


def _format_plan(plan: RuntimePlan) -> str:
    lines = [
        f"target: {plan.target}",
        f"source: {plan.source}",
        f"profile.renderer: {plan.profile.renderer}",
        f"profile.transport: {plan.profile.transport}",
        f"profile.launches_runtime: {plan.profile.launches_runtime}",
        f"host: {plan.host}",
        f"port: {plan.port}",
        f"path: {plan.path}",
        f"require_token: {plan.require_token}",
        f"target_fps: {plan.target_fps}",
        f"hello_timeout: {plan.hello_timeout}",
        f"first_render_timeout: {plan.first_render_timeout}",
        f"auto_install: {plan.auto_install}",
    ]
    if plan.config_path is not None:
        lines.append(f"config: {plan.config_path}")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    try:
        plan = build_runtime_plan(
            target=args.target,
            config_path=args.config_path,
            overrides=_collect_plan_overrides(args),
        )

        if args.command == "plan":
            print(_format_plan(plan))
            return 0

        if args.command == "run":
            entry = _resolve_entry(args.config_path, getattr(args, "entry", None))
            main_func = _load_entrypoint(entry)
            return run_app(
                main_func,
                target=plan.target,
                config=args.config_path,
                **_collect_plan_overrides(args),
            )

        parser.print_help()
        return 2
    except Exception as exc:
        print(f"butterflyui: {exc}", file=sys.stderr)
        return 2


__all__ = ["main"]
