class ControlModifierCapabilities {
  final bool supportsInteractiveModifiers;
  final bool supportsGlassModifiers;
  final bool supportsTransitionModifiers;
  final bool supportsStyleDecorators;
  final bool supportsMotionDecorators;
  final bool supportsEffectDecorators;
  final Set<String> supportedSlots;

  const ControlModifierCapabilities({
    required this.supportsInteractiveModifiers,
    required this.supportsGlassModifiers,
    required this.supportsTransitionModifiers,
    required this.supportsStyleDecorators,
    required this.supportsMotionDecorators,
    required this.supportsEffectDecorators,
    required this.supportedSlots,
  });

  static ControlModifierCapabilities forControl(String controlType) {
    final normalized = _canonicalControlType(controlType);
    final styleControls = _runtimeStyleControls;
    final motionControls = _runtimeMotionControls;
    final effectControls = _runtimeEffectControls;
    final slotMap = _runtimeSlotMap;
    final defaultSlots = slotMap['*'] ?? _defaultSlots;
    final controlSlots = slotMap[normalized] ?? defaultSlots;
    return ControlModifierCapabilities(
      supportsInteractiveModifiers: _runtimeInteractiveControls.contains(
        normalized,
      ),
      supportsGlassModifiers: _runtimeGlassControls.contains(normalized),
      supportsTransitionModifiers: _runtimeTransitionControls.contains(
        normalized,
      ),
      supportsStyleDecorators: styleControls == null
          ? !_styleDecoratorExclusions.contains(normalized)
          : styleControls.contains(normalized),
      supportsMotionDecorators: motionControls == null
          ? !_motionDecoratorExclusions.contains(normalized)
          : motionControls.contains(normalized),
      supportsEffectDecorators: effectControls == null
          ? !_effectDecoratorExclusions.contains(normalized)
          : effectControls.contains(normalized),
      supportedSlots: Set<String>.from(controlSlots),
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
    final style = _coerceSet(controls['style']);
    final motion = _coerceSet(controls['motion']);
    final effects = _coerceSet(controls['effects']);
    final slots = _coerceSlotMap(controls['slots']);

    if (interactive.isNotEmpty) {
      _runtimeInteractiveControls = interactive;
    }
    if (glass.isNotEmpty) {
      _runtimeGlassControls = glass;
    }
    if (transition.isNotEmpty) {
      _runtimeTransitionControls = transition;
    }
    if (style.isNotEmpty) {
      _runtimeStyleControls = style;
    }
    if (motion.isNotEmpty) {
      _runtimeMotionControls = motion;
    }
    if (effects.isNotEmpty) {
      _runtimeEffectControls = effects;
    }
    if (slots.isNotEmpty) {
      _runtimeSlotMap = slots;
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
  static Set<String>? _runtimeStyleControls;
  static Set<String>? _runtimeMotionControls;
  static Set<String>? _runtimeEffectControls;
  static Map<String, Set<String>> _runtimeSlotMap = Map<String, Set<String>>.from(
    _defaultSlotMap,
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

  static Map<String, Set<String>> _coerceSlotMap(Object? raw) {
    if (raw is! Map) return <String, Set<String>>{};
    final out = <String, Set<String>>{};
    final map = raw.cast<Object?, Object?>();
    map.forEach((key, value) {
      final control = _normalize(key?.toString() ?? '');
      if (control.isEmpty) return;
      final slots = _coerceSet(value);
      if (slots.isNotEmpty) {
        out[control] = slots;
      }
    });
    return out;
  }

  static const Set<String> _defaultInteractiveControls = <String>{
    'candy',
    'skins',
    'style',
    'modifier',
    'button',
    'elevated_button',
    'filled_button',
    'outlined_button',
    'text_button',
    'checkbox',
    'switch',
    'slider',
    'text_field',
    'radio',
    'select',
    'combo_box',
    'multi_select',
    'combobox',
    'date_picker',
    'date_range_picker',
    'chip',
    'file_picker',
    'filepicker',
    'directory_picker',
    'tabs',
    'menu_item',
    'list_tile',
    'item_tile',
    'pagination',
    'drawer',
    'sidebar',
    'alert_dialog',
    'snack_bar',
    'bubble',
    'display',
    'notification_center',
  };

  static const Set<String> _defaultGlassControls = <String>{
    'candy',
    'style',
    'modifier',
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
    'pane',
    'page',
    'grid_view',
    'virtual_grid',
    'list_view',
    'virtual_list',
    'table',
    'data_table',
    'data_grid',
    'table_view',
    'overlay',
    'alert_dialog',
    'popover',
    'portal',
    'context_menu',
    'tooltip',
    'toast',
    'toast_host',
    'slide_panel',
    'window_frame',
  };

  static const Set<String> _defaultTransitionControls = <String>{
    'candy',
    'style',
    'modifier',
    'overlay',
    'alert_dialog',
    'popover',
    'portal',
    'context_menu',
    'tooltip',
    'toast',
    'toast_host',
    'slide_panel',
    'page',
  };

  static const Set<String> _styleDecoratorExclusions = <String>{
    'expanded',
    'flex_spacer',
    'spacer',
  };

  static const Set<String> _motionDecoratorExclusions = <String>{
    'expanded',
    'flex_spacer',
    'spacer',
  };

  static const Set<String> _effectDecoratorExclusions = <String>{
    'expanded',
    'flex_spacer',
    'spacer',
  };

  static const Set<String> _defaultSlots = <String>{
    'root',
    'background',
    'border',
    'content',
    'label',
    'icon',
    'leading',
    'trailing',
    'overlay',
  };

  static const Map<String, Set<String>> _defaultSlotMap = <String, Set<String>>{
    '*': _defaultSlots,
    'surface': <String>{
      'root',
      'background',
      'border',
      'content',
      'overlay',
      'leading',
      'trailing',
      'label',
      'icon',
    },
    'button': <String>{
      'root',
      'background',
      'border',
      'content',
      'label',
      'icon',
      'leading',
      'trailing',
      'overlay',
    },
    'bubble': <String>{
      'root',
      'background',
      'border',
      'content',
      'label',
      'leading',
      'trailing',
      'overlay',
      'message',
      'thread',
      'composer',
      'attachment',
      'meta',
    },
    'display': <String>{
      'root',
      'background',
      'border',
      'content',
      'label',
      'leading',
      'trailing',
      'overlay',
      'identity',
      'status',
      'rating',
      'reactions',
      'check',
      'ownership',
    },
    'gallery': <String>{
      'root',
      'background',
      'border',
      'content',
      'overlay',
      'toolbar',
      'panel',
      'item_root',
      'item_media',
      'item_meta',
      'item_actions',
      'leading',
      'trailing',
      'label',
      'icon',
    },
  };
}
