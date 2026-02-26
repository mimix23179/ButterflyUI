// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_monaco/flutter_monaco.dart' as monaco;
import 'package:flutter_monaco/src/platform/platform_webview.dart'
    as monaco_platform;
import 'package:webview_windows/webview_windows.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

import 'submodules/code_editor_submodule_context.dart';
import 'submodules/commands.dart';
import 'submodules/diagnostics.dart';
import 'submodules/diff.dart';
import 'submodules/document.dart';
import 'submodules/editor.dart';
import 'submodules/explorer.dart';
import 'submodules/layout_modules.dart';
import 'submodules/search.dart';
import 'submodules/tabs.dart';

const int _codeEditorSchemaVersion = 2;

const List<String> _codeEditorModuleOrder = [
  'ide',
  'editor_surface',
  'editor_view',
  'editor_tabs',
  'document_tab_strip',
  'file_tabs',
  'explorer_tree',
  'workspace_explorer',
  'file_tree',
  'tree',
  'code_document',
  'code_buffer',
  'code_category_layer',
  'editor_intent_router',
  'intent_router',
  'intent_panel',
  'intent_search',
  'smart_search_bar',
  'search_box',
  'search_field',
  'search_scope_selector',
  'search_source',
  'search_provider',
  'search_history',
  'search_intent',
  'search_item',
  'search_results_view',
  'search_everything_panel',
  'semantic_search',
  'query_token',
  'scoped_search_replace',
  'inline_search_overlay',
  'inline_widget',
  'inline_error_view',
  'diagnostics_panel',
  'diagnostic_stream',
  'gutter',
  'hint',
  'mini_map',
  'editor_minimap',
  'ghost_editor',
  'diff',
  'diff_narrator',
  'command_bar',
  'command_search',
  'dock_graph',
  'dock',
  'dock_pane',
  'workbench_editor',
  'inspector',
  'scope_picker',
  'empty_state_view',
  'empty_view',
  'export_panel',
];

const Set<String> _codeEditorModules = {
  'editor_intent_router',
  'editor_minimap',
  'editor_surface',
  'editor_view',
  'diff',
  'editor_tabs',
  'empty_state_view',
  'explorer_tree',
  'ide',
  'code_buffer',
  'code_category_layer',
  'code_document',
  'file_tabs',
  'file_tree',
  'smart_search_bar',
  'semantic_search',
  'search_box',
  'search_everything_panel',
  'search_field',
  'search_history',
  'search_intent',
  'search_item',
  'search_provider',
  'search_results_view',
  'search_scope_selector',
  'search_source',
  'query_token',
  'document_tab_strip',
  'command_search',
  'tree',
  'workbench_editor',
  'workspace_explorer',
  'command_bar',
  'diagnostic_stream',
  'diff_narrator',
  'dock_graph',
  'dock',
  'dock_pane',
  'empty_view',
  'export_panel',
  'gutter',
  'hint',
  'mini_map',
  'scope_picker',
  'scoped_search_replace',
  'diagnostics_panel',
  'ghost_editor',
  'inline_error_view',
  'inline_search_overlay',
  'inline_widget',
  'inspector',
  'intent_panel',
  'intent_router',
  'intent_search',
};

const Set<String> _codeEditorStates = {
  'idle',
  'loading',
  'ready',
  'searching',
  'diff',
  'disabled',
};

const Set<String> _codeEditorEvents = {
  'ready',
  'change',
  'submit',
  'save',
  'format_request',
  'search',
  'open_document',
  'close_document',
  'select',
  'state_change',
  'module_change',
};

const Set<String> _defaultCodeEditorEvents = {
  'ready',
  'change',
  'submit',
  'save',
  'search',
  'open_document',
  'close_document',
  'select',
  'format_request',
  'state_change',
  'module_change',
};

const Map<String, String> _codeEditorRegistryRoleAliases = {
  'module': 'module_registry',
  'modules': 'module_registry',
  'panel': 'panel_registry',
  'panels': 'panel_registry',
  'tool': 'tool_registry',
  'tools': 'tool_registry',
  'view': 'view_registry',
  'views': 'view_registry',
  'surface': 'view_registry',
  'surfaces': 'view_registry',
  'provider': 'provider_registry',
  'providers': 'provider_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'module_registry': 'module_registry',
  'panel_registry': 'panel_registry',
  'tool_registry': 'tool_registry',
  'view_registry': 'view_registry',
  'provider_registry': 'provider_registry',
  'command_registry': 'command_registry',
};

const Map<String, String> _codeEditorRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'panel_registry': 'enabled_panels',
  'tool_registry': 'enabled_tools',
  'view_registry': 'enabled_views',
  'provider_registry': 'enabled_providers',
  'command_registry': 'enabled_commands',
};

const Map<String, List<String>> _codeEditorManifestDefaults = {
  'enabled_modules': <String>[
    'ide',
    'editor_surface',
    'editor_view',
    'editor_minimap',
    'gutter',
    'hint',
    'inline_widget',
    'ghost_editor',
    'code_buffer',
    'code_document',
    'code_category_layer',
    'editor_tabs',
    'document_tab_strip',
    'file_tabs',
    'workspace_explorer',
    'file_tree',
    'explorer_tree',
    'tree',
    'smart_search_bar',
    'search_box',
    'search_intent',
    'search_provider',
    'semantic_search',
    'search_scope_selector',
    'search_source',
    'query_token',
    'search_results_view',
    'search_everything_panel',
    'search_history',
    'command_search',
    'diff',
    'diff_narrator',
    'diagnostic_stream',
    'diagnostics_panel',
    'inline_error_view',
    'dock',
    'dock_pane',
    'dock_graph',
    'empty_state_view',
    'editor_intent_router',
    'intent_router',
    'intent_panel',
    'intent_search',
    'inspector',
    'command_bar',
    'export_panel',
    'workbench_editor',
  ],
  'enabled_views': <String>[
    'ide',
    'editor_surface',
    'editor_view',
    'workbench_editor',
    'diff',
    'search_results_view',
    'diagnostics_panel',
  ],
  'enabled_panels': <String>[
    'workspace_explorer',
    'explorer_tree',
    'diagnostics_panel',
    'inspector',
    'command_bar',
    'search_box',
    'search_results_view',
    'intent_panel',
    'dock_pane',
  ],
  'enabled_tools': <String>[
    'editor_intent_router',
    'scoped_search_replace',
    'command_search',
    'smart_search_bar',
    'editor_minimap',
    'gutter',
  ],
  'enabled_providers': <String>[
    'search_provider',
    'search_source',
    'semantic_search',
    'diagnostic_stream',
    'query_token',
  ],
  'enabled_commands': <String>[
    'command_bar',
    'command_search',
    'editor_intent_router',
    'export_panel',
    'diff_narrator',
  ],
};

class ButterflyUICodeEditor extends StatefulWidget {
  final String controlId;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final String value;
  final String? language;
  final String? theme;
  final String engine;
  final String webviewEngine;
  final bool readOnly;
  final bool autofocus;
  final bool wordWrap;
  final bool showLineNumbers;
  final bool showGutter;
  final bool showMinimap;
  final bool glyphMargin;
  final bool emitOnChange;
  final int debounceMs;
  final int tabSize;
  final String? documentUri;
  final double fontSize;
  final String fontFamily;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICodeEditor({
    super.key,
    required this.controlId,
    required this.rawChildren,
    required this.buildChild,
    required this.value,
    required this.language,
    required this.theme,
    required this.engine,
    required this.webviewEngine,
    required this.readOnly,
    required this.autofocus,
    required this.wordWrap,
    required this.showLineNumbers,
    required this.showGutter,
    required this.showMinimap,
    required this.glyphMargin,
    required this.emitOnChange,
    required this.debounceMs,
    required this.tabSize,
    required this.documentUri,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICodeEditor> createState() => _ButterflyUICodeEditorState();
}

class _ButterflyUICodeEditorState extends State<ButterflyUICodeEditor> {
  late final TextEditingController _fallbackController = TextEditingController(
    text: widget.value,
  );
  final FocusNode _fallbackFocusNode = FocusNode();
  final ScrollController _fallbackEditorScroll = ScrollController();
  final ScrollController _fallbackGutterScroll = ScrollController();
  monaco.MonacoController? _monacoController;

  Timer? _debounce;
  bool _fallbackSuppressChange = false;
  bool _monacoReady = false;
  bool _suppressMonacoChange = false;
  bool _isSyncingGutter = false;
  String _latestValue = '';
  late Map<String, Object?> _runtimeProps;
  int _providerRequestSerial = 0;
  final Map<String, Map<String, Object?>> _pendingProviderRequests =
      <String, Map<String, Object?>>{};

  bool get _useMonaco {
    return true;
  }

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.initialProps);
    _latestValue = widget.value;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);

    _fallbackEditorScroll.addListener(() {
      if (_isSyncingGutter) return;
      if (!_fallbackGutterScroll.hasClients) return;
      _isSyncingGutter = true;
      final target = _fallbackEditorScroll.offset.clamp(
        0.0,
        _fallbackGutterScroll.position.maxScrollExtent,
      );
      _fallbackGutterScroll.jumpTo(target);
      _isSyncingGutter = false;
    });
  }

  @override
  void didUpdateWidget(covariant ButterflyUICodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.initialProps);

    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final oldUsesMonaco = _resolveUseMonaco(oldWidget.engine);
    if (_useMonaco != oldUsesMonaco && !_useMonaco) {
      _monacoReady = false;
    }

    if (widget.value != oldWidget.value && widget.value != _latestValue) {
      _latestValue = widget.value;
      if (_useMonaco) {
        unawaited(_setMonacoValue(widget.value));
        unawaited(_applyMonacoRuntimeOptionsFromProps());
      } else if (widget.value != _fallbackController.text) {
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: widget.value,
          selection: TextSelection.collapsed(offset: widget.value.length),
        );
        _fallbackSuppressChange = false;
      }
    }
  }

  bool _resolveUseMonaco(String value) {
    return true;
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _debounce?.cancel();
    _fallbackFocusNode.dispose();
    _fallbackController.dispose();
    _fallbackEditorScroll.dispose();
    _fallbackGutterScroll.dispose();
    super.dispose();
  }

  monaco.EditorOptions _buildMonacoOptions() {
    return monaco.EditorOptions(
      language: _resolveMonacoLanguage(
        (_runtimeProps['language'] ?? widget.language ?? 'plaintext')
            .toString(),
      ),
      theme: _resolveMonacoTheme(
        (_runtimeProps['theme'] ?? widget.theme ?? 'vs_dark').toString(),
      ),
      readOnly: _runtimeProps['read_only'] == true || widget.readOnly,
      wordWrap: _runtimeProps['word_wrap'] == true || widget.wordWrap,
      lineNumbers: _runtimeProps['line_numbers'] == null
          ? widget.showLineNumbers
          : (_runtimeProps['line_numbers'] == true),
      minimap: _runtimeProps['show_minimap'] == true || widget.showMinimap,
      fontSize:
          coerceDouble(_runtimeProps['font_size'])?.toDouble() ??
          widget.fontSize,
      fontFamily: (_runtimeProps['font_family'] ?? widget.fontFamily)
          .toString(),
      tabSize: (coerceOptionalInt(_runtimeProps['tab_size']) ?? widget.tabSize)
          .clamp(1, 12),
      formatOnPaste: _runtimeProps['format_on_paste'] == true,
      formatOnType: _runtimeProps['format_on_type'] == true,
      renderWhitespace: _runtimeProps['render_whitespace'] == null
          ? monaco.RenderWhitespace.selection
          : monaco.RenderWhitespace.fromId(
              _runtimeProps['render_whitespace'].toString(),
            ),
      automaticLayout: true,
      smoothScrolling: true,
      mouseWheelZoom: true,
      fontLigatures: true,
    );
  }

  monaco.MonacoLanguage _resolveMonacoLanguage(String value) {
    return monaco.MonacoLanguage.fromId(value.trim().toLowerCase());
  }

  monaco.MonacoTheme _resolveMonacoTheme(String value) {
    final normalized = _norm(value);
    switch (normalized) {
      case 'vs':
      case 'light':
        return monaco.MonacoTheme.vs;
      case 'hc_black':
      case 'high_contrast':
      case 'contrast':
        return monaco.MonacoTheme.hcBlack;
      case 'hc_light':
        return monaco.MonacoTheme.hcLight;
      default:
        return monaco.MonacoTheme.vsDark;
    }
  }

  String _resolveWebViewEngineLabel() {
    return _normalizeCodeEditorWebViewEngine(
      (_runtimeProps['webview_engine'] ?? widget.webviewEngine).toString(),
    );
  }

  bool _shouldUseInAppMonaco(String engine) {
    final normalized = _normalizeCodeEditorWebViewEngine(engine);
    return normalized == 'windows_inapp';
  }

  bool _isUnsupportedWindowsWebViewError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('unsupported_platform') ||
        message.contains('platform is not supported') ||
        message.contains('webview2');
  }

  Future<monaco.MonacoController> _createInAppMonacoController({
    required int readyTimeoutMs,
  }) async {
    return monaco.MonacoController.createForTesting(
      webViewController: _MonacoInAppWindowsWebViewController(
        readyTimeoutMs: readyTimeoutMs,
      ),
      markReady: true,
    );
  }

  String _resolveProviderName([String? explicit]) {
    final normalizedExplicit = _norm(explicit ?? '');
    if (normalizedExplicit.isNotEmpty) {
      return normalizedExplicit;
    }
    final searchProvider =
        _sectionProps(_runtimeProps, 'search_provider') ?? const {};
    final fromModule = _norm((searchProvider['provider'] ?? '').toString());
    if (fromModule.isNotEmpty) {
      return fromModule;
    }
    final registries = _coerceObjectMap(_runtimeProps['registries']);
    final providerRegistry = _coerceObjectMap(registries['provider_registry']);
    if (providerRegistry.isNotEmpty) {
      return _norm(providerRegistry.keys.first);
    }
    return 'local_provider';
  }

  void _upsertModuleSection(String module, Map<String, Object?> patch) {
    final normalizedModule = _norm(module);
    if (normalizedModule.isEmpty) return;
    final modules = _coerceObjectMap(_runtimeProps['modules']);
    final section = _coerceObjectMap(modules[normalizedModule]);
    section.addAll(patch);
    modules[normalizedModule] = section;
    _runtimeProps['modules'] = modules;
    _runtimeProps[normalizedModule] = section;
  }

  Map<String, Object?> _dispatchProviderRequest({
    required String action,
    String? provider,
    Map<String, Object?> payload = const <String, Object?>{},
    String source = 'invoke',
  }) {
    final normalizedAction = _norm(action);
    final resolvedProvider = _resolveProviderName(provider);
    final requestId = 'provider_req_${++_providerRequestSerial}';
    final request = <String, Object?>{
      'request_id': requestId,
      'provider': resolvedProvider,
      'action': normalizedAction,
      'payload': payload,
      'source': source,
      'created_ms': DateTime.now().millisecondsSinceEpoch,
    };
    _pendingProviderRequests[requestId] = request;

    final providerSection = _coerceObjectMap(
      (_coerceObjectMap(_runtimeProps['modules']))['search_provider'],
    );
    providerSection['status'] = 'waiting';
    providerSection['last_request_id'] = requestId;
    providerSection['last_action'] = normalizedAction;
    providerSection['provider'] = resolvedProvider;
    providerSection['last_request_payload'] = payload;
    _upsertModuleSection('search_provider', providerSection);

    final eventName = normalizedAction == 'format_document'
        ? 'format_request'
        : (normalizedAction.contains('search') ? 'search' : 'change');
    _emitConfiguredEvent(eventName, {
      ...request,
      'module': 'search_provider',
      'intent': 'provider_request',
    });
    return <String, Object?>{
      'ok': true,
      'request_id': requestId,
      'provider': resolvedProvider,
      'action': normalizedAction,
    };
  }

  Future<void> _applyProviderResponse(
    Map<String, Object?> request,
    Map<String, Object?> response, {
    String? error,
  }) async {
    final requestId = request['request_id']?.toString() ?? '';
    final action = _norm(request['action']?.toString() ?? '');
    final provider = request['provider']?.toString() ?? '';
    final hasError = error != null && error.trim().isNotEmpty;

    if (action == 'format_document' && !hasError) {
      final value = response['value'] ?? response['text'] ?? response['code'];
      if (value != null) {
        final text = value.toString();
        _latestValue = text;
        if (_useMonaco) {
          await _setMonacoValue(text);
        } else if (_fallbackController.text != text) {
          _fallbackSuppressChange = true;
          _fallbackController.value = _fallbackController.value.copyWith(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
          _fallbackSuppressChange = false;
        }
      }
    }

    if ((action == 'search' || action.contains('search')) && !hasError) {
      final results = response['results'];
      if (results is List) {
        _upsertModuleSection('search_results_view', <String, Object?>{
          'items': List<dynamic>.from(results),
          'provider': provider,
          'request_id': requestId,
        });
      }
    }

    final providerSection = _coerceObjectMap(
      (_coerceObjectMap(_runtimeProps['modules']))['search_provider'],
    );
    providerSection['status'] = hasError ? 'error' : 'ready';
    providerSection['last_request_id'] = requestId;
    providerSection['last_action'] = action;
    providerSection['last_response'] = response;
    providerSection['error'] = hasError ? error : '';
    _upsertModuleSection('search_provider', providerSection);
    _runtimeProps['last_provider_response'] = <String, Object?>{
      'request_id': requestId,
      'provider': provider,
      'action': action,
      'error': hasError ? error : '',
      'response': response,
    };
    _emitConfiguredEvent('change', {
      'module': 'search_provider',
      'intent': hasError ? 'provider_error' : 'provider_response',
      'request_id': requestId,
      'provider': provider,
      'action': action,
      'error': hasError ? error : '',
      'response': response,
    });
  }

  Future<Map<String, Object?>> _resolveProviderRequest({
    required String requestId,
    Map<String, Object?> response = const <String, Object?>{},
    String? error,
  }) async {
    final request = _pendingProviderRequests.remove(requestId);
    if (request == null) {
      return <String, Object?>{
        'ok': false,
        'error': 'unknown provider request id: $requestId',
      };
    }
    await _applyProviderResponse(request, response, error: error);
    return <String, Object?>{
      'ok': true,
      'request_id': requestId,
      'pending': _pendingProviderRequests.length,
    };
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (_norm(method)) {
      case 'get_state':
        return {
          'schema_version':
              _runtimeProps['schema_version'] ?? _codeEditorSchemaVersion,
          'module': _runtimeProps['module'],
          'state': _runtimeProps['state'],
          'manifest': _runtimeProps['manifest'],
          'registries': _runtimeProps['registries'],
          'value': _latestValue,
          'pending_provider_requests': _pendingProviderRequests.values
              .map((request) => Map<String, Object?>.from(request))
              .toList(growable: false),
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          final incomingMap = coerceObjectMap(incoming);
          final nextValue =
              incomingMap['value'] ??
              incomingMap['text'] ??
              incomingMap['code'];
          setState(() {
            _runtimeProps.addAll(incomingMap);
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
          if (nextValue != null) {
            final valueText = nextValue.toString();
            _latestValue = valueText;
            if (_useMonaco) {
              await _setMonacoValue(valueText);
            } else if (_fallbackController.text != valueText) {
              _fallbackSuppressChange = true;
              _fallbackController.value = _fallbackController.value.copyWith(
                text: valueText,
                selection: TextSelection.collapsed(offset: valueText.length),
              );
              _fallbackSuppressChange = false;
            }
          }
          if (_useMonaco) {
            await _applyMonacoRuntimeOptionsFromProps();
          }
        }
        return _runtimeProps;
      case 'set_manifest':
        final manifestPayload = _coerceObjectMap(args['manifest']);
        setState(() {
          final manifest = _coerceObjectMap(_runtimeProps['manifest']);
          manifest.addAll(manifestPayload);
          _runtimeProps['manifest'] = manifest;
          _runtimeProps = _normalizeProps(_runtimeProps);
        });
        _emitConfiguredEvent('change', {
          'module': 'workbench_editor',
          'intent': 'set_manifest',
          'manifest': _runtimeProps['manifest'],
        });
        return {'ok': true, 'manifest': _runtimeProps['manifest']};
      case 'set_module':
        final module = _norm(args['module']?.toString() ?? '');
        if (!_codeEditorModules.contains(module)) {
          return {'ok': false, 'error': 'unknown module: $module'};
        }
        final payload = args['payload'];
        final payloadMap = payload is Map
            ? coerceObjectMap(payload)
            : <String, Object?>{};
        setState(() {
          final modules = _coerceObjectMap(_runtimeProps['modules']);
          modules[module] = payloadMap;
          _runtimeProps['modules'] = modules;
          _runtimeProps['module'] = module;
          _runtimeProps[module] = payloadMap;
          _runtimeProps = _normalizeProps(_runtimeProps);
        });
        _emitConfiguredEvent('module_change', {
          'module': module,
          'payload': payloadMap,
        });
        return {'ok': true, 'module': module};
      case 'set_state':
        final state = _norm(args['state']?.toString() ?? '');
        if (!_codeEditorStates.contains(state)) {
          return {'ok': false, 'error': 'unknown state: $state'};
        }
        setState(() {
          _runtimeProps['state'] = state;
        });
        _emitConfiguredEvent('state_change', {'state': state});
        return {'ok': true, 'state': state};
      case 'emit':
      case 'trigger':
        final event = _norm(
          (args['event'] ?? args['name'] ?? method).toString(),
        );
        if (!_codeEditorEvents.contains(event)) {
          return {'ok': false, 'error': 'unknown event: $event'};
        }
        final payload = args['payload'];
        _emitConfiguredEvent(
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      case 'request_provider':
      case 'provider_request':
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{...args};
        return _dispatchProviderRequest(
          action: (args['action'] ?? payload['action'] ?? 'query').toString(),
          provider: (args['provider'] ?? payload['provider'])?.toString(),
          payload: payload,
          source: 'invoke',
        );
      case 'resolve_provider_request':
      case 'provider_response':
      case 'set_provider_response':
        return _resolveProviderRequest(
          requestId: (args['request_id'] ?? args['id'] ?? '').toString(),
          response: args['response'] is Map
              ? coerceObjectMap(args['response'] as Map)
              : (args['payload'] is Map
                    ? coerceObjectMap(args['payload'] as Map)
                    : <String, Object?>{}),
        );
      case 'reject_provider_request':
      case 'provider_error':
        return _resolveProviderRequest(
          requestId: (args['request_id'] ?? args['id'] ?? '').toString(),
          response: args['response'] is Map
              ? coerceObjectMap(args['response'] as Map)
              : <String, Object?>{},
          error: (args['error'] ?? 'provider request rejected').toString(),
        );
      case 'list_provider_requests':
        return <String, Object?>{
          'pending': _pendingProviderRequests.values
              .map((request) => Map<String, Object?>.from(request))
              .toList(growable: false),
        };
      default:
        final normalized = _norm(method);
        if (normalized.startsWith('register_')) {
          final role = normalized == 'register_module'
              ? (args['role'] ?? 'module').toString()
              : normalized.replaceFirst('register_', '');
          final moduleId =
              (args['module_id'] ??
                      args['id'] ??
                      args['name'] ??
                      args['module'] ??
                      '')
                  .toString();
          final definition = _coerceObjectMap(args['definition']);
          late Map<String, Object?> result;
          setState(() {
            result = registerUmbrellaModule(
              props: _runtimeProps,
              role: role,
              moduleId: moduleId,
              definition: definition,
              modules: _codeEditorModules,
              roleAliases: _codeEditorRegistryRoleAliases,
              roleManifestLists: _codeEditorRegistryManifestLists,
              manifestDefaults: _codeEditorManifestDefaults,
            );
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
          if (result['ok'] == true) {
            _emitConfiguredEvent('change', {
              'module': 'workbench_editor',
              'intent': normalized,
              'role': result['role'],
              'module_id': result['module_id'],
            });
          }
          return result;
        }
        if (_codeEditorModules.contains(normalized)) {
          final payload = args['payload'];
          final payloadMap = payload is Map
              ? coerceObjectMap(payload)
              : <String, Object?>{...args};
          setState(() {
            final modules = _coerceObjectMap(_runtimeProps['modules']);
            modules[normalized] = payloadMap;
            _runtimeProps['modules'] = modules;
            _runtimeProps['module'] = normalized;
            _runtimeProps[normalized] = payloadMap;
            _runtimeProps = _normalizeProps(_runtimeProps);
          });
          _emitConfiguredEvent('module_change', {
            'module': normalized,
            'payload': payloadMap,
          });
          return {'ok': true, 'module': normalized};
        }
    }

    return _handleMonacoInvoke(method, args);
  }

  Future<Object?> _handleFallbackInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        return _fallbackController.text;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _fallbackSuppressChange = false;
        _latestValue = value;
        if (mounted) setState(() {});
        return null;
      case 'focus':
        _fallbackFocusNode.requestFocus();
        return null;
      case 'blur':
        _fallbackFocusNode.unfocus();
        return null;
      case 'select_all':
        _fallbackController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _fallbackController.text.length,
        );
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        if (value.isEmpty) return null;
        final selection = _fallbackController.selection;
        if (!selection.isValid) {
          _fallbackController.text += value;
        } else {
          final base = selection.start;
          final extent = selection.end;
          final text = _fallbackController.text;
          final next = text.replaceRange(base, extent, value);
          _fallbackController.value = TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: base + value.length),
          );
        }
        _latestValue = _fallbackController.text;
        _emitFallbackChange(immediate: true);
        if (mounted) setState(() {});
        return null;
      case 'format_document':
        return _dispatchProviderRequest(
          action: 'format_document',
          provider: args['provider']?.toString(),
          payload: <String, Object?>{
            'value': _fallbackController.text,
            'language': (_runtimeProps['language'] ?? widget.language ?? '')
                .toString(),
            'module': _runtimeProps['module'],
          },
          source: 'editor',
        );
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<Object?> _handleMonacoInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final controller = _monacoController;
    if (controller == null) {
      if (method == 'get_value') return _latestValue;
      if (method == 'set_value') {
        _latestValue = args['value']?.toString() ?? '';
      }
      return null;
    }

    switch (method) {
      case 'get_value':
        final result = await controller.getValue(defaultValue: _latestValue);
        _latestValue = result;
        return _latestValue;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _latestValue = value;
        await _setMonacoValue(value);
        return null;
      case 'focus':
        await controller.focus();
        return null;
      case 'blur':
        FocusManager.instance.primaryFocus?.unfocus();
        return null;
      case 'select_all':
        await controller.selectAll();
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        if (value.isEmpty) return null;
        final cursor =
            await controller.getCursorPosition() ??
            const monaco.Position(line: 1, column: 1);
        await controller.insertText(cursor, value);
        return null;
      case 'format_document':
        await controller.format();
        return _dispatchProviderRequest(
          action: 'format_document',
          provider: args['provider']?.toString(),
          payload: <String, Object?>{
            'value': _latestValue,
            'language': (_runtimeProps['language'] ?? widget.language ?? '')
                .toString(),
            'module': _runtimeProps['module'],
          },
          source: 'editor',
        );
      case 'reveal_line':
        final line = coerceOptionalInt(args['line']) ?? 1;
        await controller.revealLine(line, center: true);
        return null;
      case 'set_markers':
        final markers = args['markers'] is List
            ? _coerceMonacoMarkers(args['markers'] as List)
            : const <monaco.MarkerData>[];
        await controller.setMarkers(
          markers,
          owner: (args['owner'] ?? 'butterflyui').toString(),
        );
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<void> _setMonacoValue(String value) async {
    final controller = _monacoController;
    if (controller == null) return;
    _suppressMonacoChange = true;
    try {
      await controller.setValue(value);
    } finally {
      _suppressMonacoChange = false;
    }
  }

  Future<void> _applyMonacoRuntimeOptionsFromProps() async {
    final controller = _monacoController;
    if (controller == null) return;
    final options = _buildMonacoOptions();
    await controller.updateOptions(options);
    await controller.setTheme(options.theme);
    await controller.setLanguage(options.language);
  }

  List<monaco.MarkerData> _coerceMonacoMarkers(List<dynamic> source) {
    final out = <monaco.MarkerData>[];
    for (final entry in source) {
      if (entry is! Map) continue;
      final map = coerceObjectMap(entry);
      final message = (map['message'] ?? map['text'] ?? '').toString();
      if (message.trim().isEmpty) continue;
      final startLine =
          coerceOptionalInt(map['start_line'] ?? map['line']) ?? 1;
      final startColumn =
          coerceOptionalInt(map['start_column'] ?? map['column']) ?? 1;
      final endLine =
          coerceOptionalInt(map['end_line'] ?? map['to_line']) ?? startLine;
      final endColumn =
          coerceOptionalInt(map['end_column'] ?? map['to_column']) ??
          startColumn + 1;
      final severityValue = map['severity'];
      monaco.MarkerSeverity severity = monaco.MarkerSeverity.info;
      if (severityValue is num) {
        severity = monaco.MarkerSeverity.fromValue(severityValue.toInt());
      } else {
        switch (_norm(severityValue?.toString() ?? '')) {
          case 'error':
            severity = monaco.MarkerSeverity.error;
            break;
          case 'warning':
          case 'warn':
            severity = monaco.MarkerSeverity.warning;
            break;
          case 'hint':
            severity = monaco.MarkerSeverity.hint;
            break;
          default:
            severity = monaco.MarkerSeverity.info;
        }
      }
      out.add(
        monaco.MarkerData(
          range: monaco.Range(
            startLine: startLine,
            startColumn: startColumn,
            endLine: endLine,
            endColumn: endColumn,
          ),
          message: message,
          severity: severity,
          source: map['source']?.toString(),
          code: map['code']?.toString(),
        ),
      );
    }
    return out;
  }

  void _emitFallbackChange({bool immediate = false}) {
    if (_fallbackSuppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    final text = _fallbackController.text;
    if (immediate || widget.debounceMs <= 0) {
      _emitConfiguredEvent('change', {'value': text});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      _emitConfiguredEvent('change', {'value': text});
    });
  }

  void _emitFallbackSubmit() {
    _debounce?.cancel();
    _emitConfiguredEvent('submit', {
      'value': _fallbackController.text,
      'language': widget.language ?? '',
    });
  }

  void _handleMonacoReady(monaco.MonacoController controller) {
    if (mounted) {
      setState(() {
        _monacoController = controller;
        _monacoReady = true;
      });
    } else {
      _monacoController = controller;
      _monacoReady = true;
    }
    unawaited(() async {
      await _applyMonacoRuntimeOptionsFromProps();
      await _setMonacoValue(_latestValue);
      _emitConfiguredEvent('ready', {
        'engine': 'monaco',
        'webview_engine': _resolveWebViewEngineLabel(),
      });
    }());
  }

  void _handleMonacoContentChanged(String value) {
    if (_suppressMonacoChange) return;
    _latestValue = value;
    final emitOnChange = _runtimeProps['emit_on_change'] == null
        ? widget.emitOnChange
        : (_runtimeProps['emit_on_change'] == true);
    if (!emitOnChange) return;

    final debounceMs =
        (coerceOptionalInt(_runtimeProps['debounce_ms']) ?? widget.debounceMs)
            .clamp(0, 2000);
    _debounce?.cancel();
    if (debounceMs == 0) {
      _emitConfiguredEvent('change', {'value': value});
      return;
    }
    _debounce = Timer(Duration(milliseconds: debounceMs), () {
      if (!mounted) return;
      _emitConfiguredEvent('change', {'value': value});
    });
  }

  Set<String> _configuredEvents() {
    final raw = _runtimeProps['events'];
    final out = <String>{};
    if (raw is List) {
      for (final entry in raw) {
        final value = _norm(entry?.toString() ?? '');
        if (value.isNotEmpty && _codeEditorEvents.contains(value)) {
          out.add(value);
        }
      }
    }
    if (out.isEmpty) {
      return _defaultCodeEditorEvents;
    }
    return out;
  }

  void _emitConfiguredEvent(String event, Map<String, Object?> payload) {
    final normalized = _norm(event);
    final configured = _configuredEvents();
    if (configured.isNotEmpty && !configured.contains(normalized)) {
      return;
    }
    widget.sendEvent(widget.controlId, normalized, {
      'schema_version':
          _runtimeProps['schema_version'] ?? _codeEditorSchemaVersion,
      'module': _runtimeProps['module'],
      'state': _runtimeProps['state'],
      ...payload,
    });
  }

  Widget _buildFallbackEditor() {
    final lineCount = '\n'.allMatches(_fallbackController.text).length + 1;
    final lineNumbersText = List<String>.generate(
      lineCount,
      (index) => '${index + 1}',
    ).join('\n');

    final editor = TextField(
      controller: _fallbackController,
      focusNode: _fallbackFocusNode,
      autofocus: widget.autofocus,
      readOnly: _runtimeProps['read_only'] == true || widget.readOnly,
      maxLines: null,
      minLines: 12,
      scrollController: _fallbackEditorScroll,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: widget.fontSize,
        color: widget.textColor,
        height: 1.45,
      ),
      onChanged: (_) {
        _latestValue = _fallbackController.text;
        _emitFallbackChange();
        if (mounted) setState(() {});
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );

    final wrappedEditor = Focus(
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final key = event.logicalKey;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        if (ctrl && key == LogicalKeyboardKey.enter) {
          _emitFallbackSubmit();
          return KeyEventResult.handled;
        }
        if (ctrl && key == LogicalKeyboardKey.keyS) {
          _emitConfiguredEvent('save', {'value': _fallbackController.text});
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: editor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showGutter && widget.showLineNumbers)
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: widget.backgroundColor.withValues(alpha: 0.75),
            alignment: Alignment.topRight,
            child: SingleChildScrollView(
              controller: _fallbackGutterScroll,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                lineNumbersText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: widget.fontFamily,
                  fontSize: widget.fontSize - 1,
                  color: widget.textColor.withValues(alpha: 0.55),
                  height: 1.45,
                ),
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: widget.wordWrap
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            child: SizedBox(
              width: widget.wordWrap ? null : 1200,
              child: wrappedEditor,
            ),
          ),
        ),
      ],
    );
  }

  Future<monaco.MonacoController> _createMonacoController() async {
    if (!Platform.isWindows) {
      throw UnsupportedError('CodeEditor Monaco engine is Windows-only.');
    }
    final readyTimeoutMs =
        (coerceOptionalInt(_runtimeProps['ready_timeout_ms']) ?? 20000)
            .clamp(5000, 120000)
            .toInt();
    final webviewEngine = _resolveWebViewEngineLabel();
    if (_shouldUseInAppMonaco(webviewEngine)) {
      return _createInAppMonacoController(readyTimeoutMs: readyTimeoutMs);
    }
    return monaco.MonacoController.create(
      options: _buildMonacoOptions(),
      readyTimeout: Duration(milliseconds: readyTimeoutMs),
    );
  }

  Widget _buildMonacoEditor() {
    return Stack(
      children: [
        Positioned.fill(
          child: monaco.MonacoEditor(
            controllerFactory: _createMonacoController,
            initialValue: _latestValue,
            options: _buildMonacoOptions(),
            autofocus: widget.autofocus,
            showStatusBar: _runtimeProps['show_status_bar'] == true,
            contentDebounce: Duration(
              milliseconds:
                  (coerceOptionalInt(_runtimeProps['debounce_ms']) ??
                          widget.debounceMs)
                      .clamp(0, 2000),
            ),
            onReady: _handleMonacoReady,
            onContentChanged: _handleMonacoContentChanged,
            onSelectionChanged: (range) {
              _emitConfiguredEvent('select', {'range': range?.toJson()});
            },
            onFocus: () => _emitConfiguredEvent('change', {'focus': true}),
            onBlur: () => _emitConfiguredEvent('change', {'focus': false}),
            backgroundColor: widget.backgroundColor,
            errorBuilder: (context, error, stackTrace) =>
                _CodeEditorMonacoError(
                  error: error,
                  onRetry: () {
                    setState(() {
                      _monacoController = null;
                      _monacoReady = false;
                    });
                  },
                ),
          ),
        ),
        if (!_monacoReady)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x44000000),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
      ],
    );
  }

  Widget _buildEditorContainer() {
    final child = _buildMonacoEditor();
    final minHeight = coerceDouble(_runtimeProps['height']) ?? 320;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: widget.borderWidth > 0
              ? Border.all(color: widget.borderColor, width: widget.borderWidth)
              : null,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = _availableModules(_runtimeProps);
    final requestedModule = _norm(
      _runtimeProps['module']?.toString() ?? 'editor_surface',
    );
    final activeModule = availableModules.contains(requestedModule)
        ? requestedModule
        : (availableModules.isEmpty
              ? 'editor_surface'
              : availableModules.first);
    final customChildren = widget.rawChildren
        .whereType<Map>()
        .map((child) => widget.buildChild(coerceObjectMap(child)))
        .toList(growable: false);
    final customLayout =
        _runtimeProps['custom_layout'] == true ||
        _norm((_runtimeProps['layout'] ?? '').toString()) == 'custom';

    if ((_runtimeProps['state']?.toString() ?? '') == 'loading') {
      return const Center(child: CircularProgressIndicator());
    }

    if (customLayout && customChildren.isNotEmpty) {
      if (customChildren.length == 1) {
        return customChildren.first;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < customChildren.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            customChildren[i],
          ],
        ],
      );
    }

    Widget buildModuleSurface(String module, Map<String, Object?> section) {
      final ctx = CodeEditorSubmoduleContext(
        controlId: widget.controlId,
        module: module,
        section: section,
        onEmit: _emitConfiguredEvent,
      );
      return buildCodeEditorEditorModule(module, ctx) ??
          buildCodeEditorDocumentModule(module, ctx) ??
          buildCodeEditorTabsModule(module, ctx) ??
          buildCodeEditorExplorerModule(module, ctx) ??
          buildCodeEditorSearchModule(module, ctx) ??
          buildCodeEditorDiagnosticsModule(module, ctx) ??
          buildCodeEditorDiffModule(module, ctx) ??
          buildCodeEditorCommandsModule(module, ctx) ??
          buildCodeEditorLayoutModule(module, ctx) ??
          buildCodeEditorGeneric(ctx);
    }

    final editorModules = <String>{
      'ide',
      'editor_surface',
      'editor_view',
      'workbench_editor',
    };
    final panelModule = editorModules.contains(activeModule)
        ? (availableModules.contains('diagnostics_panel')
              ? 'diagnostics_panel'
              : (availableModules.contains('search_results_view')
                    ? 'search_results_view'
                    : activeModule))
        : activeModule;
    final panelSection =
        _sectionProps(_runtimeProps, panelModule) ??
        <String, Object?>{'events': _runtimeProps['events']};
    final panelWidget = editorModules.contains(activeModule)
        ? buildCodeEditorEditorModule(
                'workbench_editor',
                CodeEditorSubmoduleContext(
                  controlId: widget.controlId,
                  module: 'workbench_editor',
                  section: <String, Object?>{
                    'active_module': activeModule,
                    'language': _runtimeProps['language'] ?? widget.language,
                    'engine': _runtimeProps['engine'] ?? widget.engine,
                    'enabled_modules': availableModules.join(', '),
                  },
                  onEmit: _emitConfiguredEvent,
                ),
              ) ??
              buildCodeEditorGeneric(
                CodeEditorSubmoduleContext(
                  controlId: widget.controlId,
                  module: 'workbench_editor',
                  section: <String, Object?>{
                    'active_module': activeModule,
                    'language': _runtimeProps['language'] ?? widget.language,
                    'engine': _runtimeProps['engine'] ?? widget.engine,
                    'enabled_modules': availableModules.join(', '),
                  },
                  onEmit: _emitConfiguredEvent,
                ),
              )
        : buildModuleSurface(panelModule, panelSection);
    final workbenchHeight = (coerceDouble(_runtimeProps['height']) ?? 760)
        .clamp(360, 2200)
        .toDouble();

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CodeEditorHeader(
          state: (_runtimeProps['state'] ?? 'ready').toString(),
          language:
              (_runtimeProps['language'] ?? widget.language ?? 'plaintext')
                  .toString(),
          engine: (_runtimeProps['engine'] ?? widget.engine).toString(),
        ),
        const SizedBox(height: 8),
        _ModuleTabs(
          modules: availableModules,
          activeModule: activeModule,
          onSelect: (module) {
            setState(() {
              _runtimeProps['module'] = module;
            });
            _emitConfiguredEvent('module_change', {'module': module});
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: workbenchHeight,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: _buildEditorContainer()),
                const SizedBox(height: 8),
                Text(
                  'Module: ${panelModule.replaceAll('_', ' ')}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.35),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: panelWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    return ensureUmbrellaLayoutBounds(
      props: _runtimeProps,
      child: body,
      defaultHeight: workbenchHeight + 140,
      minHeight: 420,
      maxHeight: 3200,
    );
  }
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? _codeEditorSchemaVersion)
          .clamp(1, 9999);

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _codeEditorModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _codeEditorStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final engine = _norm(out['engine']?.toString() ?? '');
  if (engine.isEmpty) {
    out['engine'] = 'monaco';
  } else if (engine == 'flutter_monaco' || engine == 'monaco_editor') {
    out['engine'] = 'monaco';
  } else {
    out['engine'] = engine;
  }

  out['webview_engine'] = _normalizeCodeEditorWebViewEngine(
    out['webview_engine']?.toString(),
  );

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _codeEditorEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  final normalizedModules = <String, Object?>{};
  for (final moduleKey in _codeEditorModules) {
    final topLevel = out[moduleKey];
    if (topLevel is Map) {
      final value = coerceObjectMap(topLevel);
      normalizedModules[moduleKey] = value;
      out[moduleKey] = value;
    } else if (topLevel == true) {
      normalizedModules[moduleKey] = <String, Object?>{};
      out[moduleKey] = <String, Object?>{};
    }
  }
  for (final entry in modules.entries) {
    final normalized = _norm(entry.key);
    if (!_codeEditorModules.contains(normalized)) continue;
    if (entry.value == true) {
      normalizedModules[normalized] = <String, Object?>{};
      out[normalized] = <String, Object?>{};
      continue;
    }
    final value = _coerceObjectMap(entry.value);
    if (value.isEmpty && entry.value is! Map) continue;
    normalizedModules[normalized] = value;
    out[normalized] = value;
  }
  out['modules'] = normalizedModules;
  final umbrella = normalizeUmbrellaHostProps(
    props: out,
    modules: _codeEditorModules,
    roleAliases: _codeEditorRegistryRoleAliases,
    manifestDefaults: _codeEditorManifestDefaults,
  );
  out['manifest'] = umbrella['manifest'];
  out['registries'] = umbrella['registries'];
  _seedCodeEditorDefaults(out);
  return out;
}

void _seedCodeEditorDefaults(Map<String, Object?> out) {
  final modules = _coerceObjectMap(out['modules']);

  Map<String, Object?> ensureModule(
    String module,
    Map<String, Object?> defaults,
  ) {
    final fromTopLevel = _coerceObjectMap(out[module]);
    final fromModules = _coerceObjectMap(modules[module]);
    final merged = <String, Object?>{
      ...defaults,
      ...fromModules,
      ...fromTopLevel,
    };
    modules[module] = merged;
    out[module] = merged;
    return merged;
  }

  final now = DateTime.now();
  final sessionTag =
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  final normalizedModule = _norm((out['module'] ?? 'ide').toString());
  out['module'] = _codeEditorModules.contains(normalizedModule)
      ? normalizedModule
      : 'ide';
  final normalizedState = _norm((out['state'] ?? 'ready').toString());
  out['state'] = _codeEditorStates.contains(normalizedState)
      ? normalizedState
      : 'ready';

  ensureModule('ide', <String, Object?>{
    'title': 'ButterflyUI IDE',
    'subtitle': 'Monaco workbench session $sessionTag',
  });
  ensureModule('editor_surface', <String, Object?>{
    'label': 'Editor surface',
    'status': 'mounted',
  });
  ensureModule('editor_view', <String, Object?>{
    'line_numbers': true,
    'word_wrap': out['word_wrap'] == true,
    'show_minimap': out['show_minimap'] == true,
  });
  ensureModule('editor_tabs', <String, Object?>{
    'tabs': <Map<String, Object?>>[
      <String, Object?>{'id': 'main.py', 'label': 'main.py', 'dirty': true},
      <String, Object?>{'id': 'tokens.json', 'label': 'tokens.json'},
      <String, Object?>{'id': 'README.md', 'label': 'README.md'},
    ],
  });
  ensureModule('document_tab_strip', <String, Object?>{
    'tabs': <Map<String, Object?>>[
      <String, Object?>{'id': 'main.py', 'label': 'main.py', 'dirty': true},
      <String, Object?>{'id': 'tokens.json', 'label': 'tokens.json'},
      <String, Object?>{'id': 'README.md', 'label': 'README.md'},
    ],
  });
  ensureModule('file_tabs', <String, Object?>{
    'tabs': <Map<String, Object?>>[
      <String, Object?>{'id': 'main.py', 'label': 'main.py'},
      <String, Object?>{'id': 'tokens.json', 'label': 'tokens.json'},
    ],
  });
  ensureModule('workspace_explorer', <String, Object?>{
    'nodes': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'src',
        'label': 'src',
        'children': <Map<String, Object?>>[
          <String, Object?>{'id': 'main.py', 'label': 'main.py'},
          <String, Object?>{'id': 'theme.py', 'label': 'theme.py'},
        ],
      },
      <String, Object?>{
        'id': 'tests',
        'label': 'tests',
        'children': <Map<String, Object?>>[
          <String, Object?>{'id': 'test_editor.py', 'label': 'test_editor.py'},
        ],
      },
    ],
  });
  ensureModule('explorer_tree', <String, Object?>{
    'nodes': <Map<String, Object?>>[
      <String, Object?>{'id': 'symbols', 'label': 'Symbols'},
      <String, Object?>{'id': 'references', 'label': 'References'},
    ],
  });
  ensureModule('file_tree', <String, Object?>{
    'nodes': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'workspace',
        'label': 'workspace',
        'children': <Map<String, Object?>>[
          <String, Object?>{'id': 'main.py', 'label': 'main.py'},
          <String, Object?>{'id': 'README.md', 'label': 'README.md'},
        ],
      },
    ],
  });
  ensureModule('tree', <String, Object?>{
    'nodes': <Map<String, Object?>>[
      <String, Object?>{'id': 'outline', 'label': 'Outline'},
      <String, Object?>{'id': 'imports', 'label': 'Imports'},
    ],
  });
  ensureModule('search_box', <String, Object?>{
    'query': '',
    'placeholder': 'Search files, symbols, commands...',
  });
  ensureModule('search_results_view', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'r1',
        'label': 'build_manifest',
        'path': 'src/main.py:3',
      },
      <String, Object?>{
        'id': 'r2',
        'label': 'editor_surface',
        'path': 'src/editor.py:18',
      },
    ],
  });
  ensureModule('diagnostics_panel', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{
        'severity': 'warning',
        'message': 'Add docstring to build_manifest',
      },
      <String, Object?>{
        'severity': 'info',
        'message': 'No type errors detected',
      },
    ],
  });
  ensureModule('command_bar', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'id': 'open_file', 'label': 'Open File'},
      <String, Object?>{'id': 'format', 'label': 'Format Document'},
      <String, Object?>{'id': 'find', 'label': 'Find in Files'},
    ],
  });
  ensureModule('command_search', <String, Object?>{
    'query': '',
    'placeholder': 'Search commands...',
  });
  ensureModule('diff', <String, Object?>{
    'left': "print('old world')",
    'right': "print('new world')",
  });
  ensureModule('diff_narrator', <String, Object?>{
    'text': 'Changed output string and added workspace metadata.',
  });
  ensureModule('inspector', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{
        'key': 'language',
        'value': out['language'] ?? 'python',
      },
      <String, Object?>{'key': 'engine', 'value': out['engine'] ?? 'monaco'},
      <String, Object?>{
        'key': 'webview',
        'value': out['webview_engine'] ?? 'windows_inapp',
      },
    ],
  });
  ensureModule('workbench_editor', <String, Object?>{
    'left_panel': 'workspace_explorer',
    'right_panel': 'diagnostics_panel',
    'bottom_panel': 'command_bar',
  });
  ensureModule('diagnostic_stream', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'severity': 'info', 'message': 'Indexer ready'},
      <String, Object?>{'severity': 'warning', 'message': '2 pending hints'},
    ],
  });
  ensureModule('editor_minimap', <String, Object?>{'visible': true});
  ensureModule('gutter', <String, Object?>{'visible': true});
  ensureModule('hint', <String, Object?>{
    'text': 'Use Ctrl+Shift+P for command palette',
  });
  ensureModule('inline_widget', <String, Object?>{'enabled': true});
  ensureModule('inline_error_view', <String, Object?>{'enabled': true});
  ensureModule('editor_intent_router', <String, Object?>{
    'routes': <String>['open', 'search', 'format', 'diff'],
  });
  ensureModule('intent_router', <String, Object?>{
    'routes': <String>['open', 'search', 'format', 'diff'],
  });
  ensureModule('intent_panel', <String, Object?>{
    'items': <Map<String, Object?>>[
      <String, Object?>{'id': 'open', 'label': 'Open'},
      <String, Object?>{'id': 'search', 'label': 'Search'},
    ],
  });
  ensureModule('intent_search', <String, Object?>{
    'query': '',
    'placeholder': 'Search intents...',
  });
  ensureModule('smart_search_bar', <String, Object?>{
    'query': '',
    'placeholder': 'Semantic + symbol search',
  });
  ensureModule('search_provider', <String, Object?>{
    'provider': 'local_index',
    'status': 'ready',
  });
  ensureModule('semantic_search', <String, Object?>{
    'enabled': true,
    'provider': 'semantic_local',
  });
  ensureModule('search_scope_selector', <String, Object?>{
    'options': <String>['workspace', 'open_files', 'selection'],
    'selected': 'workspace',
  });
  ensureModule('search_source', <String, Object?>{
    'sources': <String>['local', 'project', 'history'],
    'selected': 'local',
  });
  ensureModule('query_token', <String, Object?>{
    'tokens': <String>['function', 'class', 'symbol', 'file'],
  });
  ensureModule('search_everything_panel', <String, Object?>{'enabled': true});
  ensureModule('search_history', <String, Object?>{
    'items': <String>['build_manifest', 'theme tokens', 'workspace explorer'],
  });
  ensureModule('dock', <String, Object?>{'layout': 'horizontal'});
  ensureModule('dock_pane', <String, Object?>{
    'panes': <String>['explorer', 'editor', 'diagnostics'],
  });
  ensureModule('dock_graph', <String, Object?>{
    'nodes': <int>[1, 2, 3],
  });
  ensureModule('empty_state_view', <String, Object?>{
    'title': 'Open a document to begin editing',
  });
  ensureModule('export_panel', <String, Object?>{
    'formats': <String>['zip', 'json'],
  });
  ensureModule('ghost_editor', <String, Object?>{'enabled': false});
  ensureModule('code_buffer', <String, Object?>{
    'language': out['language'] ?? 'python',
  });
  ensureModule('code_document', <String, Object?>{
    'uri': out['document_uri'] ?? 'file:///workspace/main.py',
  });
  ensureModule('code_category_layer', <String, Object?>{
    'categories': <String>['source', 'config', 'docs'],
  });

  final manifest = _coerceObjectMap(out['manifest']);
  for (final key in const <String>[
    'enabled_modules',
    'enabled_views',
    'enabled_panels',
    'enabled_tools',
    'enabled_providers',
    'enabled_commands',
  ]) {
    final values = umbrellaRuntimeStringList(
      manifest[key],
      allowed: _codeEditorModules,
    ).toList(growable: true);
    if (values.isEmpty) {
      values.addAll(_codeEditorManifestDefaults[key] ?? const <String>[]);
    }
    for (final module in modules.keys) {
      final normalized = _norm(module);
      if (!_codeEditorModules.contains(normalized)) continue;
      if (!values.contains(normalized)) values.add(normalized);
    }
    manifest[key] = values;
  }
  out['manifest'] = manifest;
  out['modules'] = modules;
}

List<String> _availableModules(Map<String, Object?> props) {
  final manifest = _coerceObjectMap(props['manifest']);
  final fromManifest = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _codeEditorModules,
  );
  if (fromManifest.isNotEmpty) return fromManifest;

  final modules = <String>[];
  final moduleMap = _coerceObjectMap(props['modules']);
  for (final key in _codeEditorModuleOrder) {
    if (props[key] is Map ||
        props[key] == true ||
        moduleMap[key] is Map ||
        moduleMap[key] == true) {
      modules.add(key);
    }
  }
  if (modules.isEmpty) {
    modules.addAll(const [
      'ide',
      'editor_tabs',
      'workspace_explorer',
      'editor_surface',
      'editor_view',
      'search_box',
      'diagnostics_panel',
      'inspector',
      'command_bar',
    ]);
  }
  return modules;
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final normalized = _norm(key);
  final manifest = _coerceObjectMap(props['manifest']);
  final enabled = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _codeEditorModules,
  );
  if (enabled.isNotEmpty && !enabled.contains(normalized)) {
    return null;
  }
  final section = props[normalized];
  if (section is Map) {
    return <String, Object?>{
      ...coerceObjectMap(section),
      'events': props['events'],
    };
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  final modules = _coerceObjectMap(props['modules']);
  final fromModules = modules[normalized];
  if (fromModules is Map) {
    return <String, Object?>{
      ...coerceObjectMap(fromModules),
      'events': props['events'],
    };
  }
  if (fromModules == true) {
    return <String, Object?>{'events': props['events']};
  }
  return null;
}

Map<String, Object?> _coerceObjectMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

String _norm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

String _normalizeCodeEditorWebViewEngine(String? value) {
  final normalized = _norm(value ?? '');
  if (normalized.isEmpty) return 'windows_inapp';
  if (normalized == 'windows_inapp') {
    return 'windows_inapp';
  }
  if (normalized == 'webview_windows' || normalized == 'windows') {
    return 'windows_inapp';
  }
  if (normalized == 'webview_flutter' || normalized == 'flutter') {
    return 'webview_flutter';
  }
  if (normalized == 'windows_inapp' ||
      normalized == 'windows_inapp_monaco' ||
      normalized == 'inapp' ||
      normalized == 'monaco' ||
      normalized == 'flutter_monaco' ||
      normalized == 'monaco_editor') {
    return 'windows_inapp';
  }
  return normalized;
}

class _CodeEditorHeader extends StatelessWidget {
  const _CodeEditorHeader({
    required this.state,
    required this.language,
    required this.engine,
  });

  final String state;
  final String language;
  final String engine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Code Editor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'State: $state',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text('Lang: $language'),
        const SizedBox(width: 8),
        Text('Engine: $engine'),
      ],
    );
  }
}

class _ModuleTabs extends StatelessWidget {
  const _ModuleTabs({
    required this.modules,
    required this.activeModule,
    required this.onSelect,
  });

  final List<String> modules;
  final String activeModule;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final module in modules)
          ChoiceChip(
            selected: module == activeModule,
            label: Text(module.replaceAll('_', ' ')),
            onSelected: (_) => onSelect(module),
          ),
      ],
    );
  }
}

class _CodeEditorMonacoError extends StatelessWidget {
  const _CodeEditorMonacoError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: colorScheme.error,
              ),
              const SizedBox(height: 10),
              const Text(
                'Monaco failed to initialize on Windows',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.error),
              ),
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonacoInAppWindowsWebViewController
    implements monaco_platform.PlatformWebViewController {
  _MonacoInAppWindowsWebViewController({int readyTimeoutMs = 45000})
    : _readyTimeout = Duration(
        milliseconds: readyTimeoutMs.clamp(5000, 180000),
      ) {
    _widget = ValueListenableBuilder<WebviewValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        if (!value.isInitialized) {
          return const SizedBox.shrink();
        }
        return Webview(_controller);
      },
    );
  }

  late final Widget _widget;
  final WebviewController _controller = WebviewController();
  StreamSubscription<LoadingState>? _loadingStateSub;
  StreamSubscription<dynamic>? _messageSub;
  Completer<void>? _initializeCompleter;
  final Map<String, void Function(String)> _channels =
      <String, void Function(String)>{};
  final Set<String> _boundChannels = <String>{};
  final List<String> _pendingScripts = <String>[];
  final Duration _readyTimeout;
  final Map<String, Completer<Object?>> _pendingJsResults =
      <String, Completer<Object?>>{};
  int _jsRequestSerial = 0;
  String? _pendingHtmlPath;
  String? _pendingCustomCss;
  bool _pendingAllowCdnFonts = false;

  bool _initialized = false;
  bool _disposed = false;
  bool _loading = false;
  bool _loadRequested = false;
  bool _javascriptEnabled = true;
  bool _readySignaled = false;
  Completer<void> _readyCompleter = Completer<void>();
  VoidCallback? onMonacoReady;

  @override
  Widget get widget => _widget;

  static String _escapeForSingleQuoteJs(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r');
  }

  static String _toMessageString(Object? payload) {
    if (payload == null) return '';
    if (payload is String) return payload;
    try {
      return jsonEncode(payload);
    } catch (_) {
      return payload.toString();
    }
  }

  void _maybeSignalMonacoReady(Object? payload) {
    if (_readySignaled) return;
    String? event;
    if (payload is Map) {
      event = payload['event']?.toString();
    } else if (payload is String) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map) {
          event = decoded['event']?.toString();
        }
      } catch (_) {}
    }
    if (event == 'onEditorReady') {
      _readySignaled = true;
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
      unawaited(_flushPendingScripts());
      onMonacoReady?.call();
    }
  }

  void _bindSubscriptions() {
    _loadingStateSub ??= _controller.loadingState.listen((state) {
      if (state == LoadingState.navigationCompleted) {
        unawaited(_injectChannelObjects());
      }
    });
    _messageSub ??= _controller.webMessage.listen(_handleWebMessage);
  }

  void _handleWebMessage(dynamic message) {
    Object? payload = message;
    if (message is String) {
      try {
        payload = jsonDecode(message);
      } catch (_) {
        payload = message;
      }
    }
    if (payload is Map) {
      final replyId = payload['__monaco_reply__']?.toString();
      if (replyId != null) {
        final completer = _pendingJsResults.remove(replyId);
        if (completer != null && !completer.isCompleted) {
          final error = payload['error'];
          if (error != null) {
            completer.completeError(StateError(error.toString()));
          } else {
            completer.complete(payload['result']);
          }
        }
        return;
      }
      final channel = payload['channel']?.toString();
      if (channel != null) {
        final handler = _channels[channel];
        if (handler != null) {
          final channelPayload = payload['payload'];
          _maybeSignalMonacoReady(channelPayload);
          handler(_toMessageString(channelPayload));
        }
      }
    }
  }

  void _bindChannel(String name, void Function(String) onMessage) {
    if (_boundChannels.contains(name)) return;
    _boundChannels.add(name);
  }

  Future<void> _ensureChannelObject(String name) async {
    final escaped = _escapeForSingleQuoteJs(name);
    await _controller.executeScript(
      '''
if (typeof window['$escaped'] === 'undefined') {
  window['$escaped'] = {
    postMessage: function(message) {
      try {
        if (typeof message !== 'string') {
          message = JSON.stringify(message);
        }
        if (window.chrome && window.chrome.webview && window.chrome.webview.postMessage) {
          window.chrome.webview.postMessage(JSON.stringify({
            channel: '$escaped',
            payload: message
          }));
        }
      } catch (_) {}
    }
  };
}
''',
    );
  }

  Future<void> _injectChannelObjects() async {
    for (final name in _channels.keys) {
      try {
        await _ensureChannelObject(name);
      } catch (_) {}
    }
  }

  Future<void> _flushPendingScripts() async {
    if (!_readySignaled || _pendingScripts.isEmpty) return;
    final scripts = List<String>.from(_pendingScripts);
    _pendingScripts.clear();
    for (final script in scripts) {
      try {
        await _controller.executeScript(script);
      } catch (_) {}
    }
  }

  Future<void> _flushPendingLoad() async {
    if (_loading || _disposed) return;
    final htmlPath = _pendingHtmlPath;
    if (htmlPath == null || htmlPath.isEmpty) return;

    _loading = true;
    _readySignaled = false;
    if (_readyCompleter.isCompleted) {
      _readyCompleter = Completer<void>();
    }
    try {
      await _controller.loadUrl(Uri.file(htmlPath, windows: true).toString());
    } finally {
      _loading = false;
    }
  }

  Future<void> _ensureLoadRequested() async {
    if (_loadRequested || _disposed) return;
    await load(
      customCss: _pendingCustomCss,
      allowCdnFonts: _pendingAllowCdnFonts,
    );
  }

  Future<void> _waitForMonacoReady() async {
    if (_readySignaled) return;
    await _readyCompleter.future.timeout(
      _readyTimeout,
      onTimeout: () {
        throw StateError(
          'Monaco InApp editor did not report ready in '
          '${_readyTimeout.inMilliseconds}ms.',
        );
      },
    );
  }

  String _channelBootstrapScript() {
    if (_channels.isEmpty) return '';
    final script = StringBuffer('<script>(function(){');
    for (final name in _channels.keys) {
      final escaped = _escapeForSingleQuoteJs(name);
      script.write(
        "window['$escaped']=window['$escaped']||{postMessage:function(message){try{if(typeof message!=='string'){message=JSON.stringify(message);}if(window.chrome&&window.chrome.webview&&window.chrome.webview.postMessage){window.chrome.webview.postMessage(JSON.stringify({channel:'$escaped',payload:message}));}}catch(_){}}};",
      );
    }
    script.write('})();</script>');
    return script.toString();
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'Monaco InApp controller requires Windows runtime.',
      );
    }
    await _ensureInitialized();
    _initialized = true;
  }

  @override
  Future<void> enableJavaScript() async {
    _javascriptEnabled = true;
  }

  @override
  Future<Object?> runJavaScript(String script) async {
    if (!_javascriptEnabled) return null;
    await _ensureLoadRequested();
    if (!_readySignaled) {
      _pendingScripts.add(script);
      return null;
    }
    await _controller.executeScript(script);
    return null;
  }

  @override
  Future<Object?> runJavaScriptReturningResult(String script) async {
    if (!_javascriptEnabled) return null;
    await _ensureLoadRequested();
    await _waitForMonacoReady();
    return _evaluateScriptWithResult(script);
  }

  @override
  Future<Object?> addJavaScriptChannel(
    String name,
    void Function(String) onMessage,
  ) async {
    _channels[name] = onMessage;
    _bindChannel(name, onMessage);
    await _ensureLoadRequested();
    return null;
  }

  @override
  Future<Object?> removeJavaScriptChannel(String name) async {
    _channels.remove(name);
    _boundChannels.remove(name);
    final escaped = _escapeForSingleQuoteJs(name);
    await _controller.executeScript(
      "try { delete window['$escaped']; } catch (_) {}",
    );
    return null;
  }

  @override
  Future<void> load({String? customCss, bool allowCdnFonts = false}) async {
    await initialize();
    _loadRequested = true;
    _pendingCustomCss = customCss;
    _pendingAllowCdnFonts = allowCdnFonts;
    final cacheKey = Object.hash(customCss, allowCdnFonts, 'windows_inapp');
    final htmlPath = await monaco.MonacoAssets.indexHtmlPath(
      cacheKey: cacheKey,
    );
    final htmlFile = File(htmlPath);
    final vsPath = Uri.file(
      '${htmlFile.parent.path}\\min\\vs',
      windows: true,
    ).toString();

    var html = monaco.MonacoAssets.generateIndexHtml(
      vsPath,
      isWindows: false,
      isIosOrMacOS: false,
      customCss: customCss,
      allowCdnFonts: allowCdnFonts,
    );
    final bootstrap = _channelBootstrapScript();
    if (bootstrap.isNotEmpty) {
      html = html.replaceFirst('<head>', '<head>$bootstrap');
    }

    await htmlFile.writeAsString(html);
    _pendingHtmlPath = htmlPath;
    await _flushPendingLoad();
  }

  @override
  Future<void> setBackgroundColor(Color color) async {
    final alpha = color.a.clamp(0.0, 1.0).toStringAsFixed(3);
    final red = (color.r * 255.0).round().clamp(0, 255);
    final green = (color.g * 255.0).round().clamp(0, 255);
    final blue = (color.b * 255.0).round().clamp(0, 255);
    final script =
        '''
const _color = 'rgba($red, $green, $blue, $alpha)';
try {
  document.documentElement.style.background = _color;
  if (document.body) document.body.style.background = _color;
} catch (_) {}
''';
    if (!_readySignaled) {
      _pendingScripts.add(script);
      return;
    }
    await _controller.executeScript(script);
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _loadingStateSub?.cancel();
    _messageSub?.cancel();
    _loadingStateSub = null;
    _messageSub = null;
    _channels.clear();
    _boundChannels.clear();
    _pendingScripts.clear();
    _pendingHtmlPath = null;
    _pendingJsResults.clear();
    // ignore: discarded_futures
    _controller.dispose();
  }

  Future<void> _ensureInitialized() async {
    if (_controller.value.isInitialized) {
      _bindSubscriptions();
      return;
    }
    final completer = _initializeCompleter;
    if (completer != null) {
      return completer.future;
    }
    final nextCompleter = Completer<void>();
    _initializeCompleter = nextCompleter;
    try {
      await _controller.initialize().timeout(_readyTimeout);
      _bindSubscriptions();
      nextCompleter.complete();
    } catch (error, stackTrace) {
      nextCompleter.completeError(error, stackTrace);
      rethrow;
    } finally {
      _initializeCompleter = null;
    }
  }

  Future<Object?> _evaluateScriptWithResult(String script) async {
    final requestId = (++_jsRequestSerial).toString();
    final escapedId = _escapeForSingleQuoteJs(requestId);
    final completer = Completer<Object?>();
    _pendingJsResults[requestId] = completer;
    final wrappedScript =
        '''
(function(){
  let result;
  try {
    result = (function(){ $script })();
  } catch (e) {
    if (window.chrome && window.chrome.webview && window.chrome.webview.postMessage) {
      window.chrome.webview.postMessage(JSON.stringify({"__monaco_reply__":"$escapedId","error":String(e)}));
    }
    return;
  }
  try {
    if (typeof result === 'undefined') {
      result = null;
    }
    if (window.chrome && window.chrome.webview && window.chrome.webview.postMessage) {
      window.chrome.webview.postMessage(JSON.stringify({"__monaco_reply__":"$escapedId","result":result}));
    }
  } catch (e) {
    if (window.chrome && window.chrome.webview && window.chrome.webview.postMessage) {
      window.chrome.webview.postMessage(JSON.stringify({"__monaco_reply__":"$escapedId","error":String(e)}));
    }
  }
})();
''';
    await _controller.executeScript(wrappedScript);
    try {
      return await completer.future.timeout(
        _readyTimeout,
        onTimeout: () {
          throw StateError(
            'Monaco WebView did not return a script result in '
            '${_readyTimeout.inMilliseconds}ms.',
          );
        },
      );
    } finally {
      _pendingJsResults.remove(requestId);
    }
  }
}

Widget buildCodeEditorControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final value = (props['value'] ?? props['text'] ?? props['code'] ?? '')
      .toString();
  final fontSize = coerceDouble(props['font_size']) ?? 13;
  final fontFamily = props['font_family']?.toString() ?? 'JetBrains Mono';
  final backgroundColor =
      coerceColor(
        props['editor_bg'] ?? props['editor_background'] ?? props['bgcolor'],
      ) ??
      const Color(0xff0b1220);
  final textColor =
      coerceColor(props['editor_text_color'] ?? props['text_color']) ??
      const Color(0xffdbeafe);
  final borderColor =
      coerceColor(props['border_color']) ?? const Color(0xff334155);
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final radius = coerceDouble(props['radius']) ?? 10.0;

  return ButterflyUICodeEditor(
    controlId: controlId,
    rawChildren: rawChildren,
    buildChild: buildChild,
    value: value,
    language: props['language']?.toString(),
    theme: props['theme']?.toString(),
    engine: (props['engine'] ?? 'monaco').toString(),
    webviewEngine: (props['webview_engine'] ?? 'windows_inapp').toString(),
    readOnly: props['read_only'] == true,
    autofocus: props['auto_focus'] == true || props['autofocus'] == true,
    wordWrap: props['word_wrap'] == true || props['wrap'] == true,
    showLineNumbers: props['line_numbers'] == null
        ? true
        : (props['line_numbers'] == true),
    showGutter: props['show_gutter'] == null
        ? true
        : (props['show_gutter'] == true),
    showMinimap: props['show_minimap'] == true || props['minimap'] == true,
    glyphMargin:
        props['glyph_margin'] == true || props['show_breakpoints'] == true,
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 180).clamp(0, 2000),
    tabSize: (coerceOptionalInt(props['tab_size']) ?? 2).clamp(1, 12),
    documentUri: props['document_uri']?.toString(),
    fontSize: fontSize,
    fontFamily: fontFamily,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
