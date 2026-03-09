# Authoring Model

ButterflyUI should be authored as a normal control tree.

## Order Of Composition

1. Build structure with layout controls.
2. Add content with display, media, and input controls.
3. Add screen chrome with navigation and overlay controls.
4. Add visual refinement with explicit colors, gradients, shadows, motion, and effects.

## Main Families

### Layout

Use layout controls to define structure and sizing:

- `Container`
- `Surface`
- `Box`
- `Row`
- `Column`
- `Wrap`
- `Stack`
- `ScrollView`
- `GridView`
- `SplitPane`

### Inputs

Use input controls for interaction:

- `Button`
- `TextField`
- `TextArea`
- `Dropdown`
- `Select`
- `Slider`
- `Switch`
- `Checkbox`

### Navigation

Use navigation controls for app chrome and movement:

- `AppBar`
- `TopBar`
- `Sidebar`
- `Tabs`
- `MenuBar`
- `Pagination`

### Overlay

Use overlay controls for transient UI:

- `AlertDialog`
- `Popover`
- `Drawer`
- `BottomSheet`
- `SnackBar`
- `Tooltip`
- `ToastHost`

### Display And Media

Use display controls to present data and content:

- `Text`
- `MarkdownView`
- `Image`
- `Audio`
- `Video`
- `Chart`
- `ArtifactCard`

## Authoring Rules

- Prefer explicit composition over hidden framework behavior.
- Use canonical control names in examples and docs.
- Keep events and invokes attached to the control that owns the behavior.
- Keep visual refinement local to the control tree.

## Teaching Order

Teach ButterflyUI in this order:

1. layout
2. inputs
3. display and media
4. navigation
5. overlay
6. data
7. effects and motion
