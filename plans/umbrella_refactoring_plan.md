# ButterflyUI Umbrella Controls Refactoring Plan

## Overview

This document outlines the refactoring of ButterflyUI's umbrella controls (Candy, Gallery, Skins, Studio, Terminal, CodeEditor) from the current multi-runtime architecture to a unified single-runtime pipeline with scope-based behavior.

## Problem Statement

The current architecture has separate engine/host/renderer/registry for each umbrella control, causing:
- Multiple sources of truth for type resolution
- Conflicting lifecycle/state routing
- Inconsistent rebuild scheduling
- Focus/keyboard routing issues
- Different caching mechanisms per umbrella

## Target Architecture

### Core Principles
1. **Single Global Runtime Pipeline**: One host, one engine, one registry, one renderer
2. **Scope Wrapper Pattern**: Each umbrella becomes a scope wrapper component
3. **Callable Namespace Pattern**: Umbrellas accept Component classes and wrap them
4. **No New Type Names**: `ui.Candy(Button)` works without `CandyButton`

### Architecture Diagram

```mermaid
graph TB
    subgraph Python_SDK
        UI[ui.Candy, ui.Gallery, etc.]
        Components[Core Components<br/>Button, Card, Column...]
        UmbrellaCallable[Umbrella Callable<br/>Candy(Button)]
        ScopeWrapper[Scope Wrapper<br/>CandyScope]
    end
    
    subgraph JSON_Serialization
        JSON[JSON Payload]
    end
    
    subgraph Dart_Runtime
        Registry[Global Registry]
        Renderer[Global Renderer]
        ScopeRenderer[Scope Renderers<br/>candy_scope, gallery_scope...]
        Context[Scope Context<br/>InheritedWidget]
    end
    
    UI --> UmbrellaCallable
    Components --> UmbrellaCallable
    UmbrellaCallable --> ScopeWrapper
    ScopeWrapper --> JSON
    JSON --> Registry
    Registry --> Renderer
    Renderer --> ScopeRenderer
    ScopeRenderer --> Context
```

## Implementation Details

### 1. Scope Wrapper Components

Each umbrella will have a scope wrapper component:

| Umbrella | Scope Component | Purpose |
|----------|-----------------|---------|
| Candy | `CandyScope` | Candy tokens, theme, colors, typography, radius |
| Gallery | `GalleryScope` | Layout defaults, spacing, image rounding, hover behavior |
| Skins | `SkinsScope` | Palette, theme, fonts, skin tokens |
| Studio | `StudioScope` | Windowing/desktop defaults, shadows, glass blur |
| Terminal | `TerminalScope` | Font, color scheme, cursor style, selection rules |
| CodeEditor | `CodeEditorScope` | Editor theme, keybindings, font size, minimap |

### 2. Callable Umbrella Pattern

The umbrella callable accepts a Component class and wraps it:

```python
class Candy:
    """Candy umbrella control - applies candy styling to child components."""
    
    def __init__(self, *args, **kwargs):
        # Existing implementation
        pass
    
    def __call__(self, component_class, *args, **kwargs):
        """
        Wrap a component class in a CandyScope.
        
        Example: ui.Candy(Button) -> CandyScope(child=Button(...))
        """
        # Create instance of the component class
        component = component_class(*args, **kwargs)
        
        # Wrap in CandyScope
        return CandyScope(child=component)
```

### 3. API Surface

After refactoring, the following APIs will work:

```python
import butterflyui as ui

# Existing API (still works)
ui.Candy.Button(...)
ui.Candy.Card(...)

# New callable API
ui.Candy(Button)  # Wraps Button in CandyScope
ui.Candy(Button, variant="primary")
ui.Gallery(Image)
ui.Skins(Text)
ui.Studio(Container)
ui.Terminal(View)
ui.CodeEditor(EditorSurface)

# Scope-only (no child wrapping)
ui.CandyScope(...)
ui.GalleryScope(...)
```

## Implementation Steps

### Phase 1: Core Infrastructure

1. **Create base Scope component class**
   - Location: `butterflyui/controls/_shared.py`
   - Properties: umbrella_type, tokens, theme, child

2. **Create Scope wrapper components**
   - `CandyScope` in `butterflyui/controls/candy/scope.py`
   - `GalleryScope` in `butterflyui/controls/gallery/scope.py`
   - `SkinsScope` in `butterflyui/controls/skins/scope.py`
   - `StudioScope` in `butterflyui/controls/studio/scope.py`
   - `TerminalScope` in `butterflyui/controls/terminal/scope.py`
   - `CodeEditorScope` in `butterflyui/controls/code_editor/scope.py`

### Phase 2: Refactor Each Umbrella

#### Candy (Priority 1)
1. Add `__call__` method to Candy class
2. Create CandyScope component
3. Implement `Candy(Button)` pattern
4. Keep existing submodule components as-is
5. Update exports

#### Gallery, Skins, Studio, Terminal, CodeEditor
Follow same pattern as Candy:
1. Add `__call__` method
2. Create respective Scope component
3. Implement wrapper pattern
4. Update exports

### Phase 3: Cleanup

1. Remove or deprecate legacy umbrella runtime code
2. Update documentation
3. Ensure backward compatibility

## File Changes Summary

### New Files to Create
- `butterflyui/controls/candy/scope.py` - CandyScope component
- `butterflyui/controls/gallery/scope.py` - GalleryScope component
- `butterflyui/controls/skins/scope.py` - SkinsScope component
- `butterflyui/controls/studio/scope.py` - StudioScope component
- `butterflyui/controls/terminal/scope.py` - TerminalScope component
- `butterflyui/controls/code_editor/scope.py` - CodeEditorScope component

### Files to Modify
- `butterflyui/controls/candy/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/gallery/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/skins/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/studio/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/terminal/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/code_editor/__init__.py` - Add scope exports, add __call__
- `butterflyui/controls/__init__.py` - Update umbrella exports

### Files to Deprecate (Phase 3)
- `butterflyui/controls/_umbrella_runtime.py` - Core runtime (keep but mark deprecated)
- `butterflyui/controls/_umbrella_family.py` - Family builder (keep but mark deprecated)
- `butterflyui/controls/_umbrella_submodule.py` - Submodule builder (keep but mark deprecated)

## Scope Component Schema

### CandyScope
```python
class CandyScope(Control):
    control_type = "candy_scope"
    
    def __init__(
        self,
        *children,
        tokens: dict = None,        # Candy design tokens
        theme: dict = None,         # Theme configuration
        brightness: str = "light", # light/dark
        radius: dict = None,        # Border radius tokens
        colors: dict = None,        # Color overrides
        child: Control = None,      # Single child to wrap
        **kwargs
    ):
```

### GalleryScope
```python
class GalleryScope(Control):
    control_type = "gallery_scope"
    
    def __init__(
        self,
        *children,
        layout: dict = None,        # Layout defaults
        spacing: int = None,        # Default spacing
        image_rounding: int = None, # Image border radius
        **kwargs
    ):
```

### SkinsScope
```python
class SkinsScope(Control):
    control_type = "skins_scope"
    
    def __init__(
        self,
        *children,
        palette: dict = None,       # Color palette
        fonts: dict = None,        # Font configuration
        theme: dict = None,        # Theme settings
        **kwargs
    ):
```

### StudioScope
```python
class StudioScope(Control):
    control_type = "studio_scope"
    
    def __init__(
        self,
        *children,
        window_style: dict = None,  # Window appearance
        shadows: bool = True,      # Enable shadows
        glass_blur: bool = False,  # Enable glass blur
        **kwargs
    ):
```

### TerminalScope
```python
class TerminalScope(Control):
    control_type = "terminal_scope"
    
    def __init__(
        self,
        *children,
        font_family: str = None,   # Terminal font
        font_size: int = None,     # Font size
        colors: dict = None,       # Color scheme
        cursor_style: str = None, # cursor style
        **kwargs
    ):
```

### CodeEditorScope
```python
class CodeEditorScope(Control):
    control_type = "code_editor_scope"
    
    def __init__(
        self,
        *children,
        theme: str = None,         # Editor theme
        font_size: int = None,     # Font size
        font_family: str = None,   # Font family
        minimap: bool = True,      # Show minimap
        **kwargs
    ):
```

## Backward Compatibility

The refactoring maintains full backward compatibility:
- All existing `ui.Candy.Button(...)` syntax continues to work
- All submodule components remain available
- Only new functionality is added (the callable pattern)

## Testing Strategy

1. **Unit Tests**: Test callable pattern with mock components
2. **Integration Tests**: Test scope inheritance with actual controls
3. **Serialization Tests**: Verify JSON output includes scope props
4. **Backward Compatibility Tests**: Ensure existing API still works

## Timeline

- Phase 1 (Core Infrastructure): Implementation
- Phase 2 (Candy): Implementation + Testing
- Phase 2 (Other Umbrellas): Implementation + Testing  
- Phase 3 (Cleanup): Implementation + Documentation

## Open Questions

1. Should scope components support multiple children or single child only?
2. Should scope tokens be validated against a schema?
3. How should nested scopes work (e.g., Candy inside Studio)?
