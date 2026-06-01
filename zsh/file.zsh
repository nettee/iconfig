# 获取文件/目录的绝对路径
als() {
  local abs_path

  if [ $# -eq 0 ]; then
    # 如果没有参数，输出当前目录
    abs_path="$(pwd)"
  else
    # 如果有参数，输出参数的绝对路径
    # :a 是 ZSH 特有的修饰符，用于获取绝对路径
    abs_path="${1:a}"
  fi

  print -r -- "$abs_path"
  print -rn -- "$abs_path" | /usr/bin/pbcopy
}

# 获取绝对路径相对于当前目录的相对路径
rls() {
  local abs_path rel_path

  if [ $# -eq 0 ]; then
    print -u2 -- "usage: rls <absolute-path>"
    return 1
  fi

  abs_path="$1"
  if [[ "$abs_path" != /* ]]; then
    print -u2 -- "rls: expected absolute path: $abs_path"
    return 1
  fi

  rel_path="$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], os.getcwd()))' "$abs_path")" || return

  print -r -- "$rel_path"
  print -rn -- "$rel_path" | /usr/bin/pbcopy
}
