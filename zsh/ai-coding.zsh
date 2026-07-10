# OpenCode
alias oc='OH_MY_OPENCODE_SLIM_PRESET=normal opencode'
alias ocg='OH_MY_OPENCODE_SLIM_PRESET=go opencode'
alias ocl='OH_MY_OPENCODE_SLIM_PRESET=lite opencode'
alias ocn='OH_MY_OPENCODE_SLIM_PRESET=normal opencode'
alias ocb='OH_MY_OPENCODE_SLIM_PRESET=backup opencode'
alias ocf='OH_MY_OPENCODE_SLIM_PRESET=fast opencode'
export PATH=/Users/william/.opencode/bin:$PATH

# Codex
alias cx='codex'
alias ca='codex app'

# Google Vertex AI for OpenCode.
# OpenCode reads Vertex auth from standard GCP env vars.
export GOOGLE_APPLICATION_CREDENTIALS=/Users/william/.iconfig/refly-cloud-d78b83d1ba60.json
export GOOGLE_CLOUD_PROJECT=refly-cloud
export VERTEX_LOCATION=global

# Claude Code
alias cc='claude --plugin-dir /Users/william/projects/zest-dev/plugin'
alias ccz='claude --plugin-dir /Users/william/projects/zest-dev/plugin'
alias cczr='claude --plugin-dir /Users/william/projects/zest-dev/plugin --plugin-dir /Users/william/projects/vibe-coding/plugins/refly-dev'
