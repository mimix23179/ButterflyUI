# Alpha 0.1.0 Release Checklist

Last updated: March 8, 2026

## Current Runtime Signal

- Complete: `43`
- Partial: `121`
- Mismatch: `21`
- Stub: `11`

## Recommended Finish Order

### 1. Layout Family [Done]

Current signal:

- total: `27`
- complete: `0`
- partial: `27`
- stub: `0`
- mismatch: `0`

Finish first:

- `container`
- `surface`
- `box`
- `decorated_box`
- `row`
- `column`
- `wrap`
- `stack`
- `scroll_view`
- `scrollable_column`
- `scrollable_row`
- `grid_view`
- `split_pane`
- `pane`
- `frame`
- `align`
- `center`
- `expanded`
- `spacer`
- `flex_spacer`

Required to call layout "done":

- Unified surface inheritance for `color/bgcolor/background`, `gradient`, `image`, `backdrop_*`, `blur`, `shadow`, `radius`, `border_*`
- Consistent single-child, multi-child, and named-slot behavior
- Consistent spacing/alignment semantics across `row`, `column`, `wrap`, `stack`
- Reliable scroll behavior: `reverse`, `physics`, `primary`, `shrink_wrap`, axis aliases
- Real invoke/state coverage for `split_pane`, `grid_view`, `frame`, and `pane`
- Focused runtime tests for nested layouts and transparent/tinted/image-backed surfaces
- Demo coverage proving the family works in a realistic screen

### 2. Navigation Family [Done]

Finish after layout:

- `app_bar`
- `top_bar`
- `menu_item`
- tab/rail/menu navigation controls

Required:

- selected/active/hover/pressed states
- badges and active indicators
- transparent/tinted nav surfaces
- keyboard navigation
- submenu and open/close behavior
- consistent action payloads and routing

### 3. Overlay Family [Done]

Finish after navigation:

- `tooltip`
- `popover`
- `alert_dialog`
- `drawer`
- `snack_bar`
- sheet/menu overlay controls

Required:

- anchor/placement behavior
- open/close/dismiss contract
- outside click and escape behavior
- focus trap
- transitions
- scrim/backdrop styling
- inherited tint and transparent surface behavior

### 4. Data and Lists [Done]

Finish after overlay:

- `list_view`
- `item_tile`
- `data_grid`
- `table_view`

Required:

- collection and slot behavior
- selection state
- hover/active/pressed styling
- empty/loading/error states
- sorting/filtering hooks
- virtualization/perf strategy

### 5. Effects and Customization [Done]

Current high-risk area:

- total: `35`
- complete: `4`
- partial: `16`
- stub: `3`
- mismatch: `12`

Finish after the app-shell stack is stable:

- `glass_blur`
- `glow_effect`
- `shimmer`
- `parallax`
- `particles`
- `pixelate`
- `noise_*`
- `chromatic_shift`

Required:

- effect target rules
- composition order
- clipping rules
- safe fallbacks
- performance limits
- integration with the current motion and effects controls

## Immediate Milestone

Ship the core app-shell stack in this order:

1. Finish `layout`
2. Finish `navigation`
3. Finish `overlay`

That gives ButterflyUI a stable base for real app screens before spending more time on specialized effects.
