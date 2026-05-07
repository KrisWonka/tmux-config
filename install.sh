#!/usr/bin/env bash
# tmux-config 一键安装 / 同步脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/KrisWonka/tmux-config/main/install.sh | bash

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/KrisWonka/tmux-config/main"
TARGET="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "==> 同步 tmux 配置..."

# 备份已有配置
if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
  BACKUP="$TARGET.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$TARGET" "$BACKUP"
  echo "    已备份原配置到: $BACKUP"
fi

# 拉取最新 .tmux.conf
curl -fsSL "$REPO_RAW/.tmux.conf" -o "$TARGET"
echo "    .tmux.conf 已更新"

# 安装 tpm
if [ ! -d "$TPM_DIR" ]; then
  echo "==> 安装 tpm 插件管理器..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "==> tpm 已存在，跳过克隆"
fi

# 自动安装所有插件（无需进入 tmux）
echo "==> 安装 / 更新插件..."
"$TPM_DIR/bin/install_plugins" >/dev/null 2>&1 || true
"$TPM_DIR/bin/update_plugins" all >/dev/null 2>&1 || true

# 如果已有运行中的 tmux server，自动 reload 配置（让所有现有 session 立即生效）
if tmux ls >/dev/null 2>&1; then
  echo "==> 检测到运行中的 tmux server，自动 reload 配置..."
  tmux source-file "$TARGET"
  echo "    所有现有 session 已生效新配置"
fi

echo ""
echo "✅ 完成！直接进 tmux 就能用新配置了"
