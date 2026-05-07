# tmux-config

我的个人 tmux 配置，包含常用快捷键、鼠标支持、状态栏美化、自动 session 恢复等。

## 一键安装 / 同步

在任意机器上执行：

```bash
curl -fsSL https://raw.githubusercontent.com/KrisWonka/tmux-config/main/install.sh | bash
```

脚本会自动：
1. 备份已有的 `~/.tmux.conf` 为 `~/.tmux.conf.bak`
2. 拉取最新配置到 `~/.tmux.conf`
3. 安装 [tpm](https://github.com/tmux-plugins/tpm) 插件管理器（如未安装）
4. 自动安装所有插件

安装脚本会在检测到运行中的 tmux server 时自动 reload 配置；如果没在跑，下次 `tmux` 启动就直接用新配置。

## 常用命令（在 shell 中执行）

### 启动 / 进入 session

| 命令 | 功能 |
|---|---|
| `tmux` | 启动一个新的 tmux session（默认名 `0`、`1`...） |
| `tmux new -s <name>` | 启动一个具名 session，例如 `tmux new -s dev` |
| `tmux a` 或 `tmux attach` | 重新连接到上一个 session |
| `tmux a -t <name>` | 连接到指定 session，例如 `tmux a -t dev` |
| `tmux a -d -t <name>` | 连接并把其它已连接的客户端踢下线（适合从另一台机器抢回） |

### 查看 / 管理 session

| 命令 | 功能 |
|---|---|
| `tmux ls` | 列出所有运行中的 session |
| `tmux rename-session -t <old> <new>` | 重命名 session |
| `tmux kill-session -t <name>` | 关闭指定 session |
| `tmux kill-server` | 关闭整个 tmux server（**所有 session 一起没**） |

### 配置 / 调试

| 命令 | 功能 |
|---|---|
| `tmux source-file ~/.tmux.conf` | 让正在运行的 tmux server 重新加载配置（不需要重启） |
| `tmux show -g prefix` | 查看当前生效的前缀键（验证配置是否生效） |
| `tmux list-keys` | 列出所有快捷键绑定（信息量大，建议管道接 `less`） |

### Session 持久化（resurrect 插件）

| 命令 | 功能 |
|---|---|
| `<prefix>` + `Ctrl+s` | 在 tmux 内手动保存所有 session 状态 |
| `<prefix>` + `Ctrl+r` | 在 tmux 内手动恢复上次保存的 session |

> 配置中已开启 `tmux-continuum` 自动每 15 分钟保存，并在 tmux 启动时自动恢复，通常无需手动操作。

### 典型工作流

```bash
# 第一次进入远程机器
tmux new -s work          # 启动名为 work 的 session

# 中途断开 ssh / 关闭终端 —— session 仍在后台运行

# 重新连上来
ssh remote
tmux a -t work            # 回到原来的 session，所有进程还活着
```

## 前缀键

**前缀键已改为 `Ctrl+a`**（默认是 `Ctrl+b`）。下文中 `<prefix>` 即代表 `Ctrl+a`。

## 快捷键一览

### 分屏（Pane）

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `\` | 横向分屏（左右），新分屏继承当前路径 |
| `<prefix>` + `-` | 纵向分屏（上下），新分屏继承当前路径 |
| `Alt + ←` | 切换到左侧分屏（无需前缀） |
| `Alt + →` | 切换到右侧分屏（无需前缀） |
| `Alt + ↑` | 切换到上方分屏（无需前缀） |
| `Alt + ↓` | 切换到下方分屏（无需前缀） |
| `<prefix>` + `x` | 关闭当前分屏（tmux 默认） |
| `<prefix>` + `z` | 当前分屏全屏切换（tmux 默认） |
| `<prefix>` + `{` / `}` | 与上 / 下分屏交换位置（tmux 默认） |
| `<prefix>` + `q` | 显示分屏编号（tmux 默认） |

### 窗口（Window）

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `c` | 新建窗口，继承当前路径 |
| `<prefix>` + `n` | 切换到下一个窗口（tmux 默认） |
| `<prefix>` + `p` | 切换到上一个窗口（tmux 默认） |
| `<prefix>` + 数字 | 切换到对应编号的窗口（tmux 默认，**编号从 1 开始**） |
| `<prefix>` + `,` | 重命名当前窗口（tmux 默认） |
| `<prefix>` + `&` | 关闭当前窗口（tmux 默认） |
| `<prefix>` + `w` | 列出所有窗口选择（tmux 默认） |

### 会话（Session）

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `d` | 分离当前会话（detach，tmux 默认） |
| `<prefix>` + `s` | 列出所有会话选择（tmux 默认） |
| `<prefix>` + `$` | 重命名当前会话（tmux 默认） |
| `<prefix>` + `(` / `)` | 切换上 / 下一个会话（tmux 默认） |

### 复制模式

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `[` | 进入复制模式（tmux 默认，可用方向键 / vi 键翻页） |
| `q` | 退出复制模式（tmux 默认） |
| `<prefix>` + `]` | 粘贴最近的复制内容（tmux 默认） |

### 配置

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `r` | 重新加载 `~/.tmux.conf` 并提示「配置已重载」 |
| `<prefix>` + `?` | 显示所有快捷键绑定（tmux 默认） |

### 鼠标操作（已开启 `mouse on`）

- 点击分屏 → 切换焦点
- 拖拽分屏边界 → 调整大小
- 滚轮 → 上下翻页（自动进入复制模式）
- 选中文本 → 自动复制

## 其他默认行为修改

| 项目 | 默认 | 本配置 |
|---|---|---|
| 窗口编号起点 | `0` | `1` |
| 分屏编号起点 | `0` | `1` |
| 鼠标支持 | 关闭 | 开启 |
| 状态栏样式 | 绿底黑字 | 深灰底白字，左侧 session 名，右侧时间 `HH:MM` |

## 插件（通过 tpm 管理）

- **[tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)** — 一组通用合理默认（自动设置 `escape-time=0`、`history-limit=50000` 等）
- **[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)** — 保存 / 恢复 session（含 vim、ssh 会话）
  - `<prefix>` + `Ctrl+s` 手动保存
  - `<prefix>` + `Ctrl+r` 手动恢复
- **[tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)** — 每 15 分钟自动保存，tmux 启动时自动恢复

### 插件管理快捷键（tpm）

| 快捷键 | 功能 |
|---|---|
| `<prefix>` + `I` | 安装新插件 |
| `<prefix>` + `U` | 更新插件 |
| `<prefix>` + `Alt + u` | 卸载未在配置中列出的插件 |

## 文件说明

- `.tmux.conf` — tmux 主配置
- `install.sh` — 一键安装脚本
