class ControlModifierCapabilities {
  final bool supportsInteractiveModifiers;
  final bool supportsGlassModifiers;
  final bool supportsTransitionModifiers;

  const ControlModifierCapabilities({
    required this.supportsInteractiveModifiers,
    required this.supportsGlassModifiers,
    required this.supportsTransitionModifiers,
  });

  static ControlModifierCapabilities forControl(String controlType) {
    final normalized = _canonicalControlType(controlType);
    return ControlModifierCapabilities(
      supportsInteractiveModifiers: _runtimeInteractiveControls.contains(
        normalized,
      ),
      supportsGlassModifiers: _runtimeGlassControls.contains(normalized),
      supportsTransitionModifiers: _runtimeTransitionControls.contains(
        normalized,
      ),
    );
  }

  static int manifestVersion = 1;

  static void applySerializedManifest(Object? rawManifest) {
    if (rawManifest is! Map) return;
    final manifest = rawManifest.cast<Object?, Object?>();
    final controlsRaw = manifest['controls'];
    if (controlsRaw is! Map) return;
    final controls = controlsRaw.cast<Object?, Object?>();

    final interactive = _coerceSet(controls['interactive']);
    final glass = _coerceSet(controls['glass']);
    final transition = _coerceSet(controls['transition']);

    if (interactive.isNotEmpty) {
      _runtimeInteractiveControls = interactive;
    }
    if (glass.isNotEmpty) {
      _runtimeGlassControls = glass;
    }
    if (transition.isNotEmpty) {
      _runtimeTransitionControls = transition;
    }

    final versionRaw = manifest['version'];
    if (versionRaw is num) {
      manifestVersion = versionRaw.toInt();
    } else if (versionRaw is String) {
      final parsed = int.tryParse(versionRaw);
      if (parsed != null) {
        manifestVersion = parsed;
      }
    }
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }

  static String _canonicalControlType(String value) {
    var normalized = _normalize(value);
    if (normalized.startsWith('candy_')) {
      normalized = normalized.substring(6);
    }
    if (normalized == 'container') return 'surface';
    if (normalized == 'box') return 'surface';
    return normalized;
  }

  static Set<String> _runtimeInteractiveControls = Set<String>.from(
    _defaultInteractiveControls,
  );
  static Set<String> _runtimeGlassControls = Set<String>.from(
    _defaultGlassControls,
  );
  static Set<String> _runtimeTransitionControls = Set<String>.from(
    _defaultTransitionControls,
  );

  static Set<String> _coerceSet(Object? raw) {
    if (raw is! List) return <String>{};
    final out = <String>{};
    for (final value in raw) {
      final normalized = _normalize(value?.toString() ?? '');
      if (normalized.isNotEmpty) {
        out.add(normalized);
      }
    }
    return out;
  }

  static const Set<String> _defaultInteractiveControls = <String>{
    'button',
    'checkbox',
    'switch',
    'slider',
    'text_field',
    'rich_text_editor',
    'search_bar',
    'radio',
    'select',
    'multi_select',
    'combobox',
    'date_picker',
    'date_range_picker',
    'chip_group',
    'tag_filter_bar',
    'file_picker',
    'filepicker',
    'directory_picker',
    'tabs',
    'menu_item',
    'command_item',
    'list_tile',
    'item_tile',
    'paginator',
    'launcher',
    'notification_center',
  };

  static const Set<String> _defaultGlassControls = <String>{
    'surface',
    'box',
    'container',
    'card',
    'row',
    'column',
    'stack',
    'wrap',
    'scroll_view',
    'split_view',
    'split_pane',
    'dock_layout',
    'pane',
    'inspector_panel',
    'page_scene',
    'grid_view',
    'virtual_grid',
    'list_view',
    'virtual_list',
    'table',
    'data_table',
    'data_grid',
    'table_view',
    'file_browser',
    'task_list',
    'overlay_host',
    'modal',
    'popover',
    'portal',
    'context_menu',
    'tooltip',
    'toast',
    'toast_host',
    'window_frame',
  };

  static const Set<String> _defaultTransitionControls = <String>{
    'overlay_host',
    'modal',
    'popover',
    'portal',
    'context_menu',
    'tooltip',
    'toast',
    'toast_host',
    'slide_panel',
    'page_scene',
  };
}
