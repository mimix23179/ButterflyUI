# Implementation Playbook

This file is the practical checklist for finishing or refining controls.

## Python Side

When adding or refining a control:

1. define the public constructor and documented fields
2. register the control in the schema contract
3. keep child handling explicit
4. keep events and invoke helpers consistent with the base control contract

## Flutter Side

For the runtime implementation:

1. add a renderer case or registry entry for the canonical control name
2. read props from the normalized control node
3. keep layout behavior separate from visual decoration
4. wire invoke handlers only for controls that actually own runtime behavior

## Verification

For each completed control family:

- add or update a demo
- add or update a runtime widget test
- run Python compile checks
- run targeted Flutter tests

## Current Priority Order

1. layout
2. inputs
3. display and media
4. navigation
5. overlay
6. data
7. effects and motion
