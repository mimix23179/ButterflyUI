from __future__ import annotations

import json
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
PYTHON_CONTROLS_ROOT = (
    REPO_ROOT
    / "butterflyui"
    / "sdk"
    / "python"
    / "packages"
    / "butterflyui"
    / "src"
    / "butterflyui"
    / "controls"
)
DART_CONTROLS_ROOT = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
)
CORE_ROOT = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
)
DEMO_ROOT = REPO_ROOT / "demo"
TEST_ROOT = REPO_ROOT / "butterflyui" / "src" / "test"
CONTROL_RENDERER = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "control_renderer.dart"
)
ARTIFACTS_DIR = Path(__file__).resolve().parent / "artifacts"

CONTROL_TYPE_RE = re.compile(r'control_type\s*=\s*"([^"]+)"')
PROPS_RE = re.compile(r"props\[['\"]([^'\"]+)['\"]\]")
SEND_EVENT_RE = re.compile(r"sendEvent\([^,\n]+,\s*'([^']+)'")
INVOKE_CASE_RE = re.compile(r"case\s+'([^']+)':")
TOP_LEVEL_CASE_RE = re.compile(r"^\s*case\s+'([^']+)':", re.MULTILINE)
REGISTRY_REGISTER_RE = re.compile(r"register\(\s*'([^']+)'\s*,")
JSON_CONTROL_TYPE_RE = re.compile(r'"type"\s*:\s*"([^"]+)"')


@dataclass
class DartControlInfo:
    relative_path: str
    stateful: bool
    has_focus: bool
    props: set[str]
    events: set[str]
    invoke_methods: set[str]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def collect_python_controls() -> dict[str, list[str]]:
    result: dict[str, list[str]] = defaultdict(list)
    for path in sorted(PYTHON_CONTROLS_ROOT.rglob("*.py")):
        matches = CONTROL_TYPE_RE.findall(read_text(path))
        for control_type in matches:
            result[control_type].append(path.relative_to(REPO_ROOT).as_posix())
    return dict(sorted(result.items()))


def collect_dart_controls() -> tuple[dict[str, list[DartControlInfo]], dict[str, DartControlInfo]]:
    grouped: dict[str, list[DartControlInfo]] = defaultdict(list)
    file_index: dict[str, DartControlInfo] = {}
    for path in sorted(DART_CONTROLS_ROOT.rglob("*.dart")):
        text = read_text(path)
        stem = path.stem
        info = DartControlInfo(
            relative_path=path.relative_to(REPO_ROOT).as_posix(),
            stateful="StatefulWidget" in text,
            has_focus="FocusNode" in text,
            props=set(PROPS_RE.findall(text)),
            events=set(SEND_EVENT_RE.findall(text)),
            invoke_methods=set(INVOKE_CASE_RE.findall(text))
            if "_handleInvoke" in text
            else set(),
        )
        grouped[stem].append(info)
        file_index[info.relative_path] = info
    return dict(sorted(grouped.items())), file_index


def collect_renderer_cases() -> set[str]:
    text = read_text(CONTROL_RENDERER)
    switch_start = text.find("switch (type)")
    switch_end = text.find("Widget _buildWithUniversalDecorators")
    if switch_start == -1:
        body = text
    elif switch_end == -1:
        body = text[switch_start:]
    else:
        body = text[switch_start:switch_end]
    return set(TOP_LEVEL_CASE_RE.findall(body))


def collect_registry_registrations() -> dict[str, set[str]]:
    registrations: dict[str, set[str]] = defaultdict(set)
    for path in sorted(CORE_ROOT.rglob("*.dart")):
        relative_path = path.relative_to(REPO_ROOT).as_posix()
        for control_type in REGISTRY_REGISTER_RE.findall(read_text(path)):
            registrations[control_type].add(relative_path)
    return dict(sorted(registrations.items()))


def collect_text_coverage(
    root: Path,
    control_types: set[str],
    allowed_suffixes: set[str],
) -> dict[str, list[str]]:
    coverage: dict[str, set[str]] = defaultdict(set)
    if not root.exists():
        return {}
    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in allowed_suffixes:
            continue
        text = read_text(path)
        relative_path = path.relative_to(REPO_ROOT).as_posix()
        matched = set(JSON_CONTROL_TYPE_RE.findall(text))
        for control_type in control_types:
            if control_type in matched or re.search(rf"\b{re.escape(control_type)}\b", text):
                coverage[control_type].add(relative_path)
    return {
        control_type: sorted(paths)
        for control_type, paths in sorted(coverage.items())
    }


def helper_match_stems(control_type: str) -> list[str]:
    if control_type in {
        "button",
        "elevated_button",
        "filled_button",
        "outlined_button",
        "text_button",
        "icon_button",
    }:
        return ["button_runtime"]
    return []


def resolve_dart_matches(
    control_type: str,
    dart_controls: dict[str, list[DartControlInfo]],
    file_index: dict[str, DartControlInfo],
    registry_registrations: dict[str, set[str]],
) -> list[DartControlInfo]:
    matches: list[DartControlInfo] = []
    seen_paths: set[str] = set()

    def add_items(items: list[DartControlInfo]) -> None:
        for item in items:
            if item.relative_path in seen_paths:
                continue
            seen_paths.add(item.relative_path)
            matches.append(item)

    direct = list(dart_controls.get(control_type, []))
    add_items(direct)
    for helper_stem in helper_match_stems(control_type):
        add_items(list(dart_controls.get(helper_stem, [])))
    if matches:
        return matches
    registered_files = registry_registrations.get(control_type, set())
    if registered_files:
        add_items([
            file_index[path]
            for path in sorted(registered_files)
            if path in file_index
        ])
        for helper_stem in helper_match_stems(control_type):
            add_items(list(dart_controls.get(helper_stem, [])))
        if matches:
            return matches
    stem = control_type.removesuffix("_control")
    add_items(list(dart_controls.get(stem, [])))
    for helper_stem in helper_match_stems(control_type):
        add_items(list(dart_controls.get(helper_stem, [])))
    return matches


def summarize_row(
    control_type: str,
    python_files: list[str],
    renderer_cases: set[str],
    registry_registrations: dict[str, set[str]],
    dart_controls: dict[str, list[DartControlInfo]],
    file_index: dict[str, DartControlInfo],
    demo_coverage: dict[str, list[str]],
    test_coverage: dict[str, list[str]],
) -> dict[str, object]:
    matches = resolve_dart_matches(
        control_type,
        dart_controls,
        file_index,
        registry_registrations,
    )
    props = sorted({prop for item in matches for prop in item.props})
    events = sorted({event for item in matches for event in item.events})
    invoke_methods = sorted(
        {
            method
            for item in matches
            for method in item.invoke_methods
            if method not in {"linear", "ease", "ease_in", "ease_out", "ease_in_out"}
        }
    )
    stateful = any(item.stateful for item in matches)
    has_focus = any(item.has_focus for item in matches)
    renderer_registered = control_type in renderer_cases
    registry_registered = control_type in registry_registrations
    runtime_registered = renderer_registered or registry_registered
    has_semantics = runtime_registered
    demo_files = demo_coverage.get(control_type, [])
    test_files = test_coverage.get(control_type, [])

    status = "mismatch"
    if runtime_registered and matches:
        if len(props) <= 3 and not events and not invoke_methods:
            status = "stub"
        elif props and events and invoke_methods and (stateful or has_focus):
            status = "complete"
        else:
            status = "partial"

    return {
        "control_type": control_type,
        "python_files": python_files,
        "renderer_registered": renderer_registered,
        "registry_registered": registry_registered,
        "runtime_registered": runtime_registered,
        "dart_files": [item.relative_path for item in matches],
        "stateful": stateful,
        "has_focus": has_focus,
        "has_semantics": has_semantics,
        "consumed_props": props,
        "emitted_events": events,
        "invoke_methods": invoke_methods,
        "demo_files": demo_files,
        "test_files": test_files,
        "status": status,
    }


def build_markdown(
    rows: list[dict[str, object]],
    renderer_cases: set[str],
    registry_registrations: dict[str, set[str]],
) -> str:
    complete = sum(1 for row in rows if row["status"] == "complete")
    partial = sum(1 for row in rows if row["status"] == "partial")
    stub = sum(1 for row in rows if row["status"] == "stub")
    mismatch = sum(1 for row in rows if row["status"] == "mismatch")
    missing_runtime = [
        row["control_type"]
        for row in rows
        if not row["runtime_registered"]
    ]
    no_invoke = [
        row["control_type"]
        for row in rows
        if row["dart_files"] and not row["invoke_methods"]
    ]
    no_focus = [
        row["control_type"]
        for row in rows
        if row["dart_files"] and not row["has_focus"]
    ]
    no_demo = [
        row["control_type"]
        for row in rows
        if row["dart_files"] and not row["demo_files"]
    ]
    no_test = [
        row["control_type"]
        for row in rows
        if row["dart_files"] and not row["test_files"]
    ]

    lines = [
        "# Dart Runtime Control Matrix",
        "",
        "## Summary",
        "",
        f"- Total Python controls: `{len(rows)}`",
        f"- Renderer cases in `control_renderer.dart`: `{len(renderer_cases)}`",
        f"- Direct registry registrations outside `control_renderer.dart`: `{len(registry_registrations)}`",
        f"- Controls with demo coverage: `{sum(1 for row in rows if row['demo_files'])}`",
        f"- Controls with test coverage: `{sum(1 for row in rows if row['test_files'])}`",
        f"- `complete`: `{complete}`",
        f"- `partial`: `{partial}`",
        f"- `stub`: `{stub}`",
        f"- `mismatch`: `{mismatch}`",
        "",
        "## Missing Runtime Registration",
        "",
    ]
    if missing_runtime:
        lines.extend(f"- `{name}`" for name in missing_runtime[:80])
    else:
        lines.append("- none")

    lines.extend(
        [
            "",
            "## Controls Without Invoke Methods",
            "",
        ]
    )
    if no_invoke:
        lines.extend(f"- `{name}`" for name in no_invoke[:80])
    else:
        lines.append("- none")

    lines.extend(
        [
            "",
            "## Controls Without Focus Infrastructure",
            "",
        ]
    )
    if no_focus:
        lines.extend(f"- `{name}`" for name in no_focus[:80])
    else:
        lines.append("- none")

    lines.extend(
        [
            "",
            "## Controls Without Demo Coverage",
            "",
        ]
    )
    if no_demo:
        lines.extend(f"- `{name}`" for name in no_demo[:80])
    else:
        lines.append("- none")

    lines.extend(
        [
            "",
            "## Controls Without Test Coverage",
            "",
        ]
    )
    if no_test:
        lines.extend(f"- `{name}`" for name in no_test[:80])
    else:
        lines.append("- none")

    lines.extend(
        [
            "",
            "## Detailed Rows",
            "",
            "| Control | Status | Runtime | Stateful | Focus | Semantics | Demo | Test | Props | Events | Invoke | Dart files |",
            "|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|",
        ]
    )
    for row in rows:
        lines.append(
            "| {control} | {status} | {runtime} | {stateful} | {focus} | {semantics} | {demo} | {test} | {props} | {events} | {invoke} | {files} |".format(
                control=row["control_type"],
                status=row["status"],
                runtime="yes" if row["runtime_registered"] else "no",
                stateful="yes" if row["stateful"] else "no",
                focus="yes" if row["has_focus"] else "no",
                semantics="yes" if row["has_semantics"] else "no",
                demo="yes" if row["demo_files"] else "no",
                test="yes" if row["test_files"] else "no",
                props=len(row["consumed_props"]),
                events=len(row["emitted_events"]),
                invoke=len(row["invoke_methods"]),
                files="<br>".join(row["dart_files"]) if row["dart_files"] else "-",
            )
        )
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    ARTIFACTS_DIR.mkdir(parents=True, exist_ok=True)
    python_controls = collect_python_controls()
    control_types = set(python_controls.keys())
    dart_controls, file_index = collect_dart_controls()
    renderer_cases = collect_renderer_cases()
    registry_registrations = collect_registry_registrations()
    demo_coverage = collect_text_coverage(
        DEMO_ROOT,
        control_types,
        allowed_suffixes={".json", ".py", ".md"},
    )
    test_coverage = collect_text_coverage(
        TEST_ROOT,
        control_types,
        allowed_suffixes={".dart", ".md"},
    )

    rows = [
        summarize_row(
            control_type,
            python_files,
            renderer_cases,
            registry_registrations,
            dart_controls,
            file_index,
            demo_coverage,
            test_coverage,
        )
        for control_type, python_files in python_controls.items()
    ]

    (ARTIFACTS_DIR / "control_matrix.json").write_text(
        json.dumps(rows, indent=2, sort_keys=True),
        encoding="utf-8",
    )
    (ARTIFACTS_DIR / "control_matrix.md").write_text(
        build_markdown(rows, renderer_cases, registry_registrations),
        encoding="utf-8",
    )
    print(f"Wrote {ARTIFACTS_DIR / 'control_matrix.json'}")
    print(f"Wrote {ARTIFACTS_DIR / 'control_matrix.md'}")


if __name__ == "__main__":
    main()
