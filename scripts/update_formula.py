"""Point Formula/<name>.rb at a PyPI release and refresh its Python resources.

    python scripts/update_formula.py reqstorm            # latest release
    python scripts/update_formula.py reqstorm 2.4.0      # a given release

Prints the version written, or nothing when the formula is already up to date.
"""

import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.request
import venv
from pathlib import Path

PACKAGE = sys.argv[1]
EXTRAS = "[socks]"  # optional dependencies the command line should have


def pypi(path: str) -> dict:
    with urllib.request.urlopen(f"https://pypi.org/pypi/{path}/json") as response:
        return json.load(response)


def sdist(name: str, version: str) -> dict:
    return next(url for url in pypi(f"{name}/{version}")["urls"] if url["packagetype"] == "sdist")


def resources(version: str) -> str:
    # Resolve in a throwaway virtual environment: a system Python (Homebrew's, Debian's) refuses pip
    with tempfile.TemporaryDirectory() as directory:
        venv.create(directory, with_pip=True)
        python = Path(directory) / ("Scripts" if os.name == "nt" else "bin") / "python"
        resolved = subprocess.run(
            [str(python), "-m", "pip", "install", "-q", "--disable-pip-version-check", "--dry-run",
             "--ignore-installed", "--report", "-", f"{PACKAGE}{EXTRAS}=={version}"],
            capture_output=True, text=True,
        )
    if resolved.returncode != 0:
        sys.exit(f"pip could not resolve {PACKAGE}{EXTRAS}=={version}:\n{resolved.stderr}")
    report = json.loads(resolved.stdout)
    blocks = []
    for item in sorted(report["install"], key=lambda entry: entry["metadata"]["name"].lower()):
        name = re.sub(r"[-_.]+", "-", item["metadata"]["name"]).lower()
        if name == PACKAGE:
            continue
        source = sdist(item["metadata"]["name"], item["metadata"]["version"])
        blocks.append(f'  resource "{name}" do\n    url "{source["url"]}"\n'
                      f'    sha256 "{source["digests"]["sha256"]}"\n  end\n')
    return "\n".join(blocks)


def main() -> None:
    version = sys.argv[2] if len(sys.argv) > 2 else pypi(PACKAGE)["info"]["version"]
    path = Path("Formula") / f"{PACKAGE}.rb"
    formula = path.read_text()
    current = re.search(r'url "[^"]*/' + re.escape(PACKAGE) + r'-([^"/]+)\.tar\.gz"', formula)
    if current and current.group(1) == version:
        return
    source = sdist(PACKAGE, version)
    formula = re.sub(r'(?m)^  url "[^"]*"$', f'  url "{source["url"]}"', formula, count=1)
    formula = re.sub(r'(?m)^  sha256 "[^"]*"$', f'  sha256 "{source["digests"]["sha256"]}"', formula, count=1)
    start = formula.index('  resource "') if '  resource "' in formula else formula.index("  def install")
    end = formula.index("  def install")
    formula = formula[:start] + resources(version) + "\n" + formula[end:]
    path.write_text(formula)
    print(version)


main()
