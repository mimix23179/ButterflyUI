# Control Contract

Every ButterflyUI control should follow the same contract.

## Minimum Shape

Each control should define:

- a canonical control name
- documented props
- child or slot behavior
- events it emits
- invokes it responds to
- runtime serialization through the shared control payload shape

## What A Good Control Doc Should Explain

For every public control, document:

1. Purpose
2. Canonical name
3. Category
4. Child model
5. Important props
6. Events
7. Invokes
8. Minimal example

## Serialization

The Python side should serialize controls through the shared control contract:

- `id`
- `type`
- `props`
- `children`

The Flutter side should be able to render the same control name directly without alias-only branches.

## Completion Standard

A control is only complete when all of these are true:

- Python constructor exists and is documented
- schema contract exists
- Flutter runtime renderer exists
- events and invoke handlers work
- at least one demo or example exists for the family
- at least one test covers the runtime path

## API Rules

- Prefer one canonical public name per control.
- Keep compatibility aliases secondary.
- Do not hide core behavior behind umbrella wrappers.
- Reuse shared base behavior only when it keeps the API clearer.
