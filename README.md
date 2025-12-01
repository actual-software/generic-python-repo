# Generic Python Repo

Generic Python repository with tools for creating and managing GitHub organizations, repositories, and accounts for testing purposes.

## Setup

1. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up environment variables (optional - falls back to `gh` CLI):
   ```bash
   export GITHUB_TOKEN=<your-token>
   export GITHUB_APP_ID=<app-id>
   export GITHUB_APP_PRIVATE_KEY=<private-key>
   ```

## Usage

### Using the GitHub CLI (simplest)

The tools will use the `gh` CLI by default if it's installed and authenticated.

### Create a new repository

```bash
python -m github_tools.create_repo --org actual-software --name my-test-repo
```

### Use this repository as a template

Push this repository as a new GitHub repository with custom configuration:

```bash
# Basic usage - create public repo
./scripts/push_to_github.sh --org actual-software --repo my-test-repo

# Create private repository
./scripts/push_to_github.sh --org my-org --repo my-repo --visibility private

# With custom description
./scripts/push_to_github.sh -o test-org -r test-repo -d "My test repository"

# Keep temp directory for debugging
./scripts/push_to_github.sh -o my-org -r my-repo --keep-tmp

# Show help
./scripts/push_to_github.sh --help
```

The script creates a temporary copy of the repository (excluding `.git`), initializes a fresh git repo, and pushes it to GitHub with your specified parameters. Your local working copy remains unchanged.

## Development

Run tests:
```bash
pytest
```
