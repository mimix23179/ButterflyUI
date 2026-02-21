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
- `chip_group`
- `tag_filter_bar`
- `file_picker` (`filepicker` alias)
- `directory_picker`

## 5) List/Data Family
- `list_view`
- `grid_view`
- `virtual_list`
- `virtual_grid`
- `list_tile` (`item_tile` alias)
- `tree_view` (`tree` alias)
- `tree_node`
- `table`
- `data_table` (`data_grid`, `table_view` aliases)
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
- `breadcrumbs` (`breadcrumb_bar` alias)
- `status_bar`
- `command_palette` (`command_search` alias)
- `command_item`
- `paginator`
- `launcher`

## 8) Window Shell Controls
- `window_frame`
- `window_drag_region` (`drag_region` alias)
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
- `split_view` (`split_pane` alias)
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
- `progress_indicator` (`progress` alias)
- `progress_timeline`
- `skeleton`
- `skeleton_loader`

## 11) Engine Wrapper
- `webview`

## 12) Builder and AI Workspace
- `code_editor` (`ide` alias)
- `terminal` (`terminal_view`, `terminal_session`, `terminal_stream`, `terminal_stream_view`, `terminal_raw_view`, `terminal_prompt`, `terminal_stdin`, `terminal_stdin_injector`, `terminal_command_builder`, `terminal_capabilities`, `terminal_presets`, `terminal_replay`, `terminal_flow_gate`, `terminal_output_mapper`, `terminal_timeline`, `terminal_progress` aliases)
- `chat_thread` (`chat` alias)
- `chat_message` (`message_bubble`, `chat_bubble` aliases)
- `message_composer` (`prompt_composer` alias)
- `form` (`auto_form` alias)
- `form_field`
- `validation_summary`

## Runtime Guarantees
- Theming and style-pack tokens apply through the universal style resolver.
- Motion hooks and modifier chains are available across controls.
- Overlay stack integration is unified through `overlay_host`.
- WebView supports runtime engine selection (`windows` / `inapp` / `flutter`), fallback engine, request headers, user agent, popup policy, storage/cookie/cache toggles, and richer lifecycle events (`load_start`, `progress`, `load_stop`, `load_error`, `http_error`).
