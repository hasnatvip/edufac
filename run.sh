#!/usr/bin/env bash
set -e

# Ensure Homebrew and standard system paths are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Move to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Performance and compatibility settings
export SYSTEM_VERSION_COMPAT=0
export OMP_NUM_THREADS=1

# Check for existing virtual environments
if [ -n "$VIRTUAL_ENV" ]; then
    echo "Using active virtual environment: $VIRTUAL_ENV"
elif [ -f "$SCRIPT_DIR/.venv/bin/activate" ]; then
    echo "Activating virtual environment: $SCRIPT_DIR/.venv"
    source "$SCRIPT_DIR/.venv/bin/activate"
elif [ -f "$SCRIPT_DIR/venv/bin/activate" ]; then
    echo "Activating virtual environment: $SCRIPT_DIR/venv"
    source "$SCRIPT_DIR/venv/bin/activate"
elif [ -f "$HOME/facefusion-env/bin/activate" ] && "$HOME/facefusion-env/bin/python" -c "import cv2" 2>/dev/null; then
    echo "Activating virtual environment: $HOME/facefusion-env"
    source "$HOME/facefusion-env/bin/activate"
else
    # Find a suitable Python interpreter (prefers 3.12, 3.11, or 3.10)
    PYTHON_BIN=""
    for py in python3.12 /opt/homebrew/bin/python3.12 python3.11 /opt/homebrew/bin/python3.11 python3.10 python3; do
        if command -v "$py" >/dev/null 2>&1; then
            if "$py" -c "import sys; exit(0 if sys.version_info >= (3, 10) else 1)" 2>/dev/null; then
                PYTHON_BIN="$(command -v "$py")"
                break
            fi
        fi
    done

    if [ -n "$PYTHON_BIN" ]; then
        if [ ! -d "$SCRIPT_DIR/.venv" ]; then
            echo "Creating virtual environment in $SCRIPT_DIR/.venv using $PYTHON_BIN..."
            "$PYTHON_BIN" -m venv "$SCRIPT_DIR/.venv"
        fi
        source "$SCRIPT_DIR/.venv/bin/activate"
    else
        echo "Error: Python 3.10+ is required to run FaceFusion."
        exit 1
    fi
fi

# Determine python command
PYTHON_CMD="python"
if ! command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python3"
fi

ENTRYPOINT="edufac.py"
if [ -f "$SCRIPT_DIR/edufac.py" ]; then
    ENTRYPOINT="edufac.py"
fi

# Run Edufac (defaults to 'run' if no args provided)
if [ $# -eq 0 ]; then
    exec "$PYTHON_CMD" "$ENTRYPOINT" run
else
    exec "$PYTHON_CMD" "$ENTRYPOINT" "$@"
fi
