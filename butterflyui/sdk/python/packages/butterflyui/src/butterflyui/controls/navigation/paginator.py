from __future__ import annotations

from .pagination import Pagination

__all__ = ["Paginator"]


class Paginator(Pagination):
    """
    Legacy alias for :class:`Pagination`.

    ``Paginator`` is retained for backward compatibility and serializes as
    ``control_type="paginator"``. New code should prefer
    :class:`~butterflyui.controls.navigation.pagination.Pagination`.

    This class inherits all constructor parameters and invoke helpers from
    ``Pagination``:
    ``set_page()``, ``next_page()``, ``prev_page()``, ``first_page()``,
    ``last_page()``, ``get_state()``, and ``emit()``.

    ```python
    import butterflyui as bui

    pager = bui.Paginator(page=1, page_count=12, show_edges=True)
    ```

    Migration guidance:
    - Keep ``Paginator`` when you need wire compatibility with existing JSON
      payloads that use ``type="paginator"``.
    - Use ``Pagination`` for new code and docs, since it is the canonical
      public API name.
    """

    control_type = "paginator"
