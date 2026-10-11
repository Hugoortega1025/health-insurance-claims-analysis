"""Download the raw insurance dataset into data/raw/.

Usage (from the project root):
    python -m src.data.download_data

The raw file is never modified after download. A SHA-256 checksum is printed
so the exact file version can be recorded; if the
upstream file ever changes, the checksum will no longer match.
"""

import hashlib
import urllib.request
from pathlib import Path

SOURCE_URL = "https://raw.githubusercontent.com/Onurbltc/InsuranceData/main/insurance.csv"
PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_PATH = PROJECT_ROOT / "data" / "raw" / "insurance.csv"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    RAW_PATH.parent.mkdir(parents=True, exist_ok=True)
    if RAW_PATH.exists():
        print(f"Already downloaded: {RAW_PATH.relative_to(PROJECT_ROOT)}")
    else:
        urllib.request.urlretrieve(SOURCE_URL, RAW_PATH)
        print(f"Downloaded {SOURCE_URL}\n  -> {RAW_PATH.relative_to(PROJECT_ROOT)}")
    print(f"SHA-256: {sha256(RAW_PATH)}")


if __name__ == "__main__":
    main()
