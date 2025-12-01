#!/usr/bin/env python3
"""Create a new GitHub repository using gh CLI."""

import argparse
import subprocess
import sys
from typing import Optional


def create_github_repo(
    org: str,
    name: str,
    description: Optional[str] = None,
    private: bool = False,
    clone: bool = False
) -> bool:
    """
    Create a new GitHub repository in the specified organization.

    Uses the GitHub CLI (gh) which must be installed and authenticated.

    Args:
        org: Organization name
        name: Repository name
        description: Repository description
        private: Whether the repository should be private
        clone: Whether to clone the repository after creation

    Returns:
        True if successful, False otherwise
    """
    cmd = [
        "gh", "repo", "create",
        f"{org}/{name}",
        "--confirm"
    ]

    if description:
        cmd.extend(["--description", description])

    if private:
        cmd.append("--private")
    else:
        cmd.append("--public")

    if clone:
        cmd.append("--clone")

    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        print(f"Successfully created repository: {org}/{name}")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Failed to create repository: {e.stderr}", file=sys.stderr)
        return False
    except FileNotFoundError:
        print("Error: gh CLI not found. Please install it: https://cli.github.com/", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Create a new GitHub repository using gh CLI"
    )
    parser.add_argument(
        "--org",
        required=True,
        help="Organization name"
    )
    parser.add_argument(
        "--name",
        required=True,
        help="Repository name"
    )
    parser.add_argument(
        "--description",
        help="Repository description"
    )
    parser.add_argument(
        "--private",
        action="store_true",
        help="Make the repository private"
    )
    parser.add_argument(
        "--clone",
        action="store_true",
        help="Clone the repository after creation"
    )

    args = parser.parse_args()

    success = create_github_repo(
        org=args.org,
        name=args.name,
        description=args.description,
        private=args.private,
        clone=args.clone
    )

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
