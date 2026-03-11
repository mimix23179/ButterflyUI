# ButterflyUI Styling Docs

This folder documents the public Styling engine that powers modern ButterflyUI
surfaces, text, inputs, scenes, and Genesis Studio.

Start here:

- [styling.md](./styling.md): the Styling mental model, cascade order, selectors, utility classes, and local `Style(...)`
- [tokens.md](./tokens.md): token authoring, `:root` overrides, and `var(...)` / `token(...)` references
- [scenes.md](./scenes.md): authored scene layers such as `ParticleField`, `GradientWash`, `OrbitField`, and `ShaderLayer`
- [genesis_fixture.md](./genesis_fixture.md): how Genesis Studio uses Styling as a full application fixture
- [styling_matrix.md](./styling_matrix.md): current completion matrix for the Styling engine
- [landing_page.md](./landing_page.md): landing-page example notes
- [dashboard.md](./dashboard.md): dashboard example notes
- [glass_ui.md](./glass_ui.md): glass-surface example notes
- [dense_desktop_tool.md](./dense_desktop_tool.md): dense desktop tool example notes

The Styling system is intentionally **CSS-like, Flutter-native**:

- write normal ButterflyUI controls
- attach `class_name`
- add stylesheet rules
- use local `Style(...)` only for targeted overrides
- author background and foreground scene layers directly from Python

The runtime resolves Styling in this order:

1. tokens/theme
2. control defaults
3. stylesheet selectors
4. utility classes
5. local `Style(...)`
6. local state overrides
7. runtime interaction state
