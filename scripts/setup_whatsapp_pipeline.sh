#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN=${PYTHON_BIN:-python3}
VENV_DIR=${VENV_DIR:-.venv-whatsapp}

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "[WARN] ffmpeg not found. Install ffmpeg with your package manager before running ASR."
fi

$PYTHON_BIN -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

python -m pip install --upgrade pip wheel setuptools

# Core parsing + ASR stack
pip install \
  faster-whisper \
  whisperx \
  pydub \
  pandas \
  python-dateutil \
  orjson \
  tqdm

# Optional NLP helpers for post-editing/reporting
pip install \
  jiwer \
  rapidfuzz

cat <<MSG

Environment ready.

Next steps:
  source $VENV_DIR/bin/activate
  mkdir -p data/input data/case_001/raw data/case_001/derived

Recommended checks:
  python -V
  ffmpeg -version
  python -c "import whisperx, faster_whisper; print('ok')"

MSG
