#!/usr/bin/env zsh

# 注意：这里通过 glob 自动加载所有 *.zsh 文件。
# glob 匹配得到的加载顺序不应被业务依赖；如需固定顺序，请显式维护。

local __all_dir="${0:A:h}"
local __all_file

for __all_file in "${__all_dir}"/*.zsh(.N); do
  [[ "${__all_file:t}" == "__all__.zsh" ]] && continue
  source "${__all_file}"
done

unset __all_dir __all_file
