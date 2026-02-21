"""ButterflyUI Desktop — single-file installer + runner.

This package intentionally exposes a very small surface. To use it, edit
`RUNTIME_ZIP_URL` below and set it to the HTTPS address of your
`butterflyui-windows.zip` distribution. Optionally set `RUNTIME_ZIP_SHA256` to
the expected SHA256 hex string to enforce checksum verification.

Example usage:

    import conduit_desktop

    butterflyui_desktop.install(force=False)
    butterflyui_desktop.run(host_port='127.0.0.1:8765', wait=True)

Note: the runtime will be extracted into the `app/` directory inside this
installed package directory by default. Override via the
`BUTTERFLYUI_DESKTOP_RUNTIME_DIR` environment variable if you prefer a different
location. You can also override the download source via
`BUTTERFLYUI_DESKTOP_RUNTIME_URL` and checksum via `BUTTERFLYUI_DESKTOP_RUNTIME_SHA256`.
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import site
import tempfile
import time
import urllib.parse
import urllib.request
import zipfile
import subprocess
import sys
from pathlib import Path
from typing import Optional


# ----------------------------- CONFIGURATION -----------------------------
# Edit these constants to point at your published runtime zip and checksum.
# The package will refuse to download non-HTTPS URLs.
RUNTIME_ZIP_URL: str = "https://www.dropbox.com/scl/fi/umfxqx5jmx7610uzi47s3/butterflyui-windows.zip?rlkey=7pdctzo963exxs2nt7x93sjx0&st=7a3els41&dl=0"  # <-- set your URL
RUNTIME_ZIP_SHA256: str = ""  # optional: lowercase hex string

# Directory name inside the package where we install the runtime.
_RUNTIME_DIR_NAME = "app"


# ----------------------------- ERRORS -----------------------------------

class ConduitDesktopInstallError(RuntimeError):
    pass


class ConduitDesktopRunError(RuntimeError):
    pass


# ----------------------------- PATH HELPERS ------------------------------

def _get_package_dir() -> Path:
    return Path(__file__).resolve().parent


def _find_installed_package_dir() -> Optional[Path]:
    """Try to locate the installed conduit_desktop package directory.

    This prefers site-packages paths so development checkouts can still
    install/run the runtime from the locally installed package.
    """

    candidates: list[Path] = []
    try:
        candidates.extend(Path(p) for p in site.getsitepackages() if p)
    except Exception:
        pass
    try:
        user_site = site.getusersitepackages()
        if user_site:
            candidates.append(Path(user_site))
    except Exception:
        pass

    for root in candidates:
        pkg_dir = root / "conduit_desktop"
        if pkg_dir.is_dir() and (pkg_dir / "__init__.py").exists():
            return pkg_dir
    return None


def get_runtime_dir(*, use_env_runtime_dir: bool = True) -> Path:
    """Return the runtime directory.

    Resolution order:
    1. `CONDUIT_DESKTOP_RUNTIME_DIR` env var if set (when use_env_runtime_dir=True).
    2. Installed package directory if available (site-packages).
    3. Fallback to the current package's `app/` directory where the runtime is
       installed by `install()` (useful for source checkouts).
    """
    if use_env_runtime_dir:
        env = os.environ.get("CONDUIT_DESKTOP_RUNTIME_DIR", "").strip()
        if env:
            return Path(env)

    package_dir = _get_package_dir()
    installed_dir = _find_installed_package_dir()
    if installed_dir is not None and installed_dir.resolve() != package_dir.resolve():
        return installed_dir / _RUNTIME_DIR_NAME

    return package_dir / _RUNTIME_DIR_NAME


def _installed_info_path(runtime_dir: Path) -> Path:
    return runtime_dir / "installed.json"


# ----------------------------- DOWNLOAD & VERIFY -------------------------

def _require_https(url: str) -> None:
    parsed = urllib.parse.urlparse(url)
    if parsed.scheme.lower() != "https":
        raise ConduitDesktopInstallError("Runtime URL must use https://")


def _sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def _download_to_temp(url: str) -> Path:
    """Download the URL into a temp file and ensure it's a ZIP.

    If the URL points to a Dropbox share link, try to coerce it into a
    direct download link (dl=1) and retry once if the first download
    did not produce a valid zip file.
    """

    _require_https(url)
    tmp = Path(tempfile.mkdtemp(prefix="conduit_desktop_"))
    dest = tmp / "conduit-windows.zip"

    attempt = 0
    tried_dropbox_dl = False
    while True:
        attempt += 1
        req = urllib.request.Request(url, headers={"User-Agent": "conduit-desktop/0"})
        with urllib.request.urlopen(req, timeout=60) as resp:
            final = getattr(resp, "geturl", lambda: url)()
            _require_https(str(final))
            # Read the response into memory so we can verify it's a zip before
            # writing it out. This keeps us from accidentally writing an HTML
            # error page as a zip file.
            data = resp.read()

        # Quick magic check for ZIP files
        if len(data) >= 4 and data[:4] == b"PK\x03\x04":
            with dest.open("wb") as out:
                out.write(data)
            return dest

        # If we got here, the response was not a zip. Special-case Dropbox
        # share links: if the host contains 'dropbox.com' and we haven't yet
        # tried adding dl=1, transform the URL and retry once.
        parsed = urllib.parse.urlparse(url)
        if "dropbox.com" in parsed.netloc and not tried_dropbox_dl:
            tried_dropbox_dl = True
            qs = dict(urllib.parse.parse_qsl(parsed.query, keep_blank_values=True))
            qs["dl"] = "1"
            new_q = urllib.parse.urlencode(qs)
            url = urllib.parse.urlunparse(parsed._replace(query=new_q))
            continue

        # Otherwise, raise a helpful error including the start of the body and
        # any content-type the server reported.
        content_snippet = data[:512]
        try:
            snippet_text = content_snippet.decode("utf-8", errors="replace")
        except Exception:
            snippet_text = repr(content_snippet)
        raise ConduitDesktopInstallError(
            f"Downloaded file is not a zip archive (first bytes: {data[:8]!r}).\n"
            f"If you are using Dropbox, ensure the share link is a direct download (add dl=1).\n"
            f"Content-type: {getattr(resp, 'headers', {}).get('Content-Type', 'unknown')}\n"
            f"Body snippet:\n{snippet_text}\n"
        )


def _download_to_path(url: str, dest: Path) -> Path:
    """Download the URL into `dest` and ensure it's a ZIP.

    This behaves like `_download_to_temp`, but stores the final zip inside
    the runtime directory (app/) to match packaging requirements.
    """

    _require_https(url)
    dest.parent.mkdir(parents=True, exist_ok=True)

    attempt = 0
    tried_dropbox_dl = False
    while True:
        attempt += 1
        req = urllib.request.Request(url, headers={"User-Agent": "conduit-desktop/0"})
        with urllib.request.urlopen(req, timeout=60) as resp:
            final = getattr(resp, "geturl", lambda: url)()
            _require_https(str(final))
            data = resp.read()

        if len(data) >= 4 and data[:4] == b"PK\x03\x04":
            tmp_dest = dest.with_suffix(dest.suffix + ".tmp")
            try:
                with tmp_dest.open("wb") as out:
                    out.write(data)
                tmp_dest.replace(dest)
            finally:
                try:
                    if tmp_dest.exists():
                        tmp_dest.unlink()
                except Exception:
                    pass
            return dest

        parsed = urllib.parse.urlparse(url)
        if "dropbox.com" in parsed.netloc and not tried_dropbox_dl:
            tried_dropbox_dl = True
            qs = dict(urllib.parse.parse_qsl(parsed.query, keep_blank_values=True))
            qs["dl"] = "1"
            new_q = urllib.parse.urlencode(qs)
            url = urllib.parse.urlunparse(parsed._replace(query=new_q))
            continue

        content_snippet = data[:512]
        try:
            snippet_text = content_snippet.decode("utf-8", errors="replace")
        except Exception:
            snippet_text = repr(content_snippet)
        raise ConduitDesktopInstallError(
            f"Downloaded file is not a zip archive (first bytes: {data[:8]!r}).\n"
            f"If you are using Dropbox, ensure the share link is a direct download (add dl=1).\n"
            f"Body snippet:\n{snippet_text}\n"
        )


def _safe_extract_zip(zip_path: Path, target_dir: Path) -> None:
    target_dir.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(zip_path, "r") as zf:
        for member in zf.infolist():
            name = member.filename
            if not name:
                continue
            p = Path(name)
            if p.is_absolute() or any(part == ".." for part in p.parts):
                raise ConduitDesktopInstallError(f"Unsafe path in zip: {name}")
        zf.extractall(target_dir)


# ----------------------------- INSTALL API -------------------------------

def get_installed_info(runtime_dir: Optional[Path] = None, *, use_env_runtime_dir: bool = True) -> Optional[dict]:
    """Return minimal info if a runtime exists under the runtime dir.

    This no longer relies on a persisted `installed.json` file; instead we
    test for the presence of a `conduit.exe` (case-insensitive) under the
    runtime directory.
    """

    runtime_dir = runtime_dir or get_runtime_dir()
    if not runtime_dir.exists():
        return None
    try:
        for p in runtime_dir.rglob("*.exe"):
            if p.is_file() and p.name.lower() == "conduit.exe":
                return {"path": str(p), "installed_at": p.stat().st_mtime}
        return None
    except Exception:
        return None


def install(
    *,
    url: Optional[str] = None,
    sha256: Optional[str] = None,
    force: bool = False,
    runtime_dir: Optional[Path] = None,
    use_env_runtime_dir: bool = True,
) -> dict:
    """Install the conduit-windows.zip into the package `app/` folder.

    If `url` is not provided, `RUNTIME_ZIP_URL` in this file is used. If
    `sha256` is not provided, `RUNTIME_ZIP_SHA256` is used (may be empty).
    Use `runtime_dir` to override the target directory.
    """

    env_url = os.environ.get("CONDUIT_DESKTOP_RUNTIME_URL", "").strip()
    env_sha256 = os.environ.get("CONDUIT_DESKTOP_RUNTIME_SHA256", "").strip()
    url = (url or env_url or RUNTIME_ZIP_URL or "").strip()
    sha256 = (sha256 or env_sha256 or RUNTIME_ZIP_SHA256 or "").strip()

    if not url:
        raise ConduitDesktopInstallError(
            "RUNTIME_ZIP_URL is not set. Edit conduit_desktop.__init__.py and set RUNTIME_ZIP_URL to your runtime zip HTTPS URL."
        )

    _require_https(url)

    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    existing = get_installed_info(runtime_dir)

    if not force and existing is not None:
        return existing

    runtime_dir.mkdir(parents=True, exist_ok=True)
    zip_path = _download_to_path(url, runtime_dir / "conduit-windows.zip")

    if sha256:
        actual = _sha256_file(zip_path)
        if actual.lower() != sha256.lower():
            raise ConduitDesktopInstallError(
                f"SHA256 mismatch (expected {sha256.lower()}, got {actual.lower()})"
            )

    # Extract into a staging dir inside app/, then move into place.
    staging_dir = runtime_dir / ".staging"
    if staging_dir.exists():
        shutil.rmtree(staging_dir, ignore_errors=True)
    _safe_extract_zip(zip_path, staging_dir)

    # Remove previous contents, preserving the downloaded zip and staging folder.
    for child in list(runtime_dir.iterdir()):
        if child == zip_path or child == staging_dir:
            continue
        if child.is_dir():
            shutil.rmtree(child, ignore_errors=True)
        else:
            try:
                child.unlink()
            except Exception:
                pass

    for child in staging_dir.iterdir():
        dest = runtime_dir / child.name
        if dest.exists():
            if dest.is_dir():
                shutil.rmtree(dest, ignore_errors=True)
            else:
                try:
                    dest.unlink()
                except Exception:
                    pass
        shutil.move(str(child), str(dest))

    shutil.rmtree(staging_dir, ignore_errors=True)

    info = {"url": url, "sha256": sha256, "installed_at": time.time()}
    # Note: we intentionally do NOT write an installed.json file anymore.
    return info


# ----------------------------- RUNTIME RUNNER ----------------------------

def find_conduit_exe(runtime_dir: Optional[Path] = None, *, use_env_runtime_dir: bool = True) -> Path:
    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    if not runtime_dir.exists():
        raise ConduitDesktopRunError("Runtime not installed; call install() first")

    # Search case-insensitively for `conduit.exe` (covers both
    # "Conduit.exe" and "conduit.exe" builds).
    for p in runtime_dir.rglob("*.exe"):
        if p.is_file() and p.name.lower() == "conduit.exe":
            return p

    raise ConduitDesktopRunError(f"Could not find conduit.exe under {runtime_dir}")


def run(
    *,
    host_port: Optional[str] = None,
    runtime_dir: Optional[Path] = None,
    extra_args: Optional[list] = None,
    session_token: Optional[str] = None,
    wait: bool = False,
    use_env_runtime_dir: bool = True,
):
    """Run conduit.exe with optional host:port (no URL schemes).

    Returns subprocess.Popen when wait=False, otherwise returns the exit code.
    """

    if not sys.platform.startswith("win"):
        raise ConduitDesktopRunError("Conduit runtime currently supported on Windows only")

    runtime_dir = runtime_dir or get_runtime_dir(use_env_runtime_dir=use_env_runtime_dir)
    exe = find_conduit_exe(runtime_dir)
    args = [str(exe)]
    if host_port:
        args.append(f"--ws={host_port}")
    if session_token:
        args.append(f"--token={session_token}")
    if extra_args:
        args.extend(extra_args)

    env = os.environ.copy()
    if host_port:
        # Fallback for platforms/builds that don't forward argv reliably.
        env.setdefault("CONDUIT_WS_URL", host_port)
    if session_token:
        env["CONDUIT_SESSION_TOKEN"] = session_token

    proc = subprocess.Popen(args, env=env, cwd=str(exe.parent))
    if wait:
        return proc.wait()
    return proc


__all__ = [
    "install",
    "find_conduit_exe",
    "run",
    "get_runtime_dir",
    "get_installed_info",
    "ConduitDesktopInstallError",
    "ConduitDesktopRunError",
]
