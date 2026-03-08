Next is making the code obey the new docs in [README.md](G:/Projects/ButterflyUI/README.md), [authoring_model.md](G:/Projects/ButterflyUI/docs/authoring_model.md), and [control_contract.md](G:/Projects/ButterflyUI/docs/control_contract.md).

The right order is:

1. Canonical naming cleanup.
   Move duplicate names and aliases to compat-only and keep one public name for each concept. This is where `markdown_view` vs `markdown`, `file_picker` vs `filepicker`, `combo_box` variants, and similar pairs get cleaned up across Python, schema, and Dart.

2. Umbrella cleanup.
   Make `Candy`, `Skins`, and `Gallery` read and behave only as scopes/namespaces, not as shadow frameworks. Also remove stale public mentions of Studio, Terminal, and CodeEditor from remaining docs and exports.

3. Control contract enforcement.
   Go family by family and make every important control publish the same shape:
   summary, child model, slots, capabilities, variants, states, events, invokes, examples.
   Start with `layout`, `inputs`, `display`, `navigation`, and `overlay`.

4. Example-first docs.
   Add a small canonical demo set:
   basic app, themed app, scoped app, styled interactive app, gallery/media app.

5. Trustworthy completion tracking.
   Restore the completion matrix and tie it to real tests so “finished” actually means Python + schema + runtime + docs + demo + test.

If I were choosing the immediate next implementation step, I’d do `canonical naming cleanup` first. Until that is done, both users and LLMs will keep learning mixed names for the same ideas.