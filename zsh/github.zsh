# 返回 git 主分支
gmain() {
  # 1. 如果没有指定参数，尝试自动检测
  if [ -z "$base_branch" ]; then
    # 1. 尝试从 git 配置中读取 origin/HEAD 指向的分支
    # git rev-parse 输出通常是 "origin/main"，我们需要去掉 "origin/"
    base_branch=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | sed 's#^origin/##')
  fi

  # 2. 如果上一步失败（base_branch 为空或仍为 HEAD），则手动猜测
  if [ -z "$base_branch" ] || [ "$base_branch" = "HEAD" ]; then
    if git show-ref --verify --quiet refs/remotes/origin/main; then
      base_branch="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
      base_branch="master"
    else
      base_branch="main" # 实在找不到，默认回退到 main
    fi
  fi

  echo $base_branch
}

# GitHub Pull Request Function
# Usage: pr [base_branch]
# Default base branch is 'main' if not specified
pr() {
  local base_branch="$1"

  # 如果没有指定参数，尝试自动检测
  base_branch=$(gmain)

  local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ $? -ne 0 ]; then
    echo "Error: Not in a git repository."
    return 1
  fi

  if [ "$current_branch" = "HEAD" ]; then
    echo "Error: You are in detached HEAD state. Please checkout a branch first."
    return 1
  fi

  local remote_url=$(git config --get remote.origin.url)

  if [ -z "$remote_url" ]; then
    echo "Error: No remote 'origin' found."
    return 1
  fi

  local owner repo
  # 这里使用了 zsh 特有的正则匹配
  if [[ $remote_url =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
    owner="${match[1]}"
    repo="${match[2]}"
  else
    echo "Error: Could not parse GitHub repository from remote URL: $remote_url"
    return 1
  fi

  local pr_url="https://github.com/${owner}/${repo}/compare/${base_branch}...${current_branch}"

  echo "Opening pull request URL (Target: $base_branch):"
  echo "$pr_url"
  echo ""

  if command -v open &> /dev/null; then
    open "$pr_url"
  elif command -v xdg-open &> /dev/null; then
    xdg-open "$pr_url"
  elif command -v start &> /dev/null; then
    start "$pr_url"
  else
    echo "Could not detect browser command. Please open the URL manually."
  fi
}

function cr() {
  if [[ $# -eq 0 ]]; then
    gh pr comment --body "/cr"
  else
    gh pr comment --body "/cr $*"
  fi
}

gh-prs() {
  gh api graphql \
    -f query='query($n:Int!){ viewer { pullRequests(first:$n, states: OPEN, orderBy: {field: UPDATED_AT, direction: DESC}) { nodes { number title url updatedAt repository { nameWithOwner } } pageInfo { hasNextPage endCursor } } }}' \
    -F n="${1:-100}"
}

# 在 GitHub 网页端打开指定文件
function gh-open() {
    # 1. 检查是否在 git 目录
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not a git repository."
        return 1
    fi

    # 2. 获取远程仓库 URL (支持 git@ 和 https://)
    local remote_url=$(git config --get remote.origin.url)
    if [[ -z "$remote_url" ]]; then
        echo "Error: No remote 'origin' found."
        return 1
    fi

    # 3. 转换为网页地址格式
    # 处理 git@github.com:user/repo.git -> https://github.com/user/repo
    local base_url=${remote_url%.git}
    base_url=${base_url/git@github.com:/https:\/\/github.com\/}

    # 4. 获取当前分支名
    local branch=$(git rev-parse --abbrev-ref HEAD)

    # 5. 如果没有提供参数，直接打开仓库主页
    if [ -z "$1" ]; then
        open "$base_url/tree/$branch"
        return
    fi

    # 6. 获取文件的相对路径（处理在子目录下执行命令的情况）
    local file_path=$(git ls-files --full-name "$1")

    if [[ -z "$file_path" ]]; then
        echo "Error: File '$1' not found in git index."
        return 1
    fi

    # 7. 拼接成完整 URL 并打开
    local final_url="$base_url/blob/$branch/$file_path"
    echo "Opening: $final_url"
    open "$final_url"
}

alias gh-pr='gh pr view --web'
