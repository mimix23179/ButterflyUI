from __future__ import annotations

from .combo_box import ComboBox

__all__ = ["Combobox"]


class Combobox(ComboBox):
    """Alias for :class:`ComboBox` using ``control_type='combobox'``."""

    control_type = "combobox"

