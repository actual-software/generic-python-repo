#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

VISIBILITY="public"
DESCRIPTION=""
KEEP_TMP="false"
TMP_DIR=""

usage() {
    cat << EOF
Usage: $0 --org ORG --repo REPO [OPTIONS]

Push this repository as a new GitHub repository with custom configuration.

Required arguments:
    -o, --org ORG           Target GitHub organization
    -r, --repo REPO         Repository name

Optional arguments:
    -v, --visibility VIS    Repository visibility: public or private (default: public)
    -d, --description DESC  Repository description
    --keep-tmp              Keep temporary directory after completion (for debugging)
    -h, --help              Show this help message

Examples:
    $0 --org actual-software --repo my-test-repo
    $0 -o my-org -r my-repo --visibility private
    $0 -o test-org -r test-repo -d "Test repository" --keep-tmp

EOF
    exit 1
}

cleanup() {
    if [[ "$KEEP_TMP" != "true" ]] && [[ -n "$TMP_DIR" ]] && [[ -d "$TMP_DIR" ]]; then
        echo "Cleaning up temporary directory..."
        rm -rf "$TMP_DIR"
    elif [[ "$KEEP_TMP" == "true" ]] && [[ -n "$TMP_DIR" ]]; then
        echo "Temporary directory kept at: $TMP_DIR"
    fi
}

trap cleanup EXIT

check_prerequisites() {
    if ! command -v gh &> /dev/null; then
        echo "Error: gh CLI not found. Please install it: https://cli.github.com/" >&2
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        echo "Error: gh CLI not authenticated. Run 'gh auth login' first." >&2
        exit 1
    fi

    if [[ ! -d "$SOURCE_DIR/.git" ]] && [[ ! -f "$SOURCE_DIR/pyproject.toml" ]]; then
        echo "Warning: Source directory doesn't appear to be a git repository or Python project" >&2
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--org)
            ORG="$2"
            shift 2
            ;;
        -r|--repo)
            REPO_NAME="$2"
            shift 2
            ;;
        -v|--visibility)
            VISIBILITY="$2"
            shift 2
            ;;
        -d|--description)
            DESCRIPTION="$2"
            shift 2
            ;;
        --keep-tmp)
            KEEP_TMP="true"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            usage
            ;;
    esac
done

if [[ -z "$ORG" ]] || [[ -z "$REPO_NAME" ]]; then
    echo "Error: --org and --repo are required" >&2
    usage
fi

if [[ "$VISIBILITY" != "public" ]] && [[ "$VISIBILITY" != "private" ]]; then
    echo "Error: --visibility must be 'public' or 'private'" >&2
    exit 1
fi

if [[ -z "$DESCRIPTION" ]]; then
    DESCRIPTION="Python repository created from generic-python-repo template"
fi

check_prerequisites

TMP_DIR="/tmp/github-repo-push-$$"

echo "Creating temporary directory: $TMP_DIR"
mkdir -p "$TMP_DIR"

echo "Copying repository contents (excluding .git)..."
rsync -av \
    --exclude='.git' \
    --exclude='venv/' \
    --exclude='env/' \
    --exclude='__pycache__/' \
    --exclude='*.pyc' \
    --exclude='.pytest_cache/' \
    --exclude='.coverage' \
    --exclude='*.egg-info/' \
    "$SOURCE_DIR/" "$TMP_DIR/"

cd "$TMP_DIR"

echo "Initializing new git repository..."
git init -b main

echo "Creating initial commit..."
git add .
git commit -m "Initial commit from template

Repository: $ORG/$REPO_NAME
Template: generic-python-repo"

echo "Creating GitHub repository: $ORG/$REPO_NAME"
gh repo create "$ORG/$REPO_NAME" \
    "--$VISIBILITY" \
    --description "$DESCRIPTION" \
    --confirm

echo "Setting remote origin..."
git remote add origin "https://github.com/$ORG/$REPO_NAME.git"

echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "Repository created and pushed successfully!"
echo "Organization: $ORG"
echo "Repository: $REPO_NAME"
echo "Visibility: $VISIBILITY"
echo "View at: https://github.com/$ORG/$REPO_NAME"
