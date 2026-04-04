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
