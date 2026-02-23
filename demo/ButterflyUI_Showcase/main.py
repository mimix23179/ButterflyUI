from __future__ import annotations

from typing import Any

import butterflyui as ui
from butterflyui.controls import (
    Align,
    ArtifactCard,
    AsyncActionButton,
    AttachmentTile,
    Audio,
    BarPlot,
    Box,
    BottomSheet,
    BoundsProbe,
    BrushPanel,
    Canvas,
    Card,
    Column,
    DataGrid,
    Divider,
    Expanded,
    ParticleField,
    PromptComposer,
    Row,
    ScanlineOverlay,
    ScrollView,
    Skeleton,
    SkeletonLoader,
    Stack,
    Surface,
    Text,
    Vignette,
    Wrap,
)


def _feature_chip(label: str) -> Box:
    return Box(
        Text(label, size=12, color="#cbd5e1"),
        padding=[6, 10],
        radius=999,
        bgcolor="#1f2937",
        margin=[0, 0, 6, 0],
    )


def _effect_preview() -> Card:
    scene = Box(
        Vignette(
            ScanlineOverlay(
                Stack(
                    Box(bgcolor="#0b1020", radius=14),
                    ParticleField(
                        count=80,
                        min_size=1.2,
                        max_size=4.2,
                        min_speed=10,
                        max_speed=34,
                        opacity=0.65,
                        colors=["#22d3ee", "#a78bfa", "#38bdf8", "#f472b6"],
                        play=True,
                        seed=42,
                    ),
                ),
                spacing=5,
                thickness=1,
                opacity=0.13,
                color="#ffffff",
                enabled=True,
            ),
            intensity=0.55,
            opacity=0.52,
            color="#000000",
            enabled=True,
        ),
        height=220,
    )
    return Card(
        Column(
            Text("Effects: ParticleField + ScanlineOverlay + Vignette", size=14),
            Box(height=10),
            scene,
            spacing=0,
        ),
        title="Effects Preview",
        subtitle="Live layered background with the new effects controls",
        radius=14,
        content_padding=14,
    )


def _data_grid_preview() -> Card:
    columns = ["id", "status", "owner", "eta"]
    rows = [
        ["JOB-104", "Queued", "Ava", "2m"],
        ["JOB-097", "Running", "Noah", "11m"],
        ["JOB-088", "Blocked", "Mia", "—"],
        ["JOB-081", "Done", "Liam", "0m"],
        ["JOB-076", "Running", "Ethan", "6m"],
    ]
    return Card(
        Column(
            Text("DataGrid", size=14),
            Box(height=8),
            Box(
                DataGrid(
                    columns=columns,
                    rows=rows,
                    striped=True,
                    dense=True,
                    show_header=True,
                    events=["row_tap"],
                ),
                height=220,
            ),
            spacing=0,
        ),
        title="Data Section",
        subtitle="Table rendering + scroll/invoke hooks",
        radius=14,
        content_padding=14,
    )


def _layout_and_loading_preview() -> Card:
    return Card(
        Column(
            Text("Layout + Loading", size=14),
            Box(height=8),
            Row(
                Surface(
                    Column(
                        Text("Skeleton", size=12),
                        Box(height=8),
                        Skeleton(variant="rect", width=260, height=22, radius=8),
                        Box(height=8),
                        Skeleton(variant="text", width=220, height=14),
                        spacing=0,
                    ),
                    padding=12,
                    radius=12,
                    bgcolor="#111827",
                ),
                Surface(
                    Column(
                        Text("SkeletonLoader", size=12),
                        Box(height=8),
                        SkeletonLoader(count=4, spacing=8, width=220, height=14),
                        spacing=0,
                    ),
                    padding=12,
                    radius=12,
                    bgcolor="#111827",
                ),
                spacing=10,
            ),
            Box(height=10),
            Wrap(
                _feature_chip("Surface"),
                _feature_chip("Box"),
                _feature_chip("Row"),
                _feature_chip("Column"),
                _feature_chip("Stack"),
                _feature_chip("Wrap"),
                _feature_chip("ScrollView"),
                spacing=8,
                run_spacing=8,
            ),
            spacing=0,
        ),
        title="Layout Section",
        subtitle="Container + structure controls using the refreshed wrappers",
        radius=14,
        content_padding=14,
    )


def _composer_preview() -> Card:
    return Card(
        Column(
            Text("PromptComposer", size=14),
            Box(height=8),
            PromptComposer(
                value="Summarize release notes for this week.",
                placeholder="Type a prompt…",
                send_label="Run",
                min_lines=2,
                max_lines=6,
                show_attach=True,
                emit_on_change=True,
            ),
            spacing=0,
        ),
        title="Input Section",
        subtitle="Invoke-ready prompt composer (get/set/submit/focus/blur/attach)",
        radius=14,
        content_padding=14,
    )


def _second_batch_preview(page: ui.Page, bottom_sheet: BottomSheet) -> Card:
    event_log = Text("Event log: waiting for interaction", size=12, color="#93c5fd")

    align_control = Align(
        Text("Aligned child", size=12, color="#e2e8f0"),
        alignment="top_right",
        width_factor=1.0,
        height_factor=1.0,
    )

    bounds_probe = BoundsProbe(
        Surface(
            Text("BoundsProbe target", size=12),
            padding=8,
            radius=8,
            bgcolor="#1f2937",
        ),
        emit_initial=True,
        emit_on_change=True,
    )

    artifact_card = ArtifactCard(
        title="Artifact Card",
        message="Tap card or action to emit events.",
        action_label="Open Sheet",
        clickable=True,
    )

    attachment_tile = AttachmentTile(
        label="release_notes.md",
        subtitle="12 KB • markdown",
        type="file",
        src="demo/release_notes.md",
        clickable=True,
        show_remove=True,
    )

    async_button = AsyncActionButton(
        label="Run Async Action",
        busy_label="Running…",
        busy=False,
    )

    audio = Audio(
        title="Demo Audio",
        artist="ButterflyUI",
        src="demo://audio/sample",
        autoplay=False,
        volume=0.7,
    )

    bar_plot = BarPlot(
        values=[3, 5, 2, 8, 6, 4],
        labels=["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        color="#60a5fa",
        height=140,
    )

    brush_panel = BrushPanel(size=24, hardness=60, opacity=80, flow=75, color="#38bdf8")

    canvas = Canvas(
        background="#0b1220",
        shapes=[
            {"type": "line", "x1": 20, "y1": 20, "x2": 220, "y2": 50, "color": "#38bdf8", "stroke": 3},
            {"type": "rect", "x": 30, "y": 70, "width": 90, "height": 50, "color": "#a78bfa", "stroke": 2},
            {"type": "circle", "x": 190, "y": 120, "radius": 24, "color": "#f472b6", "stroke": 3},
        ],
        height=180,
    )

    def log_event(label: str):
        def _handler(event: dict[str, Any] | None = None) -> str:
            payload = (event or {}).get("payload") if isinstance(event, dict) else {}
            return f"Event log: {label} -> {payload}"

        return _handler

    sheet_open = {"value": False}

    def _set_sheet_open(value: bool) -> None:
        sheet_open["value"] = value
        bottom_sheet.patch(session=page.session, open=value)

    def open_sheet(_: dict[str, Any] | None = None) -> str:
        _set_sheet_open(True)
        return "Event log: bottom_sheet -> open=True"

    def toggle_sheet(_: dict[str, Any] | None = None) -> str:
        next_value = not sheet_open["value"]
        _set_sheet_open(next_value)
        return f"Event log: bottom_sheet -> open={next_value}"

    ui.bind_event(page.session, bounds_probe, "bounds", log_event("bounds_probe.bounds"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, artifact_card, "tap", log_event("artifact_card.tap"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, artifact_card, "action", open_sheet, outputs=[(event_log, "text")])
    ui.bind_event(page.session, attachment_tile, "open", log_event("attachment_tile.open"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, attachment_tile, "remove", log_event("attachment_tile.remove"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, async_button, "click", toggle_sheet, outputs=[(event_log, "text")])
    ui.bind_event(page.session, audio, "play", log_event("audio.play"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, audio, "seek", log_event("audio.seek"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, audio, "volume", log_event("audio.volume"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, bar_plot, "select", log_event("bar_plot.select"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, bottom_sheet, "state", log_event("bottom_sheet.state"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, brush_panel, "change", log_event("brush_panel.change"), outputs=[(event_log, "text")])
    ui.bind_event(page.session, canvas, "tap", log_event("canvas.tap"), outputs=[(event_log, "text")])

    return Card(
        Column(
            Text("Second Batch Controls", size=14),
            Box(height=8),
            event_log,
            Box(height=8),
            Row(
                Box(align_control, width=220, height=110, bgcolor="#111827", radius=10, padding=8),
                Box(bounds_probe, width=220, height=110, bgcolor="#0f172a", radius=10, padding=8),
                spacing=10,
            ),
            Box(height=8),
            Row(
                Expanded(artifact_card),
                Expanded(attachment_tile),
                spacing=10,
            ),
            Box(height=8),
            Row(
                Expanded(async_button),
                Expanded(bar_plot),
                spacing=10,
            ),
            Box(height=8),
            Row(
                Expanded(audio),
                Expanded(brush_panel),
                spacing=10,
            ),
            Box(height=8),
            canvas,
            spacing=0,
        ),
        title="Parity Validation",
        subtitle="align, artifact_card, async_action_button, attachment_tile, audio, bar_plot, bottom_sheet, bounds_probe, brush_panel, canvas",
        radius=14,
        content_padding=14,
    )


def main(page: ui.Page) -> None:
    page.title = "ButterflyUI - New Controls Showcase"
    page.bgcolor = "#0f172a"

    header = Surface(
        Column(
            Text("ButterflyUI Parity Demo", size=24, weight="bold", color="#f8fafc"),
            Text(
                "Showcasing newly implemented/returned controls in one screen.",
                size=13,
                color="#cbd5e1",
            ),
            spacing=6,
        ),
        padding=18,
        radius=16,
        bgcolor="#111827",
        border_color="#1f2937",
        border_width=1,
    )

    bottom_sheet = BottomSheet(
        Column(
            Text("BottomSheet Content", size=14, weight="bold"),
            Text("Opened from ArtifactCard or AsyncActionButton."),
            spacing=4,
        ),
        open=False,
        dismissible=True,
        height=220,
    )

    content = ScrollView(
        Column(
            header,
            Box(height=10),
            Divider(color="#334155", thickness=1),
            Box(height=10),
            _effect_preview(),
            Box(height=10),
            Divider(color="#334155", thickness=1),
            Box(height=10),
            _data_grid_preview(),
            Box(height=10),
            _layout_and_loading_preview(),
            Box(height=10),
            _composer_preview(),
            Box(height=10),
            Divider(color="#334155", thickness=1),
            Box(height=10),
            _second_batch_preview(page, bottom_sheet),
            spacing=0,
        ),
        direction="vertical",
        content_padding=[14, 14, 14, 20],
    )

    page.overlay = bottom_sheet
    page.set_root(content)
    page.update()


if __name__ == "__main__":
    ui.run(main, target="desktop")
