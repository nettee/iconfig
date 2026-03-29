unalias r-full-build 2>/dev/null

r-full-build() {
  setopt local_options pipe_fail no_unset

  local target_dir="${1:-$PWD}"

  pnpm --dir "$target_dir" clean && \
    rm -f "$target_dir"/packages/*/tsconfig.tsbuildinfo "$target_dir"/apps/api/tsconfig.tsbuildinfo && \
    rm -rf "$target_dir"/packages/*/dist "$target_dir"/apps/api/dist && \
    pnpm --dir "$target_dir" install && \
    pnpm --dir "$target_dir" build && \
    git -C "$target_dir" checkout apps/web/public/
}

_r_print_compare_status() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "$target_path" ]]; then
    print "  [missing] $target_path"
    return
  fi

  if diff -rq "$source_path" "$target_path" >/dev/null 2>&1; then
    print "  [same] $target_path"
  else
    print "  [different] $target_path"
  fi
}

_r_init_worktree_sync_files() {
  setopt local_options pipe_fail no_unset

  local source_dir="$1"
  local target_dir="$2"
  shift 2

  local -a items
  local item source_path target_path

  items=("$@")

  print "Comparing current worktree with source: $source_dir"

  for item in $items; do
    source_path="$source_dir/$item"
    target_path="$target_dir/$item"

    if [[ ! -e "$source_path" ]]; then
      print "[skip] source missing: $source_path"
      continue
    fi

    print "\nBefore copy: $item"
    _r_print_compare_status "$source_path" "$target_path"
  done

  print "\nCopying files from source to target..."

  for item in $items; do
    source_path="$source_dir/$item"

    if [[ ! -e "$source_path" ]]; then
      continue
    fi

    target_path="$target_dir/$item"

    if [[ -d "$source_path" ]]; then
      mkdir -p "$target_path"
      rsync -a "$source_path/" "$target_path/"
    else
      mkdir -p "${target_path:h}"
      rsync -a "$source_path" "$target_path"
    fi

    if [[ $? -eq 0 ]]; then
      print "  [copied] $item"
    else
      print -u2 "  [failed] $item"
      return 1
    fi
  done

  print "\nAfter copy: compare again"

  for item in $items; do
    source_path="$source_dir/$item"
    target_path="$target_dir/$item"

    if [[ ! -e "$source_path" ]]; then
      continue
    fi

    _r_print_compare_status "$source_path" "$target_path"
  done

  return 0
}

_r_get_worktree_main_repo_dir() {
  setopt local_options pipe_fail no_unset

  local target_dir="$1"
  local common_dir

  common_dir="$(git -C "$target_dir" rev-parse --git-common-dir 2>/dev/null)" || return 1

  if [[ "$common_dir" != /* ]]; then
    common_dir="$target_dir/$common_dir"
  fi

  if [[ "$common_dir" != */.git ]]; then
    return 1
  fi

  print "${common_dir%/.git}"
  return 0
}

r-init-worktree() {
  setopt local_options pipe_fail no_unset

  local target_dir="$PWD"
  local source_dir
  local -a items

  items=(
    "CLAUDE.md"
    ".cursor"
    ".opencode"
    ".claude"
    "apps/api/.env"
    "apps/web/.env"
  )

  if [[ ! -d "$target_dir" ]]; then
    print -u2 "Target directory not found: $target_dir"
    return 1
  fi

  source_dir="$(_r_get_worktree_main_repo_dir "$target_dir")" || {
    print -u2 "Cannot infer source directory from git worktree: $target_dir"
    return 1
  }

  if [[ ! -d "$source_dir" ]]; then
    print -u2 "Inferred source directory not found: $source_dir"
    return 1
  fi

  print "Target worktree: $target_dir"
  print "Inferred source repo: $source_dir"

  print "\nRunning full build in: $target_dir"
  r-full-build "$target_dir" || return 1

  _r_init_worktree_sync_files "$source_dir" "$target_dir" "${items[@]}" || return 1

  print "\nDone."
}
