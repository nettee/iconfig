function cr() {
  if [[ $# -eq 0 ]]; then
    gh pr comment --body "/cr"
  else
    gh pr comment --body "/cr $*"
  fi
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
