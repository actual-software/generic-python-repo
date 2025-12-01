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

### Push this repository to GitHub

```bash
./scripts/push_to_github.sh
```

## Development

Run tests:
```bash
pytest
```
