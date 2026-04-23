# Git worktree helpers.
# Worktrees are placed at ../<project>-wt-<branch> relative to the repo root.
# Slashes in branch names are replaced with dashes to avoid nested directories.

# Returns the main branch name (main/master) by auto-detection.
g-main() {
  local b
  b=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | sed 's#^origin/##')
  if [[ -z "$b" || "$b" == "HEAD" ]]; then
    if git show-ref --verify --quiet refs/remotes/origin/main; then
      b="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
      b="master"
    else
      b="main"
    fi
  fi
  echo "$b"
}

# Returns the project name derived from the git root directory.
_g-wt-project-name() {
  basename "$(git rev-parse --show-toplevel 2>/dev/null)"
}

# Returns the git root directory.
_g-wt-root() {
  git rev-parse --show-toplevel 2>/dev/null
}

# Returns the parent directory of the git root.
_g-wt-base-dir() {
  local root
  root=$(_g-wt-root) || return 1
  dirname "$root"
}

# Returns the worktree path for a given branch name.
# Usage: _g-wt-path <branch-name>
_g-wt-path() {
  local branch="$1"
  local safe_branch="${branch//\//-}"
  local project_dir base_dir
  project_dir=$(_g-wt-project-name)
  base_dir=$(_g-wt-base-dir) || return 1
  echo "${base_dir}/${project_dir}-wt-${safe_branch}"
}

# Creates a git worktree with a new branch based on the main branch.
# Auto-detects the main branch, fetches and fast-forwards it before branching.
#
# Usage: g-wt-create <branch-name>
# Example: g-wt-create feature/my-feature
#          -> updates 'main' from origin
#          -> creates branch 'feature/my-feature' from 'main'
#          -> creates worktree at '../<project>-wt-feature-my-feature'
g-wt-create() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: g-wt-create <branch-name>"
    return 1
  fi

  if [[ -z "$(_g-wt-project-name)" ]]; then
    echo "Error: not inside a git repository"
    return 1
  fi

  local main_branch current_branch base_branch worktree_path
  main_branch=$(g-main)
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  worktree_path=$(_g-wt-path "$branch")

  # Interactive base branch selection (skip when already on main)
  if [[ "$current_branch" == "$main_branch" ]]; then
    base_branch="$main_branch"
    echo "Base branch: ${main_branch} (current)"
  else
    echo "Base branch:"
    echo "  1) ${main_branch} (main)"
    echo "  2) ${current_branch} (current)"
    echo -n "Choose [1/2] (default: 1): "
    read -r choice
    case "$choice" in
      2) base_branch="$current_branch" ;;
      *) base_branch="$main_branch" ;;
    esac
  fi

  if [[ "$base_branch" == "$main_branch" ]]; then
    echo "→ Fetching origin/${main_branch}..."
    git fetch origin "$main_branch" || { echo "✗ Failed to fetch origin/${main_branch}"; return 1; }

    echo "→ Updating ${main_branch} to origin/${main_branch}..."
    if ! git branch -f "$main_branch" "origin/${main_branch}"; then
      echo "→ '${main_branch}' is checked out in another worktree, using origin/${main_branch} as base"
      base_branch="origin/${main_branch}"
    fi
  fi

  echo "→ Creating worktree at '${worktree_path}' from '${base_branch}'..."
  if git worktree add -b "$branch" "$worktree_path" "$base_branch"; then
    echo "✓ Worktree created at: $worktree_path"
  else
    echo "✗ Failed to create worktree"
    return 1
  fi
}

# Removes a git worktree, keeping the branch intact.
#
# Usage: g-wt-remove <branch-name>
# Example: g-wt-remove feature/my-feature
#          -> removes worktree at '../<project>-wt-feature-my-feature'
#          -> branch 'feature/my-feature' is kept
g-wt-remove() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: g-wt-remove <branch-name>"
    return 1
  fi

  local worktree_path
  worktree_path=$(_g-wt-path "$branch")

  if [[ -z "$(_g-wt-project-name)" ]]; then
    echo "Error: not inside a git repository"
    return 1
  fi

  if git worktree remove "$worktree_path"; then
    echo "✓ Worktree removed at: $worktree_path"
  else
    echo "✗ Failed to remove worktree at: $worktree_path"
    return 1
  fi
}

# Switches to the worktree directory for a given branch.
#
# Usage: g-wt-co <branch-name>
# Example: g-wt-co feature/my-feature
#          -> cd to '../<project>-wt-feature-my-feature'
g-wt-co() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: g-wt-co <branch-name>"
    return 1
  fi

  local worktree_path
  worktree_path=$(_g-wt-path "$branch")

  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: worktree not found at '$worktree_path'"
    return 1
  fi

  cd "$worktree_path"
}

# Transfers the current branch from the main worktree to a new worktree.
# Switches the current worktree back to the main branch first, then creates
# a new worktree for the original branch.
#
# Usage: g-wt-transfer [branch-name] [worktree-name]
# Example: g-wt-transfer
#          -> switches current worktree to 'main'
#          -> creates worktree for current branch at '../<project>-wt-<branch>'
# Example: g-wt-transfer feature/my-feature wt-name
#          -> creates worktree for 'feature/my-feature' at '../wt-name'
g-wt-transfer() {
  local branch="$1"
  local worktree_name="$2"

  if [[ -z "$(_g-wt-project-name)" ]]; then
    echo "Error: not inside a git repository"
    return 1
  fi

  local main_branch current_branch worktree_path
  main_branch=$(g-main)
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z "$branch" ]]; then
    branch="$current_branch"
  fi

  if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
    echo "Error: not on a branch"
    echo "Usage: g-wt-transfer [branch-name] [worktree-name]"
    return 1
  fi

  if [[ "$branch" == "$main_branch" ]]; then
    echo "Error: cannot transfer the main branch '${main_branch}'"
    return 1
  fi

  if [[ -n "$worktree_name" ]]; then
    worktree_path="$(_g-wt-base-dir)/${worktree_name}"
  else
    worktree_path=$(_g-wt-path "$branch")
  fi

  if [[ "$current_branch" == "$branch" ]]; then
    echo "→ Switching current worktree to '${main_branch}'..."
    if ! git checkout "$main_branch"; then
      echo "✗ Failed to switch to '${main_branch}'"
      return 1
    fi
  fi

  echo "→ Creating worktree at '${worktree_path}' for '${branch}'..."
  if git worktree add "$worktree_path" "$branch"; then
    echo "✓ Branch '${branch}' transferred to: $worktree_path"
  else
    echo "✗ Failed to create worktree"
    return 1
  fi
}
