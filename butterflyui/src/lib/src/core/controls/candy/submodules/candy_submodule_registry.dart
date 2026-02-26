library candy_submodule_registry;

const Set<String> candyLayoutModules = {
  'align',
  'aspect_ratio',
  'card',
  'center',
  'column',
  'container',
  'fitted_box',
  'overflow_box',
  'row',
  'spacer',
  'stack',
  'surface',
  'wrap',
};

const Set<String> candyInteractiveModules = {
  'avatar',
  'badge',
  'button',
  'icon',
  'text',
};

const Set<String> candyDecorationModules = {
  'border',
  'clip',
  'decorated_box',
  'gradient',
  'outline',
  'shadow',
};

const Set<String> candyEffectsModules = {
  'canvas',
  'effects',
  'particles',
};

const Set<String> candyMotionModules = {
  'animation',
  'motion',
  'transition',
};

const Map<String, String> candyModuleCategories = {
  'align': 'layout',
  'aspect_ratio': 'layout',
  'card': 'layout',
  'center': 'layout',
  'column': 'layout',
  'container': 'layout',
  'fitted_box': 'layout',
  'overflow_box': 'layout',
  'row': 'layout',
  'spacer': 'layout',
  'stack': 'layout',
  'surface': 'layout',
  'wrap': 'layout',
  'avatar': 'interactive',
  'badge': 'interactive',
  'button': 'interactive',
  'icon': 'interactive',
  'text': 'interactive',
  'border': 'decoration',
  'clip': 'decoration',
  'decorated_box': 'decoration',
  'gradient': 'decoration',
  'outline': 'decoration',
  'shadow': 'decoration',
  'canvas': 'effects',
  'effects': 'effects',
  'particles': 'effects',
  'animation': 'motion',
  'motion': 'motion',
  'transition': 'motion',
};

String? candyModuleCategory(String module) =>
    candyModuleCategories[module.trim().toLowerCase().replaceAll('-', '_')];

bool candyIsLayoutModule(String module) => candyLayoutModules.contains(module);
bool candyIsInteractiveModule(String module) => candyInteractiveModules.contains(module);
bool candyIsDecorationModule(String module) => candyDecorationModules.contains(module);
bool candyIsEffectsModule(String module) => candyEffectsModules.contains(module);
bool candyIsMotionModule(String module) => candyMotionModules.contains(module);
