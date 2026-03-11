from __future__ import annotations

import argparse
import sys
from pathlib import Path


def _ensure_local_sdk_on_path() -> Path:
    root = Path(__file__).resolve().parents[3]
    src = root / "src"
    src_str = str(src)
    if src_str not in sys.path:
        sys.path.insert(0, src_str)
    return root


_ensure_local_sdk_on_path()

from butterflyui.examples.stylesheet import build_page  # noqa: E402
import butterflyui as bui  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run the ButterflyUI Styling landing-page example."
    )
    parser.add_argument(
        "--target",
        choices=("desktop", "web"),
        default="desktop",
        help="Runtime target.",
    )
    args = parser.parse_args()

    if args.target == "web":
        bui.run_web(build_page)
        return
    bui.run_desktop(build_page)


if __name__ == "__main__":
    main()
