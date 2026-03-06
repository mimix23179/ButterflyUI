from __future__ import annotations

import ast
import json
import re
import textwrap
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any

CONTROL_API_DIR = Path(__file__).resolve().parent
SCRIPTS_DIR = CONTROL_API_DIR.parent
PACKAGE_ROOT = SCRIPTS_DIR.parent
CONTROL_ROOT = PACKAGE_ROOT / "src" / "butterflyui" / "controls"
ARTIFACT_ROOT = CONTROL_API_DIR / "artifacts"

WEAK_DOC_PATTERNS: dict[str, re.Pattern[str]] = {
    "alias_only": re.compile(r"^Alias for [`'\"]*`?([^`'.]+)`?[`'\"]*\.?$", re.I),
    "token_bucket": re.compile(r"^(?P<label>.+?) token bucket mapping\.$", re.I),
    "state_style": re.compile(r"^Style overrides applied (when|while) ", re.I),
    "generic_configuration": re.compile(r"^Configuration for ", re.I),
    "list_descriptors": re.compile(r"^List of .+ descriptors", re.I),
    "extra_forwarded_props": re.compile(r"^Extra properties forwarded ", re.I),
    "inline_style_overrides": re.compile(r"^Inline style overrides ", re.I),
    "strict_minimal": re.compile(r"^If ``True`` unknown property keys raise an error\.?$", re.I),
    "bool_minimal": re.compile(r"^If ``True`` .+\.$", re.I),
}

IGNORED_FIELD_NAMES = {
    "control_type",
    "_butterflyui_field_aliases",
    "_butterflyui_doc_only_fields",
}

STATE_STYLE_DOCS: dict[str, str] = {
    "base": (
        "Base style map applied in the idle state before any interactive or "
        "disabled overrides are merged."
    ),
    "hover": (
        "State-specific style map applied while the pointer hovers the control. "
        "Use it to override hover-time visual properties such as background, "
        "border, elevation, or text color."
    ),
    "pressed": (
        "State-specific style map applied while the control is actively pressed. "
        "Use it for press-time feedback such as scale, elevation, tint, or "
        "shadow changes."
    ),
    "disabled": (
        "State-specific style map applied when the control is disabled. Use it "
        "to tone down interactive styling or replace it with a non-interactive "
        "appearance."
    ),
}

GENERIC_FIELD_DOCS: dict[str, str] = {
    "events": (
        "List of runtime event names that should be emitted back to Python for "
        "this control instance."
    ),
    "props": (
        "Raw prop overrides merged into the payload sent to Flutter. Use this "
        "when the Python wrapper does not yet expose a runtime key as a "
        "first-class argument."
    ),
    "style": (
        "Local style map merged into the rendered control payload. Use it for "
        "per-instance styling without changing shared tokens, variants, or "
        "recipe classes."
    ),
    "strict": (
        "Enables strict validation for unsupported or unknown props when schema "
        "checks are available. This is useful while developing wrappers or "
        "debugging payload mismatches."
    ),
    "focus_ring": (
        "Focus-ring configuration applied when the control receives keyboard or "
        "accessibility focus. Typical values control ring color, width, inset, "
        "or animation depending on the renderer."
    ),
    "motion_behavior": (
        "Motion configuration used when transitioning between interaction "
        "states. Use it to tune duration, easing, and animation behavior for "
        "hover, press, focus, or selection changes."
    ),
}

COMMON_FIELD_DOCS: dict[str, str] = {
    "actions": (
        "Ordered list of action descriptors rendered or triggered by this "
        "control. Each entry should match the runtime payload shape expected "
        "for the control type."
    ),
    "active_index": (
        "Zero-based index of the currently active item, overlay, or page "
        "within the control."
    ),
    "align": (
        "Alignment configuration that positions the child or content within "
        "the available layout space."
    ),
    "aria_label": (
        "Accessibility label announced to assistive technologies when the "
        "control does not expose enough visible text on its own."
    ),
    "async_source": (
        "Async data source identifier or configuration used to fetch items "
        "for this control on demand."
    ),
    "avatar": (
        "Avatar source or descriptor rendered alongside the control's primary "
        "content."
    ),
    "avatars": (
        "Ordered list of avatar entries rendered by the stack. Each item can "
        "be a plain label string or a mapping with avatar metadata such as "
        "label, color, text color, and id."
    ),
    "badge": (
        "Badge value or descriptor rendered as a compact status marker near "
        "the control's main content."
    ),
    "brightness": (
        "Brightness mode associated with the scoped theme or token bundle, "
        "typically ``\"light\"`` or ``\"dark\"``."
    ),
    "base": (
        "Name of the base preset, theme, or style pack that this definition "
        "extends before local overrides are applied."
    ),
    "bgcolor": (
        "Background color painted behind the control's content area."
    ),
    "blur": (
        "Blur amount applied by the motion or effect step when this state is "
        "active."
    ),
    "border_color": (
        "Border color applied to the outer edge of the rendered control or "
        "decorative surface."
    ),
    "border_width": (
        "Border thickness used when rendering the outline around the control."
    ),
    "busy": (
        "Controls whether the control should render its busy or in-progress "
        "state instead of its idle presentation."
    ),
    "busy_label": (
        "Replacement label text shown while the control is in its busy state."
    ),
    "category": (
        "Category name or identifier used to group, filter, or preselect the "
        "control's current content."
    ),
    "char_limit": (
        "Maximum number of characters accepted or displayed by the control."
    ),
    "checked": (
        "Controls whether the control is currently in its checked or selected "
        "state."
    ),
    "child": (
        "Single child control or payload wrapped by this control."
    ),
    "children": (
        "Ordered list of child payloads nested inside this reusable component "
        "spec."
    ),
    "clear_on_send": (
        "Controls whether the current input value is cleared automatically "
        "after a send action completes."
    ),
    "color": (
        "Primary color value used by the control for text, icons, strokes, or "
        "accent surfaces."
    ),
    "colors": (
        "Mapping of named color tokens to the concrete color values used by "
        "the renderer."
    ),
    "columns": (
        "Number of columns used when the control lays out content in a grid."
    ),
    "components": (
        "Component-specific overrides or named component definitions bundled "
        "with this theme or style pack."
    ),
    "compact": (
        "Enables a more compact visual density with reduced padding, gaps, or "
        "surface size."
    ),
    "created_at": (
        "Creation timestamp associated with the item, typically serialized as "
        "an ISO-8601 string."
    ),
    "cross_axis_spacing": (
        "Spacing inserted between items on the grid or layout cross axis."
    ),
    "curve": (
        "Easing curve name or specification used for the motion transition."
    ),
    "data": (
        "Raw mapping payload stored by this helper type and forwarded to the "
        "runtime after JSON-safe normalization."
    ),
    "dense": (
        "Enables a denser layout with reduced gaps, padding, or row height."
    ),
    "description": (
        "Longer descriptive text rendered beneath or alongside the control's "
        "primary label."
    ),
    "divider_color": (
        "Color used when rendering the divider line or separator surface."
    ),
    "divider_label": (
        "Optional label text rendered inside or alongside the divider."
    ),
    "document_id": (
        "Identifier of the backing document, record, or content item shown by "
        "the control."
    ),
    "draft_key": (
        "Persistent key used to store and restore draft state for this control."
    ),
    "elevation": (
        "Mapping of named elevation tokens to reusable shadow, blur, or "
        "surface depth settings."
    ),
    "effects": (
        "Mapping of effect tokens or effect definitions bundled with this "
        "theme, pack, or control."
    ),
    "fill": (
        "Fill color or paint descriptor used when rendering the chart or "
        "visual surface."
    ),
    "focus": (
        "State-specific motion configuration applied while the control has "
        "keyboard or accessibility focus."
    ),
    "glow": (
        "Glow effect configuration merged into the rendered modifier payload."
    ),
    "glow_blur": (
        "Blur radius used when rendering the glow effect around the control."
    ),
    "glass": (
        "Glass-effect configuration applied by the modifier pipeline for this "
        "control."
    ),
    "height": (
        "Requested height of the control in logical pixels."
    ),
    "hit_test": (
        "Hit-test behavior that determines how this control participates in "
        "pointer targeting."
    ),
    "icon": (
        "Icon value or icon descriptor rendered by the control."
    ),
    "id": (
        "Stable identifier used to reference this item or control instance."
    ),
    "initials": (
        "Fallback initials rendered when an avatar or image source is not "
        "available."
    ),
    "is_loading": (
        "Reflects whether the item is currently loading and should render a "
        "placeholder or pending state."
    ),
    "is_selected": (
        "Reflects whether the item is currently selected in the rendered "
        "gallery or picker state."
    ),
    "label": (
        "Primary label text rendered by the control or its active action."
    ),
    "action_label": (
        "Label text rendered for the control's inline action when that action "
        "is available."
    ),
    "labels": (
        "Ordered list of label strings rendered by the control."
    ),
    "layout": (
        "Layout mode or layout identifier that controls how the control "
        "arranges its content."
    ),
    "like_count": (
        "Total number of likes associated with the item."
    ),
    "main_axis_spacing": (
        "Spacing inserted between items on the primary layout axis."
    ),
    "margin": (
        "Outer spacing applied around the control before neighboring layout "
        "items are positioned."
    ),
    "max": (
        "Maximum value, count, or visible item limit enforced by this control."
    ),
    "message": (
        "Main message text rendered inside the control."
    ),
    "metadata": (
        "Arbitrary metadata mapping associated with this item and forwarded to "
        "the runtime payload."
    ),
    "min": (
        "Minimum value accepted by the control."
    ),
    "module": (
        "Runtime module identifier that tells the umbrella control which "
        "Flutter-side implementation to render."
    ),
    "motion": (
        "Mapping of named motion tokens to reusable duration, easing, or "
        "transition specifications used by animated controls."
    ),
    "button": (
        "Mapping of named button style tokens to reusable button appearances "
        "consumed by recipes, variants, or control defaults."
    ),
    "card": (
        "Mapping of named card style tokens to reusable surface, border, and "
        "elevation settings for card-like components."
    ),
    "name": (
        "Human-readable name used to identify this item, style pack, or "
        "preset."
    ),
    "next_label": (
        "Label text rendered for the control's next-page or next-step action."
    ),
    "off_label": (
        "Label text shown when the control is in its off or disabled state."
    ),
    "on_focus_modifiers": (
        "Modifiers activated while the control or wrapped child currently has "
        "focus."
    ),
    "on_hover_modifiers": (
        "Modifiers activated while the pointer is hovering the control."
    ),
    "on_label": (
        "Label text shown when the control is in its on or enabled state."
    ),
    "opacity": (
        "Opacity value applied while this motion or visual state is active."
    ),
    "outline_color": (
        "Outline color rendered around the control independently of its main "
        "border."
    ),
    "overrides": (
        "Override mapping merged on top of the base theme, preset, or style "
        "definition."
    ),
    "owner": (
        "Single owner descriptor associated with the rendered record or item."
    ),
    "owners": (
        "Ordered collection of owner entries associated with the rendered "
        "record or item."
    ),
    "padding": (
        "Inner spacing applied between the control's border and its content."
    ),
    "page": (
        "Current page index or page number used by the paginator."
    ),
    "path": (
        "Filesystem path associated with the item or local resource."
    ),
    "placeholder": (
        "Placeholder text shown when the control has no current value."
    ),
    "play": (
        "Controls whether the effect or animation should currently be playing."
    ),
    "press": (
        "State-specific motion configuration applied while the control is "
        "actively pressed."
    ),
    "hover_motion": (
        "Motion played while the pointer hovers the control, such as lift, "
        "opacity, or highlight feedback."
    ),
    "press_motion": (
        "Motion played while the control is being pressed, such as scale, "
        "opacity, or elevation feedback."
    ),
    "angle": (
        "Angle value used by the effect, shadow, or shimmer renderer."
    ),
    "props": (
        "Raw prop overrides merged into the payload sent to Flutter. Use this "
        "when the Python wrapper does not yet expose a runtime key as a "
        "first-class argument."
    ),
    "query": (
        "Current query string used to filter, search, or narrow the control's "
        "content."
    ),
    "radii": (
        "Mapping of named radius tokens to reusable corner-radius values."
    ),
    "radius": (
        "Mapping of named radius tokens to reusable corner-radius values."
    ),
    "quote_author": (
        "Author label rendered for the quoted message or referenced content."
    ),
    "quote_compact": (
        "Controls whether the quoted content is rendered in its compact visual "
        "variant."
    ),
    "quote_text": (
        "Quoted text snippet rendered inside the message preview."
    ),
    "quote_timestamp": (
        "Timestamp label rendered for the quoted message or referenced "
        "content."
    ),
    "ranges": (
        "List of value ranges, highlight segments, or annotated spans "
        "rendered by the control."
    ),
    "read": (
        "Reflects whether the message or item has been marked as read."
    ),
    "read_only": (
        "Controls whether the control remains visible but blocks direct user "
        "editing."
    ),
    "reverse": (
        "Controls whether the control renders its items in reverse order."
    ),
    "route_id": (
        "Stable identifier used to reference this route within navigation "
        "state."
    ),
    "scale": (
        "Scale factor applied while the motion or effect state is active."
    ),
    "scrim_color": (
        "Color used for the modal scrim or backdrop behind the overlay."
    ),
    "scope_brightness": (
        "Brightness override applied when this reusable component instantiates "
        "inside its corresponding scope wrapper."
    ),
    "scope_skin": (
        "Skin preset name automatically applied when this reusable component "
        "creates a ``SkinsScope`` wrapper."
    ),
    "scope_theme": (
        "Theme mapping applied by the reusable component when it creates a "
        "scope wrapper for its children."
    ),
    "scope_tokens": (
        "Token overrides applied by the reusable component when it creates a "
        "scope wrapper for its children."
    ),
    "search_value": (
        "Current text value shown in the control's search input."
    ),
    "size": (
        "Requested icon, glyph, or control size in logical pixels or runtime "
        "size units."
    ),
    "selected_id": (
        "Identifier of the currently selected item, tab, route, or "
        "navigation destination."
    ),
    "selectable": (
        "Controls whether rows, items, or text content can be selected by the "
        "user."
    ),
    "send_label": (
        "Label text rendered for the send action associated with the control."
    ),
    "shadow_color": (
        "Color tint applied to the rendered shadow effect."
    ),
    "shimmer": (
        "Shimmer animation configuration or strength used by the shadow "
        "effect."
    ),
    "show_attach": (
        "Controls whether the control should display its attachment action or "
        "attachment slot."
    ),
    "sort_ascending": (
        "Controls whether the active sort uses ascending order instead of "
        "descending order."
    ),
    "sort_column": (
        "Identifier of the column currently used to sort the control's data."
    ),
    "spacing": (
        "Base spacing value used between items or structural regions inside "
        "the control."
    ),
    "src": (
        "Source URI, file path, or asset reference rendered by the control."
    ),
    "state": (
        "Current state token or state identifier forwarded into styling and "
        "runtime behavior."
    ),
    "status": (
        "Status label or status identifier associated with the rendered item."
    ),
    "strokes": (
        "Ordered list of stroke descriptors rendered by the canvas surface."
    ),
    "stroke_width": (
        "Thickness of the rendered stroke in logical pixels."
    ),
    "style_tokens": (
        "Named style-token overrides scoped to the wrapped subtree."
    ),
    "subtitle": (
        "Secondary text rendered beneath or beside the primary title."
    ),
    "tags": (
        "List of tag labels associated with the rendered item or record."
    ),
    "text": (
        "Primary text value rendered by the control."
    ),
    "thumbnail_url": (
        "Preview image URL used when rendering a thumbnail for the item."
    ),
    "title": (
        "Primary heading text rendered by the control."
    ),
    "timestamp": (
        "Timestamp string rendered with the message or item metadata."
    ),
    "tokens": (
        "Token mapping or token helper object that provides reusable design "
        "values to this definition."
    ),
    "tooltip": (
        "Tooltip text shown when the user hovers or long-presses the control."
    ),
    "trailing": (
        "Trailing content or descriptor rendered after the control's primary "
        "body."
    ),
    "type": (
        "Type identifier that tells the runtime what kind of item or content "
        "this payload represents."
    ),
    "typography": (
        "Mapping of named typography tokens to reusable text-style values such "
        "as size, weight, family, and line height."
    ),
    "ui": (
        "Mapping of shared UI tokens used across general-purpose controls, "
        "surfaces, and layout primitives."
    ),
    "url": (
        "Remote or local URL used to load the item's content."
    ),
    "value": (
        "Current value rendered or edited by the control. The exact payload "
        "shape depends on the control type."
    ),
    "variant": (
        "Variant token or preset name used to select a specific visual style."
    ),
    "view_count": (
        "Total number of views associated with the item."
    ),
    "webview": (
        "Mapping of webview-specific tokens or settings forwarded to the "
        "runtime."
    ),
    "width": (
        "Requested width of the control in logical pixels."
    ),
    "x": (
        "Horizontal offset applied by the active motion or effect state."
    ),
    "y": (
        "Vertical offset applied by the active motion or effect state."
    ),
}

BOOL_FIELD_HINTS: dict[str, str] = {
    "autoplay": (
        "Controls whether playback starts automatically as soon as the media is "
        "ready. Leave it disabled when playback should begin only after an "
        "explicit user action."
    ),
    "loop": (
        "Controls whether playback restarts automatically after the media "
        "reaches the end of the stream."
    ),
    "muted": (
        "Controls whether audio starts muted. The media can still render "
        "visually while sound remains off until changed by the runtime or user."
    ),
    "controls": (
        "Controls whether the platform's native playback controls are shown, "
        "such as play/pause, seek, volume, or fullscreen actions when "
        "available."
    ),
    "open": (
        "Controls whether the overlay or transient surface is currently visible "
        "to the user."
    ),
    "dismissible": (
        "Controls whether the overlay can be closed by outside interaction "
        "instead of requiring an explicit close action."
    ),
    "disabled": (
        "Controls whether the control is disabled and rendered without "
        "accepting user interaction."
    ),
    "enabled": (
        "Controls whether the user can interact with the control. Disable it to "
        "show the control without allowing input or activation."
    ),
    "loading": (
        "Controls whether the control should render its loading state instead of "
        "the normal idle state."
    ),
    "scrollable": (
        "Controls whether overflowing content is wrapped in a scrollable host "
        "instead of being laid out at its full intrinsic size."
    ),
    "selectable": (
        "Controls whether rendered text content can be selected and copied by "
        "the user."
    ),
    "interactive": (
        "Controls whether hover, press, focus, or other interaction tracking is "
        "enabled for this control."
    ),
}

TOKEN_BUCKET_TEMPLATES: dict[str, str] = {
    "radius": (
        "Mapping of named radius tokens to the concrete corner-radius values "
        "used by the renderer. Use this bucket to centralize reusable radius "
        "tokens for themes, recipes, or component defaults."
    ),
    "colors": (
        "Mapping of named color tokens to the concrete color values used by the "
        "renderer. Use this bucket to centralize reusable semantic or brand "
        "colors."
    ),
    "typography": (
        "Mapping of named typography tokens to reusable text-style values such "
        "as size, weight, family, or line-height settings."
    ),
    "spacing": (
        "Mapping of named spacing tokens to the gap, padding, or margin values "
        "consumed by the renderer."
    ),
    "elevation": (
        "Mapping of named elevation tokens to reusable shadow, blur, or surface "
        "depth settings."
    ),
    "motion": (
        "Mapping of named motion tokens to reusable duration, easing, or "
        "transition specifications used by animated controls."
    ),
    "button": (
        "Mapping of named button style tokens to reusable button appearances "
        "consumed by recipes, variants, or control defaults."
    ),
    "card": (
        "Mapping of named card style tokens to reusable surface, border, and "
        "elevation settings for card-like components."
    ),
    "ui": (
        "Mapping of shared UI tokens used across general-purpose controls, "
        "surfaces, and layout primitives."
    ),
}

CLASS_FIELD_DOCS: dict[tuple[str, str], str] = {
    (
        "CandyStylePack",
        "background",
    ): (
        "Background value or surface descriptor applied by the style pack when "
        "it defines a global page or shell backdrop."
    ),
    (
        "CandyComponentSpec",
        "scope_brightness",
    ): (
        "Brightness override applied when this component spec wraps the "
        "instantiated control in a ``CandyScope``."
    ),
    (
        "CandyComponentSpec",
        "scope_theme",
    ): (
        "Theme mapping injected into the generated ``CandyScope`` when this "
        "component spec is instantiated with scope wrapping enabled."
    ),
    (
        "GalleryItem",
        "aspect_ratio",
    ): (
        "Preferred aspect ratio used when sizing the item's media preview."
    ),
    (
        "Display",
        "checked",
    ): (
        "List of checked item identifiers or payloads used by the display role "
        "when it renders multi-check or selection state."
    ),
    (
        "GalleryItem",
        "author_avatar",
    ): (
        "Avatar image URL rendered for the item's author or owner metadata."
    ),
    (
        "GalleryItem",
        "author_name",
    ): (
        "Display name of the author or owner associated with the item."
    ),
    (
        "SkinsComponentSpec",
        "scope_brightness",
    ): (
        "Brightness override applied when this component spec wraps the "
        "instantiated control in a ``SkinsScope``."
    ),
    (
        "SkinsComponentSpec",
        "scope_skin",
    ): (
        "Name of the skin preset automatically applied when this component "
        "spec instantiates inside a ``SkinsScope``."
    ),
    (
        "SkinsComponentSpec",
        "scope_tokens",
    ): (
        "Token overrides injected into the generated ``SkinsScope`` when this "
        "component spec is instantiated."
    ),
}


@dataclass(slots=True)
class FieldRecord:
    name: str
    annotation: str
    default: str | None
    doc: str
    annassign_lineno: int
    annassign_end_lineno: int
    doc_lineno: int | None = None
    doc_end_lineno: int | None = None


@dataclass(slots=True)
class ClassRecord:
    path: Path
    rel_path: str
    module_source: str
    name: str
    bases: list[str]
    control_type: str | None
    class_doc: str
    class_doc_lineno: int | None
    class_doc_end_lineno: int | None
    fields: list[FieldRecord] = field(default_factory=list)
    args_order: list[str] = field(default_factory=list)
    args_docs: dict[str, str] = field(default_factory=dict)
    methods: list[str] = field(default_factory=list)
    has_init: bool = False
    init_params: list[str] = field(default_factory=list)
    init_category: str = "none"
    constructor_style: str = "none"
    field_aliases: dict[str, str] = field(default_factory=dict)
    doc_only_fields: list[str] = field(default_factory=list)
    weak_field_docs: dict[str, list[str]] = field(default_factory=dict)
    weak_args_docs: dict[str, list[str]] = field(default_factory=dict)


def ensure_artifact_root() -> Path:
    ARTIFACT_ROOT.mkdir(parents=True, exist_ok=True)
    return ARTIFACT_ROOT


def iter_control_files() -> list[Path]:
    return sorted(path for path in CONTROL_ROOT.rglob("*.py") if path.name != "__init__.py")


def read_source(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def write_source(path: Path, source: str) -> None:
    path.write_text(source, encoding="utf-8")


def line_start_offsets(source: str) -> list[int]:
    starts = [0]
    for line in source.splitlines(keepends=True):
        starts.append(starts[-1] + len(line))
    return starts


def to_offset(starts: list[int], lineno: int, col: int) -> int:
    return starts[lineno - 1] + col


def get_source_segment(source: str, node: ast.AST | None) -> str:
    if node is None:
        return ""
    segment = ast.get_source_segment(source, node)
    return segment or ""


def parse_args_section(doc: str) -> tuple[list[str], dict[str, str]]:
    lines = doc.splitlines()
    args: dict[str, list[str]] = {}
    order: list[str] = []
    current: str | None = None
    in_args = False
    header_indent: int | None = None

    for raw in lines:
        if raw.strip() == "Args:":
            in_args = True
            current = None
            header_indent = None
            continue
        if not in_args:
            continue
        stripped = raw.strip()
        if not stripped:
            if current is not None and args[current] and args[current][-1] != "":
                args[current].append("")
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        if header_indent is None:
            if indent == 0:
                break
            header_indent = indent
        if indent < header_indent:
            break
        if indent == header_indent and stripped.endswith(":"):
            current = stripped[:-1]
            if current not in order:
                order.append(current)
            args[current] = []
            continue
        if current is None:
            continue
        description_indent = header_indent + 4
        text = raw[description_indent:] if indent >= description_indent else stripped
        args[current].append(text.rstrip())

    normalized: dict[str, str] = {}
    for name, doc_lines in args.items():
        while doc_lines and not doc_lines[-1]:
            doc_lines.pop()
        normalized[name] = "\n".join(doc_lines).strip()
    return order, normalized


def replace_args_section(doc: str, replacements: dict[str, str]) -> str:
    lines = doc.splitlines()
    args_index = next((idx for idx, line in enumerate(lines) if line.strip() == "Args:"), None)
    if args_index is None:
        return doc

    order, docs = parse_args_section(doc)
    if not order:
        return doc

    suffix_start = len(lines)
    header_indent: int | None = None
    for idx in range(args_index + 1, len(lines)):
        raw = lines[idx]
        stripped = raw.strip()
        if not stripped:
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        if header_indent is None:
            if indent == 0:
                suffix_start = idx
                break
            header_indent = indent
            continue
        if indent < header_indent:
            suffix_start = idx
            break

    new_lines = lines[:args_index]
    new_lines.append("Args:")
    for name in order:
        arg_doc = replacements.get(name, docs.get(name, "")).strip()
        new_lines.append(f"    {name}:")
        if arg_doc:
            for entry in arg_doc.splitlines():
                new_lines.append(f"        {entry}" if entry else "")
        else:
            new_lines.append("        ")
    new_lines.extend(lines[suffix_start:])
    return "\n".join(new_lines)


def render_doc_block(doc: str, *, indent: int = 4) -> str:
    prefix = " " * indent
    lines = doc.splitlines() or [""]
    rendered = [f'{prefix}"""']
    for line in lines:
        rendered.append(f"{prefix}{line}" if line else prefix)
    rendered.append(f'{prefix}"""')
    return "\n".join(rendered)


def render_class_docstring(doc: str, *, indent: int = 4) -> str:
    prefix = " " * indent
    lines = doc.splitlines() or [""]
    rendered = [f'{prefix}"""{lines[0] if lines else ""}']
    for line in lines[1:]:
        rendered.append(f"{prefix}{line}" if line else prefix)
    rendered.append(f'{prefix}"""')
    return "\n".join(rendered)


def replace_line_block(source: str, start_line: int, end_line: int, replacement: str) -> str:
    lines = source.splitlines()
    new_lines = lines[: start_line - 1] + replacement.splitlines() + lines[end_line:]
    return "\n".join(new_lines) + ("\n" if source.endswith("\n") else "")


def replace_source_span(
    source: str,
    *,
    start_line: int,
    start_col: int,
    end_line: int,
    end_col: int,
    replacement: str,
) -> str:
    starts = line_start_offsets(source)
    start = to_offset(starts, start_line, start_col)
    end = to_offset(starts, end_line, end_col)
    return source[:start] + replacement + source[end:]


def parse_literal_assignment(node: ast.Assign) -> Any:
    try:
        return ast.literal_eval(node.value)
    except Exception:
        return None


def extract_fields(class_node: ast.ClassDef, source: str) -> list[FieldRecord]:
    fields: list[FieldRecord] = []
    body = class_node.body
    for index, node in enumerate(body):
        if not isinstance(node, ast.AnnAssign) or not isinstance(node.target, ast.Name):
            continue
        name = node.target.id
        if name in IGNORED_FIELD_NAMES:
            continue
        annotation = ast.unparse(node.annotation) if node.annotation is not None else "Any"
        default = ast.unparse(node.value) if node.value is not None else None
        doc = ""
        doc_lineno: int | None = None
        doc_end_lineno: int | None = None
        if index + 1 < len(body):
            follower = body[index + 1]
            if (
                isinstance(follower, ast.Expr)
                and isinstance(follower.value, ast.Constant)
                and isinstance(follower.value.value, str)
            ):
                doc = follower.value.value.strip()
                doc_lineno = follower.lineno
                doc_end_lineno = follower.end_lineno
        fields.append(
            FieldRecord(
                name=name,
                annotation=annotation,
                default=default,
                doc=doc,
                annassign_lineno=node.lineno,
                annassign_end_lineno=node.end_lineno,
                doc_lineno=doc_lineno,
                doc_end_lineno=doc_end_lineno,
            )
        )
    return fields


def extract_control_type(class_node: ast.ClassDef) -> str | None:
    for node in class_node.body:
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == "control_type":
                    try:
                        value = ast.literal_eval(node.value)
                    except Exception:
                        return None
                    return value if isinstance(value, str) else None
    return None


def extract_metadata_literals(class_node: ast.ClassDef) -> tuple[dict[str, str], list[str]]:
    aliases: dict[str, str] = {}
    doc_only_fields: list[str] = []
    for node in class_node.body:
        if not isinstance(node, ast.Assign):
            continue
        targets = [target.id for target in node.targets if isinstance(target, ast.Name)]
        if "_butterflyui_field_aliases" in targets:
            value = parse_literal_assignment(node)
            if isinstance(value, dict):
                aliases = {str(key): str(val) for key, val in value.items()}
        if "_butterflyui_doc_only_fields" in targets:
            value = parse_literal_assignment(node)
            if isinstance(value, (list, tuple, set, frozenset)):
                doc_only_fields = [str(item) for item in value]
    return aliases, sorted(doc_only_fields)


def get_init_node(class_node: ast.ClassDef) -> ast.FunctionDef | None:
    for node in class_node.body:
        if isinstance(node, ast.FunctionDef) and node.name == "__init__":
            return node
    return None


def list_methods(class_node: ast.ClassDef) -> list[str]:
    return [
        node.name
        for node in class_node.body
        if isinstance(node, ast.FunctionDef) and node.name != "__init__"
    ]


def collect_init_params(init_node: ast.FunctionDef | None) -> list[str]:
    if init_node is None:
        return []
    params: list[str] = []
    for arg in init_node.args.args:
        params.append(arg.arg)
    if init_node.args.vararg is not None:
        params.append(f"*{init_node.args.vararg.arg}")
    for arg in init_node.args.kwonlyargs:
        params.append(arg.arg)
    if init_node.args.kwarg is not None:
        params.append(f"**{init_node.args.kwarg.arg}")
    return params


def collect_super_call(init_node: ast.FunctionDef) -> ast.Call | None:
    for node in ast.walk(init_node):
        if not isinstance(node, ast.Call):
            continue
        if isinstance(node.func, ast.Attribute) and node.func.attr == "__init__":
            receiver = node.func.value
            if isinstance(receiver, ast.Call) and isinstance(receiver.func, ast.Name):
                if receiver.func.id == "super":
                    return node
    return None


def constructor_style(init_node: ast.FunctionDef | None, source: str) -> str:
    if init_node is None:
        return "none"
    segment = get_source_segment(source, init_node)
    if "merged = merge_props(" in segment and "props=merged" in segment:
        return "canonical_merge"
    if "props=merge_props(" in segment:
        return "inline_merge"
    super_call = collect_super_call(init_node)
    if super_call is not None:
        prop_keywords = {
            keyword.arg
            for keyword in super_call.keywords
            if keyword.arg is not None
        }
        if prop_keywords - {"props", "style", "strict", "child", "children"}:
            return "delegating_wrapper"
        return "manual_super"
    return "manual_exception"


def classify_init_category(init_node: ast.FunctionDef | None, source: str) -> str:
    if init_node is None:
        return "none"

    text = get_source_segment(source, init_node)
    if "raise " in text or "assert " in text:
        return "validation_only"
    if any(
        isinstance(node, ast.Call)
        and isinstance(node.func, ast.Attribute)
        and node.func.attr.startswith("_compose")
        for node in ast.walk(init_node)
    ):
        return "child_composition"
    if any(
        isinstance(node, ast.Assign)
        and any(isinstance(target, ast.Attribute) for target in node.targets)
        for node in init_node.body
    ):
        return "imperative_setup"

    style = constructor_style(init_node, source)
    if style == "canonical_merge":
        segment = get_source_segment(source, init_node)
        if "dict(" in segment or "list(" in segment or " if " in segment:
            if "resolved_" in segment or "alias" in segment:
                return "alias_resolution"
            return "coercion_normalization"
        return "pure_passthrough"
    if style == "inline_merge":
        return "pure_passthrough"
    if style == "delegating_wrapper":
        return "alias_resolution"
    return "exceptional_manual"


def weak_doc_reasons(doc: str, field_name: str) -> list[str]:
    text = " ".join(doc.split()).strip()
    reasons: list[str] = []
    if not text:
        return reasons
    for reason, pattern in WEAK_DOC_PATTERNS.items():
        if pattern.search(text):
            reasons.append(reason)
    if text.startswith("If ``True`` ") and field_name in BOOL_FIELD_HINTS and "bool_minimal" not in reasons:
        reasons.append("bool_minimal")
    if len(text) < 32:
        reasons.append("too_short")
    return sorted(set(reasons))


def rewrite_bool_doc(field_name: str, doc: str) -> str | None:
    hint = BOOL_FIELD_HINTS.get(field_name)
    if hint is not None:
        return hint
    text = " ".join(doc.split()).strip()
    if text.startswith("If ``True`` "):
        clause = text[len("If ``True`` ") :].rstrip(".")
        if clause:
            clause = clause[0].lower() + clause[1:]
            return f"Controls whether {clause}. Set it to ``False`` to disable this behavior."
    return None


def synthesize_field_doc(field_name: str, class_name: str, annotation: str) -> str | None:
    specific = CLASS_FIELD_DOCS.get((class_name, field_name))
    if specific is not None:
        return specific

    suffix_templates = {
        "_color": (
            "Color value applied to {label} when the control renders that "
            "visual element."
        ),
        "_label": (
            "Label text rendered for {label} when that action or slot is "
            "shown."
        ),
        "_count": "Count value associated with {label}.",
        "_id": "Stable identifier used for {label}.",
        "_url": "URL used to load or preview {label}.",
    }
    for suffix, template in suffix_templates.items():
        if field_name.endswith(suffix):
            label = field_name[: -len(suffix)].replace("_", " ")
            return template.format(label=label or "the field")

    normalized_annotation = annotation.replace(" ", "")
    if "bool" in normalized_annotation.lower():
        hint = BOOL_FIELD_HINTS.get(field_name)
        if hint is not None:
            return hint
        label = field_name.replace("_", " ")
        return f"Controls whether {label} is enabled for this control."

    if field_name in STATE_STYLE_DOCS:
        return STATE_STYLE_DOCS[field_name]
    if field_name in GENERIC_FIELD_DOCS:
        return GENERIC_FIELD_DOCS[field_name]
    if field_name in COMMON_FIELD_DOCS:
        return COMMON_FIELD_DOCS[field_name]

    if field_name.startswith("show_"):
        label = field_name[5:].replace("_", " ")
        return f"Controls whether {label} is shown as part of the rendered control."
    if field_name.startswith("is_"):
        label = field_name[3:].replace("_", " ")
        return f"Reflects whether the item is currently {label}."

    if any(token in normalized_annotation for token in ("list[", "Iterable[")):
        label = field_name.replace("_", " ")
        return f"Ordered list of {label} values used by this control."
    if any(token in normalized_annotation for token in ("dict[", "Mapping[")):
        label = field_name.replace("_", " ")
        return f"Mapping of {label} values forwarded to the runtime payload."

    return None


def rewrite_doc_text(
    field_name: str,
    current_doc: str,
    class_name: str,
    annotation: str = "",
) -> str | None:
    text = " ".join(current_doc.split()).strip()
    specific_doc = CLASS_FIELD_DOCS.get((class_name, field_name))
    if specific_doc is not None and text and text != specific_doc:
        generic_fallbacks = {
            COMMON_FIELD_DOCS.get(field_name),
            BOOL_FIELD_HINTS.get(field_name),
            STATE_STYLE_DOCS.get(field_name),
            GENERIC_FIELD_DOCS.get(field_name),
        }
        if text in {entry for entry in generic_fallbacks if entry is not None}:
            return specific_doc
    if not text:
        return synthesize_field_doc(field_name, class_name, annotation)

    normalized_annotation = annotation.replace(" ", "").lower()
    if (
        field_name in STATE_STYLE_DOCS
        and "bool" in normalized_annotation
        and text == STATE_STYLE_DOCS[field_name]
    ):
        synthesized = synthesize_field_doc(field_name, class_name, annotation)
        if synthesized is not None and synthesized != text:
            return synthesized

    alias_match = WEAK_DOC_PATTERNS["alias_only"].match(text)
    if alias_match:
        target = alias_match.group(1).strip()
        return (
            f"Backward-compatible alias for ``{target}``. When both fields are "
            f"provided, ``{target}`` takes precedence and this alias is kept "
            f"only for compatibility."
        )

    token_match = WEAK_DOC_PATTERNS["token_bucket"].match(text)
    if token_match:
        label = token_match.group("label").strip().lower()
        return TOKEN_BUCKET_TEMPLATES.get(
            label,
            (
                f"Mapping of named {label} tokens to the concrete values used by "
                f"the renderer. Use this bucket to centralize reusable "
                f"{label}-related settings."
            ),
        )

    if field_name in STATE_STYLE_DOCS and (
        "state_style" in weak_doc_reasons(current_doc, field_name)
        or (
            field_name in {"hover", "pressed", "disabled", "base"}
            and any(token in normalized_annotation for token in ("mapping[", "dict["))
        )
    ):
        return STATE_STYLE_DOCS[field_name]

    if field_name in GENERIC_FIELD_DOCS and weak_doc_reasons(current_doc, field_name):
        return GENERIC_FIELD_DOCS[field_name]

    if field_name == "items" and "descriptor" not in text.lower():
        return (
            "Ordered list of items rendered by the control. Each entry may be "
            "a strongly typed helper instance or a raw mapping matching the "
            "runtime payload shape."
        )

    if field_name == "options" and WEAK_DOC_PATTERNS["list_descriptors"].search(text):
        return (
            "Ordered list of option descriptors rendered by the control. Each "
            "item can be a primitive shortcut or a mapping with the keys the "
            "Flutter side expects for this control."
        )

    if field_name == "actions" and WEAK_DOC_PATTERNS["list_descriptors"].search(text):
        return (
            "Ordered list of action descriptors executed or rendered by this "
            "control. Each item should match the action shape expected by the "
            "runtime for this control type."
        )

    if field_name in {"hover", "pressed", "disabled"}:
        return STATE_STYLE_DOCS[field_name]

    if field_name in {"props", "style", "strict", "events", "focus_ring", "motion_behavior"}:
        return GENERIC_FIELD_DOCS[field_name]

    bool_rewrite = rewrite_bool_doc(field_name, current_doc)
    if bool_rewrite is not None and "bool_minimal" in weak_doc_reasons(current_doc, field_name):
        return bool_rewrite

    if WEAK_DOC_PATTERNS["extra_forwarded_props"].search(text):
        return GENERIC_FIELD_DOCS["props"]
    if WEAK_DOC_PATTERNS["inline_style_overrides"].search(text):
        return GENERIC_FIELD_DOCS["style"]
    if WEAK_DOC_PATTERNS["strict_minimal"].search(text):
        return GENERIC_FIELD_DOCS["strict"]
    if WEAK_DOC_PATTERNS["generic_configuration"].search(text) and field_name in GENERIC_FIELD_DOCS:
        return GENERIC_FIELD_DOCS[field_name]

    reasons = weak_doc_reasons(current_doc, field_name)
    if "list_descriptors" in reasons or "too_short" in reasons:
        synthesized = synthesize_field_doc(field_name, class_name, annotation)
        if synthesized is not None and synthesized != text:
            return synthesized

    return None


def load_control_records() -> list[ClassRecord]:
    records: list[ClassRecord] = []
    for path in iter_control_files():
        source = read_source(path)
        tree = ast.parse(source)
        rel_path = path.relative_to(CONTROL_ROOT).as_posix()
        for class_node in tree.body:
            if not isinstance(class_node, ast.ClassDef):
                continue
            class_doc = ast.get_docstring(class_node) or ""
            doc_node = class_node.body[0] if class_node.body else None
            class_doc_lineno: int | None = None
            class_doc_end_lineno: int | None = None
            if (
                isinstance(doc_node, ast.Expr)
                and isinstance(doc_node.value, ast.Constant)
                and isinstance(doc_node.value.value, str)
            ):
                class_doc_lineno = doc_node.lineno
                class_doc_end_lineno = doc_node.end_lineno

            fields = extract_fields(class_node, source)
            args_order, args_docs = parse_args_section(class_doc)
            init_node = get_init_node(class_node)
            field_aliases, doc_only_fields = extract_metadata_literals(class_node)
            record = ClassRecord(
                path=path,
                rel_path=rel_path,
                module_source=source,
                name=class_node.name,
                bases=[ast.unparse(base) for base in class_node.bases],
                control_type=extract_control_type(class_node),
                class_doc=class_doc,
                class_doc_lineno=class_doc_lineno,
                class_doc_end_lineno=class_doc_end_lineno,
                fields=fields,
                args_order=args_order,
                args_docs=args_docs,
                methods=list_methods(class_node),
                has_init=init_node is not None,
                init_params=collect_init_params(init_node),
                init_category=classify_init_category(init_node, source),
                constructor_style=constructor_style(init_node, source),
                field_aliases=field_aliases,
                doc_only_fields=doc_only_fields,
            )
            for field_record in fields:
                reasons = weak_doc_reasons(field_record.doc, field_record.name)
                if reasons:
                    record.weak_field_docs[field_record.name] = reasons
            for arg_name, arg_doc in args_docs.items():
                reasons = weak_doc_reasons(arg_doc, arg_name)
                if reasons:
                    record.weak_args_docs[arg_name] = reasons
            records.append(record)
    return records


def control_records_as_json(records: list[ClassRecord]) -> list[dict[str, Any]]:
    payload: list[dict[str, Any]] = []
    for record in records:
        data = asdict(record)
        data["path"] = str(record.path)
        payload.append(data)
    return payload


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True), encoding="utf-8")


def write_markdown(path: Path, text: str) -> None:
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def summarize_counts(records: list[ClassRecord], *, attr: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for record in records:
        key = str(getattr(record, attr))
        counts[key] = counts.get(key, 0) + 1
    return dict(sorted(counts.items(), key=lambda item: (-item[1], item[0])))


def source_indent_for_line(source: str, lineno: int) -> str:
    line = source.splitlines()[lineno - 1]
    return line[: len(line) - len(line.lstrip(" "))]


def format_merge_assignment(merge_segment: str, *, indent: str) -> str:
    dedented = textwrap.dedent(merge_segment).rstrip()
    lines = dedented.splitlines()
    if not lines:
        return f"{indent}merged = merge_props()"
    formatted = [f"{indent}merged = {lines[0].lstrip()}"]
    formatted.extend(f"{indent}{line}" if line else indent for line in lines[1:])
    return "\n".join(formatted)
