library terminal_submodule_registry;

// ---------------------------------------------------------------------------
// Module sets per category
// ---------------------------------------------------------------------------

/// Modules that render output / display content in the terminal viewport.
const Set<String> terminalViewModules_ = {
  'workbench',
  'view',
  'stream_view',
  'raw_view',
  'timeline',
  'progress_view',
  'log_viewer',
  'log_panel',
  'replay',
  'stream',
  'progress',
};

/// Modules that handle user input, commands, sessions, and flow control.
const Set<String> terminalInputModules_ = {
  'prompt',
  'stdin',
  'stdin_injector',
  'command_builder',
  'flow_gate',
  'presets',
  'execution_lane',
  'tabs',
  'session',
};

/// Modules that bridge the terminal to backend processes and data providers.
const Set<String> terminalProviderModules_ = {
  'process_bridge',
  'output_mapper',
  'capabilities',
};

// ---------------------------------------------------------------------------
// Explicit category map
// ---------------------------------------------------------------------------

/// Maps every registered terminal module token to its category name.
const Map<String, String> terminalModuleCategories = {
  // views
  'workbench': 'views',
  'view': 'views',
  'stream_view': 'views',
  'raw_view': 'views',
  'timeline': 'views',
  'progress_view': 'views',
  'log_viewer': 'views',
  'log_panel': 'views',
  'replay': 'views',
  'stream': 'views',
  'progress': 'views',
  // inputs
  'prompt': 'inputs',
  'stdin': 'inputs',
  'stdin_injector': 'inputs',
  'command_builder': 'inputs',
  'flow_gate': 'inputs',
  'presets': 'inputs',
  'execution_lane': 'inputs',
  'tabs': 'inputs',
  'session': 'inputs',
  // providers
  'process_bridge': 'providers',
  'output_mapper': 'providers',
  'capabilities': 'providers',
};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns the category name for [module], or `null` if not recognised.
String? terminalModuleCategory(String module) =>
    terminalModuleCategories[module];

/// Returns `true` when [module] belongs to the *views* category.
bool terminalIsViewModule(String module) =>
    terminalViewModules_.contains(module);

/// Returns `true` when [module] belongs to the *inputs* category.
bool terminalIsInputModule(String module) =>
    terminalInputModules_.contains(module);

/// Returns `true` when [module] belongs to the *providers* category.
bool terminalIsProviderModule(String module) =>
    terminalProviderModules_.contains(module);
