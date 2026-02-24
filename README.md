![Alt text](https://github.com/mimix23179/ButterflyUI/blob/main/assets/banner.png?raw=true)

# ButterflyUI

ButterflyUI is a programmable Python UI framework with a Flutter rendering runtime.

The short version:
- Python is the remote (authoritative app logic + UI declarations)
- Flutter is the receiver (renders controls + emits runtime events)
- Both sides communicate through structured JSON control payloads

If you know Flet, the mental model is similar at a high level, but ButterflyUI is designed around a larger modular control catalog and explicit umbrella-control systems.

## What ButterflyUI Is

ButterflyUI is a cross-runtime UI system where your application defines and mutates UI from Python, and a Dart/Flutter runtime renders that UI in real time.

It is not just a widget library.
It is a protocol-driven UI runtime with:
- Declarative control trees
- Runtime control invocation
- Event forwarding from Flutter back to Python
- Schema validation and normalization on the Python side
- A large control catalog, including umbrella controls for complex domains

## Core Architecture

ButterflyUI has two ends:

1. Python SDK (authoring and orchestration)
- You create control trees with Python control classes
- Controls serialize to JSON payloads (`type`, `id`, `props`, `children`)
- Python can call runtime methods on controls (`invoke`)
- Python receives user/runtime events emitted by Flutter

2. Flutter Runtime (rendering and interaction)
- Receives JSON control payloads
- Routes each control type through the control renderer
- Builds Flutter widgets and module-specific workbenches
- Registers invoke handlers for runtime calls
- Sends structured events back to Python

The bridge between both ends is JSON-first and method/event based.

## What ButterflyUI Does

ButterflyUI is built to support both simple app UI and complex interactive tooling.

Examples of what it handles well:
- Standard form and layout UIs
- Token-aware visual systems
- Asset-centric galleries
- IDE-like editing surfaces
- Embedded execution/terminal workbenches
- Visual builder workflows

In practice, ButterflyUI lets you keep app logic in Python while still getting a rich, reactive Flutter surface.

## Control Model

A ButterflyUI control has:
- `control_type`: semantic control ID (for example `button`, `gallery`, `terminal`)
- `props`: validated configuration/state payload
- `children`: nested controls
- optional runtime methods (`set_props`, `set_module`, `set_state`, etc.)

Runtime flow:
1. Python declares/updates controls
2. JSON is sent to Flutter
3. Flutter renders and binds handlers
4. User interacts in Flutter
5. Flutter emits events back to Python
6. Python updates state/controls and sends next payload

## Umbrella Controls

ButterflyUI includes umbrella controls for complex systems. These are single control identities with many focused submodules under the same control.

Primary umbrella controls:
- `candy`: low-level composable visual/structural primitives
- `skins`: token and visual identity system
- `gallery`: resource and asset interaction system
- `code_editor`: logic/code authoring environment
- `studio`: visual builder workspace
- `terminal`: execution and process workbench

Why umbrella controls matter:
- One control ID keeps orchestration clear
- Submodules keep internals composable
- Python and Flutter stay in sync around the same domain contract

## Python-Dart Contract

ButterflyUI relies on explicit control contracts:
- Python control classes define ergonomic API and normalization behavior
- Python schema definitions validate payload shape
- Flutter builders implement runtime behavior for each control/module
- Renderer routing maps JSON `type` to the correct builder path

This contract-centric design is what keeps large control catalogs maintainable.

## Event and Invoke System

ButterflyUI is not static rendering. Controls can be interactive runtime actors.

Common patterns:
- Python calls `set_props` to mutate control state
- Python calls `set_module` on umbrella controls to switch active module payload
- Flutter emits `change`, `select`, `submit`, `module_change`, `state_change`, etc.
- Python reacts and publishes the next state

This makes the UI loop explicit, testable, and deterministic.

## Repository Layout (High Level)

- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/controls/`
  Python control definitions and API surface
- `butterflyui/sdk/python/packages/butterflyui/src/butterflyui/core/schema.py`
  Control schema validation/contract layer
- `butterflyui/src/lib/src/core/control_renderer.dart`
  Main Flutter control dispatch/router
- `butterflyui/src/lib/src/core/controls/`
  Flutter control builders by domain
- `LIST.md`
  Detailed control catalog and umbrella/submodule contracts

## Example Mental Model

Conceptually:

```python
from butterflyui.controls import Column, Button, Terminal

ui = Column(
    Button(text="Run"),
    Terminal(
        module="workbench",
        modules={
            "prompt": {"placeholder": "enter command"},
            "stream_view": True,
            "log_panel": True,
        },
    ),
)
```

The important part is not the exact snippet syntax, but the flow:
- Python declares the control graph
- Runtime renders it
- Events come back to Python
- Python drives subsequent updates

## Design Goals

- Keep Python as the app orchestration layer
- Keep Flutter as the rendering and interaction engine
- Keep control contracts explicit and evolvable
- Support both simple controls and complex workbenches
- Stay deterministic under runtime mutation

## Current Project State

ButterflyUI is under active development.
The control surface is broad and continues to be refined, especially around deep umbrella-control behavior and Python<->Flutter wiring consistency.

## Summary

ButterflyUI is a protocol-driven Python-to-Flutter UI runtime.

Python defines and controls UI behavior.
Flutter renders and interacts with users.
JSON carries the contract between both ends.
The umbrella-control architecture allows ButterflyUI to scale from standard UI to tool-grade systems without abandoning a single coherent model.
