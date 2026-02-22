# ButterflyUI v1 Control List

This is the active v1 scope. Controls outside this list are not first-class controls in ButterflyUI v1.

## 1) Component Contract
- `Component` is the universal control contract for SDK controls.
- Every control supports:
  - `style` (local style overrides, including slot maps)
  - `variant` (string or object, for intent/size/density/tone)
  - `state` (idle/hover/pressed/focused/disabled/loading)
  - `modifiers` (composable interaction/effect modifiers)
  - `motion` (named or inline motion override)
  - `style_slots` (slot-level styling overrides)

## 2) Display Family
- `text`
- `icon`
- `image`
- `markdown_view`
- `code_view`
- `rich_text_editor`
- `html_view`
- `diff_view`
- `chart`
- `sparkline`
- `empty_state`
- `error_state`

## 3) Button Family
- `button`

## 4) Input Family
- `text_field`
- `search_bar`
- `checkbox`
- `radio`
- `switch`
- `slider`
- `select`
- `multi_select`
- `combobox`
- `date_picker`
- `date_range_picker`
- `chip_group`
- `tag_filter_bar`
- `file_picker`
- `directory_picker`

## 5) List/Data Family
- `list_view`
- `grid_view`
- `virtual_list`
- `virtual_grid`
- `list_tile`
- `tree_view`
- `tree_node`
- `table`
- `data_table`
- `file_browser`
- `task_list`

## 6) Overlay Family
- `overlay_host`
- `modal`
- `popover`
- `portal`
- `context_menu`
- `tooltip`
- `toast`
- `toast_host`
- `notification_center`

## 7) Navigation Family
- `router`
- `route_view`
- `route_host`
- `tabs`
- `menu_bar`
- `menu_item`
- `sidebar`
- `app_bar`
- `drawer`
- `breadcrumbs`
- `status_bar`
- `command_palette`
- `command_item`
- `paginator`
- `launcher`

## 8) Window Shell Controls
- `window_frame`
- `window_drag_region`
- `window_controls`

## 9) Scene Controls
- `page`
- `page_scene`
- `surface`
- `box`
- `row`
- `column`
- `stack`
- `wrap`
- `expanded`
- `scroll_view`
- `split_view`
- `dock_layout`
- `pane`
- `inspector_panel`
- `divider`
- `card`

## 10) Effects and Interaction
- `animated_background`
- `particle_field`
- `scanline_overlay`
- `vignette`
- `key_listener`
- `shortcut_map`
- `animation_asset`
- `progress_indicator`
- `progress_timeline`
- `skeleton`
- `skeleton_loader`

## 11) Engine Wrapper
- `webview`

## 12) Builder and AI Workspace
- `code_editor`
- `terminal`
- `chat_thread`
- `chat_message`
- `message_composer`
- `form`
- `form_field`
- `validation_summary`

## Runtime Guarantees
- Theming and style-pack tokens apply through the universal style resolver.
- Motion hooks and modifier chains are available across controls.
- Overlay stack integration is unified through `overlay_host`.
- WebView supports runtime engine selection (`windows` / `inapp` / `flutter`), fallback engine, request headers, user agent, popup policy, storage/cookie/cache toggles, and richer lifecycle events (`load_start`, `progress`, `load_stop`, `load_error`, `http_error`).
- `code_editor` defaults to Monaco-backed editing with invoke actions (`get_value`, `set_value`, `focus`, `blur`, `select_all`, `insert_text`, `format_document`, `reveal_line`, `set_markers`) and emits editor lifecycle/events (`ready`, `change`, `save`, `submit`, `cursor_change`).
- `terminal` is xterm-backed with invoke actions (`clear`, `write`, `append_lines`, `focus`, `blur`, `set_input`, `set_read_only`, `get_buffer`) and emits runtime events (`input`, `change`, `submit`).
- New builder controls are available end-to-end: `rich_text_editor`, `date_picker`, `date_range_picker`, `multi_select`, `combobox`, `chart`, `sparkline`, `diff_view`, `notification_center`, and `html_view` (webview-backed HTML rendering).
