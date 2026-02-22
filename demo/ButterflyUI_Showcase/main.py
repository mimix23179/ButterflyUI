from __future__ import annotations

import butterflyui as ui
from butterflyui.controls import (
    Box,
    Card,
    Column,
    DataGrid,
    Divider,
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
            spacing=0,
        ),
        direction="vertical",
        content_padding=[14, 14, 14, 20],
    )

    page.set_root(content)
    page.update()


if __name__ == "__main__":
    ui.run(main, target="desktop")
