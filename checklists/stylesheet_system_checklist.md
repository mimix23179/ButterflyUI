# ButterflyUI Stylesheet System Checklist

- [x] Remove public `Candy`, `Skins`, `Gallery`, `Style`, and `Modifier` control surfaces.
- [x] Stop exporting the public `effects` and `customization` control families from the Python SDK.
- [x] Add a Python stylesheet API with CSS-like selectors and declarations.
- [x] Add `Page.stylesheet` serialization from Python to the Flutter runtime.
- [x] Add Dart-side stylesheet models and selector matching for type, `#id`, `.class`, and `:state`.
- [x] Feed stylesheet rules into the existing Flutter style resolver instead of building a second renderer.
- [x] Support stylesheet declarations for direct visual props plus `background_effect`, `hover_effect`, and `effect`.
- [x] Re-enable shared `classes` props in the schema so selectors can target controls cleanly.
- [x] Add a runnable Python example for stylesheet-driven customization.
- [ ] Extend selectors with descendant/slot targeting.
- [ ] Add media-query-like responsive rules.
- [ ] Document the stylesheet grammar in the Python-end docs folder.
