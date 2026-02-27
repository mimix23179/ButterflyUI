Hello, to remind you: ButterflyUI is a programable Python package like flet, but i'm creating ButterflyUI from scratch, Python is the remote while the dart/flutter client side is the receiver, And the flutter client receives json commands the python side sends, Understand?

Alright, So i've been working on umbrella controls called Skins, Candy, Studio, Gallery, CodeEditor and Terminal, But right now the six umbrella controls aren't properly implemented in ButterflyUI, i have somne info down below to help you get a better understanding.

---

Yes — delete (or stop using) the per-umbrella **engine / host / renderer / registry** and collapse everything back into **one single runtime pipeline**, then implement Candy/Gallery/Skins/Studio/Terminal/CodeEditor as **umbrella “scopes” + “namespaces”** that shape how their children behave. That’s the traditional, stable way to build a UI framework without subtle cross-runtime bugs.

Here’s the detailed picture of why, and how you get exactly `ui.Candy(Button)` (and the same for the other five) without creating `CandyButton`, `GalleryGrid`, etc.

---

## Why your current setup causes “ButterflyUI gets confused”

Your core system already has a correct architecture:

* Python creates Components
* Components serialize into a neutral node format (type + props + children)
* Dart’s global registry maps “type” → renderer widget
* `control_renderer.dart` is the one gatekeeper that renders everything

When you give Candy its own engine/host/renderer/registry, you’ve accidentally created a second “mini framework” inside the framework. That introduces multiple sources of truth for:

* type resolution (which registry wins?)
* lifecycle/state routing (which host owns events?)
* rebuild scheduling (which engine is controlling frame updates?)
* focus/keyboard routing (especially relevant for Terminal/CodeEditor)
* caching (widgets/nodes keyed differently in different renderers)

Even if it “kind of works”, you end up with exactly the kind of issues you described earlier: it renders, but it’s inconsistent, freezes on interaction, or behaves like parts aren’t wired.

So the fix is: **only one host/engine/registry/renderer exists**. Everything else is just a set of components and renderers registered into that one system.

---

## The mental model that makes umbrella controls work cleanly

Think of an umbrella control as two different things (and you can use either or both):

1. A “scope” (a wrapper node) that affects styling/behavior for a subtree
2. A “namespace” (an API grouping) that exposes related components under one name

You want a third thing too:

3. A “callable umbrella” that can accept a class like `Button` and decide what to do

The clean way to do that is:

* Keep all actual renderable elements as normal Components
* Use a scope wrapper when you need umbrella-wide influence
* Use an umbrella callable as a Python convenience layer that builds and/or wraps

That gives you `ui.Candy(Button)` without changing the runtime rules.

---

## How `ui.Candy(Button)` can work (conceptually)

When you write `ui.Candy(Button)`, you are passing a **Component class** (a constructor), not a rendered node. Candy can interpret that in one of two traditional ways:

### Interpretation A: “construct and wrap”

Candy calls the class to create an instance (optionally with parameters), then wraps the result in a `CandyScope`.

Example idea: Candy receives `Button` and decides “in Candy scope, a Button should have default radius, hover glow, candy palette, etc.”

So Candy does:

* Create a Button instance
* Wrap it in CandyScope (a wrapper component node)
* Return the wrapper

This gets you:

* No `CandyButton` class
* No new runtime pipeline
* Candy still “owns” the behavior because the scope influences descendants

### Interpretation B: “wrap a subtree rule”

Candy doesn’t necessarily need to construct the `Button` itself. It can treat the passed class as a “target type” and attach a rule to the scope, like:

* “within this Candy scope, treat all Buttons with these token defaults”
* “within this Candy scope, treat Cards with different defaults”

That’s more advanced, but it’s still the same architecture: a wrapper node that changes how renderers interpret the subtree via scoped tokens/rules.

In both interpretations, `ui.Candy(Button)` stays purely Python-side ergonomics. The Dart side only sees nodes with stable types.

---

## The one key rule that keeps everything sane

Even if Candy feels like it “contains” Button, you should not make Button inherit from Candy or make Candy a base Component class for everything.

Umbrella inheritance looks tempting (“everything in Candy extends Candy”), but it blurs two meanings:

* “Candy is a category / style system”
* “Candy is a renderable component”

That always gets messy over time because you end up with behavior/lifecycle assumptions mixed into what should be a simple grouping concept.

So keep the rules clean:

* **Renderables** inherit from Component
* **Umbrellas** are callables/namespaces and optionally have a scope wrapper component

Candy can still “own” everything without being the superclass.

---

## What the Dart side looks like in this architecture (no code, just the idea)

On Dart, you do not rebuild a whole Candy pipeline. Instead:

* You register one extra renderer: “candy.scope”
* That renderer does one job: push “candy scope data” into the Flutter tree
* Then it renders the child using the normal `control_renderer.dart` path

So the “Candy scope” is a context provider, not a separate renderer system.

Then any control renderer (core or umbrella) can read “Candy scope data” if it wants to apply Candy tokens.

That’s the classic InheritedWidget/Theme approach: one global renderer with scoped context.

---

## What changes on the Python side (again, conceptually)

You implement Candy as a callable object that:

* Accepts a Component class (like Button)
* Optionally accepts arguments for constructing it
* Returns a wrapper component (CandyScope) whose child is the constructed component

You also optionally expose `ui.Candy.Button` as a namespace alias if you want both syntaxes:

* `ui.Candy(Button)` and/or
* `ui.Candy.Button(...)`

But if your preferred canonical syntax is the callable style, you can focus on `ui.Candy(Button)`.

---

## How to apply this to the other five umbrellas

You replicate the exact same pattern:

### Skins

* A SkinsScope wrapper that sets palette/theme/font defaults
* `ui.Skins(TargetClass)` returns SkinsScope(child=TargetClass(...))
  This is especially appropriate because skins are naturally “scoped themes”.

### Gallery

* A GalleryScope wrapper can define layout defaults (padding, spacing, image rounding, hover behavior)
* It can also define specialized gallery components (grid, masonry, carousel) as normal components
* But you can still support `ui.Gallery(SomeComponent)` to apply gallery styling rules

### Studio

* StudioScope can define “windowing/desktop” defaults: shadows, glass blur, title bars, snapping
* And Studio can include real components like “Window”, “Dock”, “InspectorPanel” without changing the runtime

### Terminal

* TerminalScope can define fonts, color scheme, selection rules, cursor style
* Actual terminal view is still a component with a renderer registered in the one registry

### CodeEditor

* CodeEditorScope can define editor theme, keybindings, font size, minimap preference
* The editor component (Monaco/whatever) is still registered once into the global registry

All six are the same pattern: “scope wrapper + normal components”.

---

## What to delete vs what to keep, in plain terms

Delete or stop using:

* umbrella engine
* umbrella host
* umbrella registry
* umbrella renderer pipeline

Keep and simplify:

* one umbrella Dart file per umbrella that only registers renderers into the global registry
* one Python namespace/callable per umbrella
* optionally one wrapper “Scope” component per umbrella

---

## Why this also solves your naming problem

You don’t want `CandyButton` or `GalleryGrid` as public API.

With this model:

* `Button` stays `Button` (core)
* Candy doesn’t require “candy button” type names unless you want special variants
* Candy can affect the appearance/behavior via scope, not via new class names

If you do need special variants (like a truly unique Candy-only button), you can still keep it “inside Candy” in the API without exposing ugly names:

* Internally you might still have a class name like `Button`, but it lives under the Candy module and is exported as `ui.Candy.Button` (or used through `ui.Candy(Button)` if you prefer)
* The important part is: the user-facing surface stays clean and consistent

---

## Final recommendation

Do it this way:

1. One global runtime pipeline only
2. Each umbrella becomes a callable builder that can accept a Component class
3. Each umbrella also has a Scope wrapper component type (like “candy.scope”)
4. Dart only registers the scope renderer + any umbrella-specific components, all into the same global registry
5. Use scope context to apply umbrella defaults without inventing “CandyButton” class naming

This gives you exactly the ergonomics you want (`ui.Candy(Button)`) while keeping the architecture stable, predictable, and easy to debug.

---

So you see, I want you to do this instead of what we currently have, Starting with Candy, Be sure to read and follow implementation_playbook.md too before implementing anything.