# Candy Scene Engine Checklist

This checklist tracks the first real Candy scene-engine pass for ButterflyUI.
The goal is to make `Candy` a Flutter-native visual enhancement system for
existing controls, not a generic wrapper.

## Foundation

- [x] Keep `Candy` as the main user-facing control.
- [x] Split the Python Candy package into focused modules for helpers, tokens,
  style packs, reusable specs, and scene data.
- [x] Add a native Candy scene model that can describe background and overlay
  layers.
- [x] Add painter-based Candy backgrounds for matrix rain, starfield, nebula,
  and rain.
- [x] Wire semantic Candy presets into the scene registry so presets can expand
  into real visual layers.
- [x] Keep Lottie and Rive scene layers working alongside the new native scene
  layers.
- [x] Extend the Python schema/runtime hints for Candy scene-layer props.
- [x] Add runtime coverage for the new Candy scene foundations.

## Next

- [ ] Add shader-based Candy scenes for galaxy, flowing water, and fog fields.
- [ ] Add a Candy quality governor and reduced-motion fallback path.
- [ ] Expand Candy actor bridging for richer Rive state-machine input.
