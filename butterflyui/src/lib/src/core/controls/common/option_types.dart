class ConduitOption {
  final String label;
  final Object? value;
  final bool enabled;
  final String? description;
  final String? icon;
  final Map<String, Object?>? animation;

  const ConduitOption({
    required this.label,
    required this.value,
    required this.enabled,
    required this.description,
    required this.icon,
    this.animation,
  });

  String get key => (value ?? label).toString();
}

List<ConduitOption> coerceOptionList(Object? value) {
  if (value is! List) return const [];
  final options = <ConduitOption>[];
  for (final item in value) {
    if (item is Map) {
      final label = item['label']?.toString() ?? item['value']?.toString() ?? '';
      final option = ConduitOption(
        label: label,
        value: item.containsKey('value') ? item['value'] : label,
        enabled: item['enabled'] == null ? true : (item['enabled'] == true),
        description: item['description']?.toString(),
        icon: item['icon']?.toString(),
        animation: item['animation'] is Map ? Map<String, Object?>.from(item['animation'] as Map) : null,
      );
      options.add(option);
      continue;
    }
    final label = item?.toString() ?? '';
    options.add(ConduitOption(label: label, value: item, enabled: true, description: null, icon: null));
  }
  return options;
}
