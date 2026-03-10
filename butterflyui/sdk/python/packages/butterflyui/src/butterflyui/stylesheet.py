from __future__ import annotations

from dataclasses import dataclass
import ast
import json
import re
from typing import Any

__all__ = [
    "StyleSelector",
    "StyleRule",
    "StyleSheet",
    "parse_stylesheet",
]


_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
_NUMBER_RE = re.compile(r"^[+-]?(?:\d+(?:\.\d+)?|\.\d+)$")
_TOKEN_RE = re.compile(r"(#[A-Za-z_][\w-]*)|(\.[A-Za-z_][\w-]*)|([A-Za-z_*][\w-]*)")

_PROPERTY_ALIASES = {
    "background_color": "bgcolor",
    "text_color": "text_color",
    "foreground_color": "foreground",
    "border_radius": "radius",
    "box_shadow": "shadow",
    "background_effect": "background_effect",
    "foreground_effect": "foreground_effect",
    "overlay_effect": "overlay_effect",
    "hover_background_effect": "hover_background_effect",
    "hover_effect": "hover_effect",
}

_LIST_VALUE_KEYS = {
    "effect",
    "effects",
    "background_effect",
    "foreground_effect",
    "overlay_effect",
    "hover_background_effect",
    "hover_effect",
    "classes",
}


def _norm(value: str) -> str:
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _split_top_level(source: str, delimiter: str) -> list[str]:
    parts: list[str] = []
    buffer: list[str] = []
    depth = 0
    quote: str | None = None
    escape = False
    for char in source:
        if quote is not None:
            buffer.append(char)
            if escape:
                escape = False
            elif char == "\\":
                escape = True
            elif char == quote:
                quote = None
            continue
        if char in {'"', "'"}:
            quote = char
            buffer.append(char)
            continue
        if char in "([{":
            depth += 1
            buffer.append(char)
            continue
        if char in ")]}":
            depth = max(0, depth - 1)
            buffer.append(char)
            continue
        if char == delimiter and depth == 0:
            part = "".join(buffer).strip()
            if part:
                parts.append(part)
            buffer.clear()
            continue
        buffer.append(char)
    tail = "".join(buffer).strip()
    if tail:
        parts.append(tail)
    return parts


def _iter_rule_blocks(source: str) -> list[tuple[str, str]]:
    blocks: list[tuple[str, str]] = []
    length = len(source)
    index = 0
    while index < length:
        while index < length and source[index].isspace():
            index += 1
        if index >= length:
            break
        selector_start = index
        while index < length and source[index] != "{":
            index += 1
        if index >= length:
            break
        selector = source[selector_start:index].strip()
        index += 1
        body_start = index
        depth = 1
        quote: str | None = None
        escape = False
        while index < length and depth > 0:
            char = source[index]
            if quote is not None:
                if escape:
                    escape = False
                elif char == "\\":
                    escape = True
                elif char == quote:
                    quote = None
                index += 1
                continue
            if char in {'"', "'"}:
                quote = char
                index += 1
                continue
            if char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
            index += 1
        if not selector:
            continue
        body = source[body_start : index - 1].strip()
        if body:
            blocks.append((selector, body))
    return blocks


def _parse_scalar(text: str) -> Any:
    lowered = text.lower()
    if lowered == "true":
        return True
    if lowered == "false":
        return False
    if lowered in {"null", "none"}:
        return None
    if _NUMBER_RE.match(text):
        return float(text) if "." in text else int(text)
    return text


def _parse_value(name: str, raw: str) -> Any:
    text = raw.strip()
    if not text:
        return ""
    if (text.startswith('"') and text.endswith('"')) or (
        text.startswith("'") and text.endswith("'")
    ):
        return text[1:-1]
    if text.startswith("{") or text.startswith("["):
        for loader in (json.loads, ast.literal_eval):
            try:
                return loader(text)
            except Exception:
                continue
    if name in _LIST_VALUE_KEYS and "," in text:
        return [_parse_scalar(part.strip()) for part in _split_top_level(text, ",")]
    return _parse_scalar(text)


@dataclass(frozen=True, slots=True)
class StyleSelector:
    """Single selector used by the ButterflyUI stylesheet engine."""

    raw: str
    """
    Original selector text exactly as authored in the stylesheet.
    """

    control_type: str | None = None
    """
    Normalized control type selector such as ``button`` or ``container``.
    """

    element_id: str | None = None
    """
    Optional ``#id`` selector target.
    """

    classes: tuple[str, ...] = ()
    """
    Normalized ``.class`` selector tokens attached to the selector.
    """

    state: str | None = None
    """
    Optional pseudo-state such as ``hover`` or ``pressed``.
    """

    breakpoint: str | None = None
    """
    Optional responsive breakpoint prefix such as ``md`` or ``lg``.
    """

    @classmethod
    def parse(cls, selector: str) -> "StyleSelector":
        raw = selector.strip()
        if not raw:
            raise ValueError("selector cannot be empty")

        main = raw
        breakpoint: str | None = None
        if raw.startswith("@"):
            match = re.match(r"^@([A-Za-z0-9_]+)\s+(.*)$", raw)
            if match:
                breakpoint = _norm(match.group(1))
                main = match.group(2).strip()
        state: str | None = None
        if ":" in main:
            main, state_part = main.split(":", 1)
            state = _norm(state_part)

        control_type: str | None = None
        element_id: str | None = None
        classes: list[str] = []

        for match in _TOKEN_RE.finditer(main.strip()):
            token = match.group(0)
            if token == "*":
                continue
            if token.startswith("#"):
                element_id = token[1:]
                continue
            if token.startswith("."):
                normalized = _norm(token[1:])
                if normalized and normalized not in classes:
                    classes.append(normalized)
                continue
            control_type = _norm(token)

        return cls(
            raw=raw,
            control_type=control_type,
            element_id=element_id,
            classes=tuple(classes),
            state=state,
            breakpoint=breakpoint,
        )

    def to_json(self) -> dict[str, Any]:
        return {
            "raw": self.raw,
            "type": self.control_type,
            "id": self.element_id,
            "classes": list(self.classes),
            "state": self.state,
            "breakpoint": self.breakpoint,
        }


@dataclass(frozen=True, slots=True)
class StyleRule:
    """Parsed stylesheet rule containing selectors and declarations."""

    selectors: tuple[StyleSelector, ...]
    """
    Selector list that can match one or more runtime controls.
    """

    declarations: dict[str, Any]
    """
    Normalized declaration mapping applied when a selector matches.
    """

    @classmethod
    def parse(cls, selector_text: str, body_text: str) -> "StyleRule":
        selectors = tuple(
            StyleSelector.parse(part)
            for part in _split_top_level(selector_text, ",")
            if part.strip()
        )
        if not selectors:
            raise ValueError("style rule must declare at least one selector")

        declarations: dict[str, Any] = {}
        for declaration in _split_top_level(body_text, ";"):
            if ":" not in declaration:
                continue
            name_raw, value_raw = declaration.split(":", 1)
            name = _PROPERTY_ALIASES.get(_norm(name_raw), _norm(name_raw))
            declarations[name] = _parse_value(name, value_raw)
        if not declarations:
            raise ValueError("style rule must declare at least one property")
        return cls(selectors=selectors, declarations=declarations)

    def to_json(self) -> dict[str, Any]:
        return {
            "selectors": [selector.to_json() for selector in self.selectors],
            "declarations": self.declarations,
        }


@dataclass(frozen=True, slots=True)
class StyleSheet:
    """Parsed ButterflyUI stylesheet ready for serialization to the runtime."""

    rules: tuple[StyleRule, ...]
    """
    Ordered stylesheet rules preserved in author-defined order.
    """

    @classmethod
    def parse(cls, source: str) -> "StyleSheet":
        text = _COMMENT_RE.sub("", source or "")
        rules: list[StyleRule] = []
        for selector_text, body_text in _iter_rule_blocks(text):
            if not selector_text or not body_text:
                continue
            rules.append(StyleRule.parse(selector_text, body_text))
        return cls(tuple(rules))

    def to_json(self) -> dict[str, Any]:
        return {"rules": [rule.to_json() for rule in self.rules]}


def parse_stylesheet(source: str) -> StyleSheet:
    return StyleSheet.parse(source)
