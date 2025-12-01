"""Tests for create_repo module."""

import subprocess
from unittest.mock import patch, MagicMock
from github_tools.create_repo import create_github_repo


def test_create_repo_success():
    """Test successful repository creation."""
    with patch('subprocess.run') as mock_run:
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout="Created repository actual-software/test-repo"
        )

        result = create_github_repo(
            org="actual-software",
            name="test-repo",
            description="Test repository"
        )

        assert result is True
        mock_run.assert_called_once()

        call_args = mock_run.call_args[0][0]
        assert "gh" in call_args
        assert "repo" in call_args
        assert "create" in call_args
        assert "actual-software/test-repo" in call_args


def test_create_repo_private():
    """Test creating a private repository."""
    with patch('subprocess.run') as mock_run:
        mock_run.return_value = MagicMock(returncode=0, stdout="Created")

        create_github_repo(
            org="actual-software",
            name="test-repo",
            private=True
        )

        call_args = mock_run.call_args[0][0]
        assert "--private" in call_args
        assert "--public" not in call_args


def test_create_repo_public():
    """Test creating a public repository."""
    with patch('subprocess.run') as mock_run:
        mock_run.return_value = MagicMock(returncode=0, stdout="Created")

        create_github_repo(
            org="actual-software",
            name="test-repo",
            private=False
        )

        call_args = mock_run.call_args[0][0]
        assert "--public" in call_args
        assert "--private" not in call_args


def test_create_repo_failure():
    """Test handling of repository creation failure."""
    with patch('subprocess.run') as mock_run:
        mock_run.side_effect = subprocess.CalledProcessError(
            returncode=1,
            cmd="gh repo create",
            stderr="Error: already exists"
        )

        result = create_github_repo(
            org="actual-software",
            name="test-repo"
        )

        assert result is False


def test_create_repo_gh_not_found():
    """Test handling when gh CLI is not installed."""
    with patch('subprocess.run') as mock_run:
        mock_run.side_effect = FileNotFoundError()

        result = create_github_repo(
            org="actual-software",
            name="test-repo"
        )

        assert result is False
