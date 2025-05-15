#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# moss_scrippt.sh — run MOSS on all Python files under Assignment4/, Assignment5/, and Assignment6/
# Usage:
#   cd /path/to/Moss
#   chmod +x moss_scrippt.sh
#   ./moss_scrippt.sh
# -----------------------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

# Path to the moss.pl script
MOSS_PL="$PWD/MOSS.pl"
# Directories to scan
ASSIGN_DIRS=("$PWD/Assignment4" "$PWD/Assignment5" "$PWD/Assignment6")

# Ensure moss.pl exists
if [ ! -f "$MOSS_PL" ]; then
  echo "ERROR: moss.pl not found in $PWD" >&2
  exit 1
fi

echo "Scanning directories: ${ASSIGN_DIRS[*]}"

# Gather all .py files safely (handles spaces)
PY_FILES=()
while IFS= read -r -d '' file; do
  PY_FILES+=("$file")
done < <(find "${ASSIGN_DIRS[@]}" -type f -name '*.py' -print0)

echo "Total .py files found: ${#PY_FILES[@]}"

# Need at least two files to compare
if [ "${#PY_FILES[@]}" -lt 2 ]; then
  echo "ERROR: Need at least two .py files to compare. Found only ${#PY_FILES[@]}." >&2
  exit 1
fi

echo "Running MOSS on ${#PY_FILES[@]} files..."
perl "$MOSS_PL" \
  -l python \
  -c "Assignment Python Files" \
  -n 200 \
  "${PY_FILES[@]}"
