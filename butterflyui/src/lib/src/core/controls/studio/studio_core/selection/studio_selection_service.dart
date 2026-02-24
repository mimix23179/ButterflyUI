import '../../studio_contract.dart';

class StudioSelectionService {
  String activeSurface = 'canvas';
  String activeTool = 'select';
  String focusedPanel = 'inspector';
  String selectedId = '';
  final Set<String> selectedIds = <String>{};

  void loadFrom(Map<String, Object?> source) {
    activeSurface = studioNorm(
      (source['active_surface'] ?? activeSurface).toString(),
    );
    if (activeSurface.isEmpty) activeSurface = 'canvas';

    activeTool = studioNorm((source['active_tool'] ?? activeTool).toString());
    if (activeTool.isEmpty) activeTool = 'select';

    focusedPanel = studioNorm(
      (source['focused_panel'] ?? focusedPanel).toString(),
    );
    if (focusedPanel.isEmpty) focusedPanel = 'inspector';

    selectedIds
      ..clear()
      ..addAll(
        studioCoerceStringList(
          source['selected_ids'],
        ).where((id) => id.isNotEmpty),
      );
    selectedId = (source['selected_id'] ?? '').toString().trim();
    if (selectedId.isNotEmpty) {
      selectedIds.add(selectedId);
    } else if (selectedIds.isNotEmpty) {
      selectedId = selectedIds.first;
    }
  }

  void selectOne(String id) {
    final value = id.trim();
    selectedIds.clear();
    if (value.isNotEmpty) {
      selectedIds.add(value);
      selectedId = value;
    } else {
      selectedId = '';
    }
  }

  void selectMany(List<String> ids) {
    selectedIds
      ..clear()
      ..addAll(ids.where((id) => id.trim().isNotEmpty));
    selectedId = selectedIds.isEmpty ? '' : selectedIds.first;
  }

  void toggle(String id) {
    final value = id.trim();
    if (value.isEmpty) return;
    if (selectedIds.contains(value)) {
      selectedIds.remove(value);
      if (selectedId == value) {
        selectedId = selectedIds.isEmpty ? '' : selectedIds.first;
      }
    } else {
      selectedIds.add(value);
      selectedId = value;
    }
  }

  void clear() {
    selectedIds.clear();
    selectedId = '';
  }

  void setTool(String tool) {
    final normalized = studioNorm(tool);
    if (normalized.isNotEmpty) {
      activeTool = normalized;
    }
  }

  void setActiveSurface(String surface) {
    final normalized = normalizeStudioSurfaceToken(surface);
    if (normalized.isNotEmpty) {
      activeSurface = normalized;
    }
  }

  void setFocusedPanel(String panel) {
    final normalized = normalizeStudioModuleToken(panel);
    if (normalized.isNotEmpty) {
      focusedPanel = normalized;
    }
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'active_surface': activeSurface,
      'active_tool': activeTool,
      'focused_panel': focusedPanel,
      'selected_id': selectedId,
      'selected_ids': selectedIds.toList(growable: false),
    };
  }
}
