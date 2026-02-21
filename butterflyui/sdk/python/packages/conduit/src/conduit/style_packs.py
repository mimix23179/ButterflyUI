from __future__ import annotations

__all__ = [
    "STYLE_PACKS",
    "DEFAULT_STYLE_PACK",
    "list_style_packs",
    "register_style_pack",
    "list_custom_style_packs",
]


# Mirrors the Dart runtime style packs in `style_packs.dart`.
STYLE_PACKS: tuple[str, ...] = (
    "base",
    "terminal",
    "windsurf",
    "retro",
    "scifi",
    "comfy",
    "noir",
    "minimal",
    "glass",
    "solarized",
    "vapor",
    "neon",
)

DEFAULT_STYLE_PACK = "base"

CUSTOM_STYLE_PACKS: dict[str, dict[str, object]] = {}


def _normalize(name: str) -> str:
    return name.strip().lower().replace(" ", "_")


def list_custom_style_packs() -> list[str]:
    return list(CUSTOM_STYLE_PACKS.keys())


def list_style_packs() -> list[str]:
    names = list(STYLE_PACKS)
    for name in CUSTOM_STYLE_PACKS.keys():
        if name not in names:
            names.append(name)
    return names


def _coerce_tokens(tokens: object | None) -> dict[str, object] | None:
    if tokens is None:
        return None
    if hasattr(tokens, "to_json"):
        try:
            payload = tokens.to_json()
            if isinstance(payload, dict):
                return dict(payload)
        except Exception:
            return None
    if isinstance(tokens, dict):
        return dict(tokens)
    return None


def register_style_pack(
    name: str,
    *,
    tokens: object | None = None,
    base: str | None = None,
    background: object | None = None,
    overrides: dict[str, object] | None = None,
    components: dict[str, object] | None = None,
    motion: dict[str, object] | None = None,
    effects: dict[str, object] | None = None,
) -> dict[str, object]:
    """Register a custom style pack spec for the runtime."""
    normalized = _normalize(name)
    spec: dict[str, object] = {"name": normalized}
    token_payload = _coerce_tokens(tokens)
    if token_payload is not None:
        spec["tokens"] = token_payload
    if base:
        spec["base"] = str(base)
    if background is not None:
        spec["background"] = background
    if overrides:
        spec["overrides"] = dict(overrides)
    if components:
        spec["components"] = dict(components)
    if motion:
        spec["motion"] = dict(motion)
    if effects:
        spec["effects"] = dict(effects)
    CUSTOM_STYLE_PACKS[normalized] = spec
    return spec
