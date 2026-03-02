#!/bin/bash
set -e

# ============================================================================
# create-project.sh — Automated nbdev project creation
#
# Creates a fully configured nbdev project with:
#   - GitHub repo, venv, nbdev + JupyterLab installed
#   - pyproject.toml configured
#   - Cursor rules for nbdev workflow
#   - CONTRIBUTING.md, GETTING-STARTED.md, notebook style guide
#   - Git hooks installed, initial commit pushed
#
# Usage: ./create-project.sh
#
# Configure defaults in ~/.nbdev-starter.conf (optional):
#   GITHUB_USERNAME="YourUsername"
#   AUTHOR_NAME="Your Name"
#   AUTHOR_EMAIL="you@example.com"
#   DEFAULT_LICENSE="Apache-2.0"
#   DEFAULT_PYTHON_VERSION=">=3.10"
#   DEFAULT_PARENT_DIR="$HOME/Code"
# ============================================================================

# --- Load config ---

CONFIG_FILE="${HOME}/.nbdev-starter.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
AUTHOR_NAME="${AUTHOR_NAME:-}"
AUTHOR_EMAIL="${AUTHOR_EMAIL:-}"
DEFAULT_LICENSE="${DEFAULT_LICENSE:-Apache-2.0}"
DEFAULT_PYTHON_VERSION="${DEFAULT_PYTHON_VERSION:->=3.10}"
DEFAULT_PARENT_DIR="${DEFAULT_PARENT_DIR:-$HOME/Code}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# --- Colors ---

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() { echo -e "\n${BLUE}== $1 ==${NC}"; }
print_ok()     { echo -e "${GREEN}  ✓ $1${NC}"; }
print_info()   { echo -e "${YELLOW}  → $1${NC}"; }
print_err()    { echo -e "${RED}  ✗ $1${NC}"; }

# --- Prerequisite check ---

print_header "Checking Prerequisites"

missing=""
command -v git   >/dev/null 2>&1 || missing="$missing git"
command -v gh    >/dev/null 2>&1 || missing="$missing gh"
command -v python3 >/dev/null 2>&1 || missing="$missing python3"

if [ -n "$missing" ]; then
    print_err "Missing required tools:$missing"
    echo "  Install them before running this script."
    exit 1
fi
print_ok "git, gh, python3 found"

# Verify gh is authenticated
if ! gh auth status >/dev/null 2>&1; then
    print_err "gh CLI is not authenticated. Run: gh auth login"
    exit 1
fi
print_ok "gh CLI authenticated"

# --- Collect project info ---

print_header "Project Information"

if [ -z "$GITHUB_USERNAME" ]; then
    read -p "  GitHub username: " GITHUB_USERNAME
else
    echo "  GitHub username: $GITHUB_USERNAME (from config)"
fi

if [ -z "$AUTHOR_NAME" ]; then
    read -p "  Author name: " AUTHOR_NAME
else
    echo "  Author name: $AUTHOR_NAME (from config)"
fi

if [ -z "$AUTHOR_EMAIL" ]; then
    read -p "  Author email (blank to omit): " AUTHOR_EMAIL
elif [ -n "$AUTHOR_EMAIL" ]; then
    echo "  Author email: $AUTHOR_EMAIL (from config)"
fi

echo ""
read -p "  Project name (lowercase-with-hyphens): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    print_err "Project name is required"
    exit 1
fi

MODULE_NAME="${PROJECT_NAME//-/_}"

read -p "  One-line description: " DESCRIPTION
if [ -z "$DESCRIPTION" ]; then
    print_err "Description is required"
    exit 1
fi

read -p "  Keywords (comma-separated, default: nbdev): " KEYWORDS_INPUT
KEYWORDS_INPUT="${KEYWORDS_INPUT:-nbdev}"
if [[ ! "$KEYWORDS_INPUT" == *"nbdev"* ]]; then
    KEYWORDS_INPUT="nbdev, $KEYWORDS_INPUT"
fi

read -p "  Private repository? (y/n, default: y): " IS_PRIVATE
IS_PRIVATE="${IS_PRIVATE:-y}"

read -p "  Parent directory (default: $DEFAULT_PARENT_DIR): " PARENT_DIR
PARENT_DIR="${PARENT_DIR:-$DEFAULT_PARENT_DIR}"
PARENT_DIR="${PARENT_DIR/#\~/$HOME}"

read -p "  License (default: $DEFAULT_LICENSE): " LICENSE
LICENSE="${LICENSE:-$DEFAULT_LICENSE}"

# --- Confirmation ---

print_header "Review"
echo "  Project name:  $PROJECT_NAME"
echo "  Module name:   $MODULE_NAME"
echo "  Description:   $DESCRIPTION"
echo "  Keywords:      $KEYWORDS_INPUT"
echo "  Author:        $AUTHOR_NAME${AUTHOR_EMAIL:+ <$AUTHOR_EMAIL>}"
echo "  GitHub:        $GITHUB_USERNAME/$PROJECT_NAME"
echo "  License:       $LICENSE"
echo "  Private:       $IS_PRIVATE"
echo "  Location:      $PARENT_DIR/$PROJECT_NAME"
echo ""
read -p "  Create this project? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    print_info "Cancelled"
    exit 0
fi

# ============================================================================
# Execution
# ============================================================================

# --- Create GitHub repo ---

print_header "Creating GitHub Repository"

PRIVACY_FLAG=$( [ "$IS_PRIVATE" = "y" ] && echo "--private" || echo "--public" )

if ! gh repo create "$GITHUB_USERNAME/$PROJECT_NAME" $PRIVACY_FLAG --description "$DESCRIPTION" 2>&1; then
    print_err "Failed to create GitHub repository"
    exit 1
fi
print_ok "GitHub repo created: $GITHUB_USERNAME/$PROJECT_NAME"

# --- Clone ---

print_header "Cloning Repository"

cd "$PARENT_DIR"
git clone "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
cd "$PROJECT_NAME"
PROJECT_ROOT="$(pwd)"
print_ok "Cloned to $PROJECT_ROOT"

# --- Virtual environment ---

print_header "Creating Virtual Environment"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip -q
print_ok "Virtual environment ready"

# --- Install tools ---

print_header "Installing Tools"

pip install jupyterlab nbdev -q
print_ok "jupyterlab + nbdev installed"

print_info "Installing Quarto (may prompt for password)..."
nbdev-install-quarto

pip install jupyterlab-quarto -q
print_ok "All tools installed"

# --- Initialize nbdev ---

print_header "Initializing nbdev"

NBDEV_CMD="nbdev-new --user \"$GITHUB_USERNAME\" --author \"$AUTHOR_NAME\""
if [ -n "$AUTHOR_EMAIL" ]; then
    NBDEV_CMD="$NBDEV_CMD --author_email \"$AUTHOR_EMAIL\""
fi
eval $NBDEV_CMD
print_ok "nbdev initialized"

# --- Rename module directory if needed ---

for dir in */; do
    dir="${dir%/}"
    if [ -f "$dir/__init__.py" ] && [ "$dir" != "$MODULE_NAME" ] && [ "$dir" != "venv" ]; then
        mv "$dir" "$MODULE_NAME"
        print_info "Renamed module directory: $dir → $MODULE_NAME"
        break
    fi
done

# --- Generate pyproject.toml ---

print_header "Configuring pyproject.toml"

# Format keywords as TOML array
IFS=',' read -ra KW_ARRAY <<< "$KEYWORDS_INPUT"
KEYWORDS_TOML=""
for kw in "${KW_ARRAY[@]}"; do
    kw="$(echo "$kw" | xargs)"
    [ -n "$KEYWORDS_TOML" ] && KEYWORDS_TOML="$KEYWORDS_TOML, "
    KEYWORDS_TOML="$KEYWORDS_TOML\"$kw\""
done

if [ -n "$AUTHOR_EMAIL" ]; then
    AUTHOR_LINE="[{name = \"$AUTHOR_NAME\", email = \"$AUTHOR_EMAIL\"}]"
else
    AUTHOR_LINE="[{name = \"$AUTHOR_NAME\"}]"
fi

cat > pyproject.toml << TOML
[build-system]
requires = ["setuptools>=64"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
dynamic = ["version"]
description = "$DESCRIPTION"
readme = "README.md"
requires-python = "$DEFAULT_PYTHON_VERSION"
license = {text = "$LICENSE"}
authors = $AUTHOR_LINE
keywords = [$KEYWORDS_TOML]
classifiers = [
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3 :: Only",
]
dependencies = []

[project.urls]
Repository = "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME"
Documentation = "https://$GITHUB_USERNAME.github.io/$PROJECT_NAME/"

[project.entry-points.nbdev]
$MODULE_NAME = "${MODULE_NAME}._modidx:d"

[tool.setuptools.dynamic]
version = {attr = "${MODULE_NAME}.__version__"}

[tool.setuptools.packages.find]
include = ["$MODULE_NAME"]

[tool.nbdev]
lib_name = "$MODULE_NAME"
lib_path = "$MODULE_NAME"
doc_path = "_docs"
TOML

print_ok "pyproject.toml configured"

# --- Copy templates ---

print_header "Installing Project Templates"

copy_template() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{MODULE_NAME}}|$MODULE_NAME|g" \
        -e "s|{{GITHUB_USERNAME}}|$GITHUB_USERNAME|g" \
        -e "s|{{AUTHOR_NAME}}|$AUTHOR_NAME|g" \
        -e "s|{{AUTHOR_EMAIL}}|$AUTHOR_EMAIL|g" \
        -e "s|{{DESCRIPTION}}|$DESCRIPTION|g" \
        "$src" > "$dest"
}

if [ -d "$TEMPLATES_DIR" ]; then
    # Cursor rules
    mkdir -p .cursor/rules
    copy_template "$TEMPLATES_DIR/cursor-rules/nbdev-workflow.mdc" ".cursor/rules/nbdev-workflow.mdc"
    copy_template "$TEMPLATES_DIR/cursor-rules/notebook-conventions.mdc" ".cursor/rules/notebook-conventions.mdc"
    print_ok "Cursor rules"

    # Root-level project docs
    copy_template "$TEMPLATES_DIR/CONTRIBUTING.md" "CONTRIBUTING.md"
    copy_template "$TEMPLATES_DIR/GETTING-STARTED.md" "GETTING-STARTED.md"
    print_ok "CONTRIBUTING.md + GETTING-STARTED.md"

    # docs/
    mkdir -p docs
    copy_template "$TEMPLATES_DIR/docs/notebook-style-guide.md" "docs/notebook-style-guide.md"
    copy_template "$TEMPLATES_DIR/docs/autoreload-best-practices.md" "docs/autoreload-best-practices.md"
    cp "$TEMPLATES_DIR/docs/fastai-info-map.md" "docs/fastai-info-map.md"
    cp "$TEMPLATES_DIR/docs/decision-template.md" "docs/decision-template.md"
    print_ok "Documentation"

    # Quarto config
    copy_template "$TEMPLATES_DIR/nbdev.yml" "nbs/nbdev.yml"
    print_ok "Quarto config (nbs/nbdev.yml)"
else
    print_info "Templates directory not found at $TEMPLATES_DIR"
    print_info "Skipping template copy — you can add these files manually later"
fi

# --- Git hooks + editable install ---

print_header "Final Setup"

nbdev-install-hooks
print_ok "Git hooks installed"

pip install -e '.[dev]' -q
print_ok "Package installed in editable mode"

# --- nbdev-prepare ---

print_info "Running nbdev-prepare..."
if nbdev-prepare; then
    print_ok "nbdev-prepare passed"
else
    print_info "nbdev-prepare had issues (sometimes expected on initial setup)"
fi

# --- Initial commit ---

print_header "Initial Commit"

git add .
git commit -m "Initial nbdev project setup

- Configure pyproject.toml with project metadata
- Install Cursor rules for nbdev workflow
- Add CONTRIBUTING.md and GETTING-STARTED.md
- Add notebook style guide and reference docs
- Install git hooks for clean notebooks
- Run initial nbdev-prepare"

git push -u origin master 2>/dev/null || git push -u origin main
print_ok "Pushed to GitHub"

# --- Done ---

print_header "Done!"
echo ""
echo -e "${GREEN}Your nbdev project is ready.${NC}"
echo ""
echo "  Location:  $PROJECT_ROOT"
echo "  GitHub:    https://github.com/$GITHUB_USERNAME/$PROJECT_NAME"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  cd $PROJECT_ROOT"
echo "  source venv/bin/activate"
echo "  jupyter lab"
echo ""
echo -e "${YELLOW}Daily workflow:${NC}"
echo "  1. Edit notebooks in nbs/"
echo "  2. nbdev-prepare"
echo "  3. git add . && git commit -m '...' && git push"
echo ""
echo -e "${YELLOW}GitHub Pages (after first CI pass):${NC}"
echo "  Settings → Pages → select gh-pages branch"
echo "  https://$GITHUB_USERNAME.github.io/$PROJECT_NAME/"
