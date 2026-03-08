# GitHub Actions 自动部署说明

本文档用于实现：本地写代码并推送到 GitHub 后，GitHub Actions 自动连接远程服务器，拉取最新代码并重启 Docker 容器。

## 已添加的文件

- `.github/workflows/deploy.yml`：监听 `main` / `master` 分支 push，执行远程部署
- `scripts/deploy/update_and_restart.sh`：服务器端执行的更新脚本

## 工作流程

1. 本地提交并推送代码到 GitHub
2. GitHub Actions 被触发
3. Actions 通过 SSH 登录到服务器
4. 进入服务器上的项目目录
5. 执行 `git fetch` + `git reset --hard origin/<branch>`
6. 执行 `docker compose up -d --build --remove-orphans`
7. 容器完成重建与重启

## 服务器前置条件

部署前请确认服务器已经完成以下准备：

- 已安装 `git`
- 已安装 `docker`
- 已安装 `docker compose` 或 `docker-compose`
- 目标目录中已经 `git clone` 过当前仓库
- 服务器具备拉取 GitHub 仓库的权限

如果仓库是私有仓库，推荐在服务器上配置以下任一方式：

- GitHub Deploy Key（推荐，只读即可）
- 绑定了仓库读取权限的 SSH Key
- Personal Access Token

## GitHub Secrets 配置

在 GitHub 仓库页面进入：`Settings` → `Secrets and variables` → `Actions`，至少新增以下 Secrets：

### 必填

- `DEPLOY_HOST`：服务器 IP 或域名
- `DEPLOY_USER`：SSH 登录用户名
- `DEPLOY_PATH`：服务器上的项目路径，例如 `/opt/xianyu-auto-reply`
- `DEPLOY_SSH_KEY`：用于 GitHub Actions 登录服务器的私钥内容

### 选填

- `DEPLOY_PORT`：SSH 端口，默认 `22`，例如服务器端口是 `2222` 就填 `2222`
- `DEPLOY_HOST_KEY`：服务器主机公钥，填了会比 `ssh-keyscan` 更安全
- `COMPOSE_FILE`：Compose 文件名，默认 `docker-compose.yml`
- `COMPOSE_PROJECT_NAME`：Compose 项目名，默认 `xianyu-auto-reply`
- `COMPOSE_PROFILE`：如需启用 profile，例如 `with-nginx`
- `SERVICES`：仅重启指定服务，例如 `xianyu-app nginx`
- `GIT_REMOTE`：Git 远端名，默认 `origin`
- `USE_SUDO`：服务器执行 Docker 是否需要 `sudo`，填 `true` 或 `false`

## 推荐的服务器初始化步骤

首次部署时，在服务器执行：

```bash
git clone <你的仓库地址> /opt/xianyu-auto-reply
cd /opt/xianyu-auto-reply
mkdir -p data logs backups static/uploads/images
docker compose up -d --build
```

如果你使用的是旧版命令，请将 `docker compose` 替换为 `docker-compose`。

## 分支说明

当前工作流会监听：

- `main`
- `master`

并自动将当前推送分支名作为 `DEPLOY_BRANCH` 传给服务器。

如果你的部署分支不是这两个，请修改 `.github/workflows/deploy.yml` 中的触发分支列表。

手动在 GitHub Actions 页面执行时，也可以直接填写 `deploy_port`，无需修改工作流文件。

## 常见场景

### 0. SSH 使用非 22 端口

将 GitHub Secret `DEPLOY_PORT` 设置为：

```text
2222
```

如果你是从 GitHub Actions 页面手动触发，也可以直接在 `deploy_port` 输入框填写端口号。

### 1. 服务器 Docker 需要 sudo

将 GitHub Secret `USE_SUDO` 设置为：

```text
true
```

同时确保目标用户有执行 Docker 的权限。

### 2. 使用 `docker-compose-cn.yml`

将 GitHub Secret `COMPOSE_FILE` 设置为：

```text
docker-compose-cn.yml
```

### 3. 启用带 Nginx 的 profile

将 GitHub Secret `COMPOSE_PROFILE` 设置为：

```text
with-nginx
```

## 建议

- 建议将服务器项目目录中的 `data/`、`logs/`、`backups/` 持久化保留
- 建议将敏感配置放入服务器本地 `.env` 或挂载文件中，不要直接提交到仓库
- 建议先在服务器手动执行一次 `scripts/deploy/update_and_restart.sh` 对应逻辑，确认环境无误后再启用 Actions

## 手动测试脚本

你也可以在服务器上手动执行：

```bash
cd /opt/xianyu-auto-reply
DEPLOY_PATH=/opt/xianyu-auto-reply \
DEPLOY_BRANCH=main \
COMPOSE_FILE=docker-compose.yml \
bash scripts/deploy/update_and_restart.sh
```

## 故障排查

- SSH 连接失败：检查 `DEPLOY_HOST`、`DEPLOY_PORT`、`DEPLOY_USER`、`DEPLOY_SSH_KEY`
- 仓库拉取失败：检查服务器是否有 GitHub 仓库读取权限
- Docker 重启失败：检查服务器上 `docker compose` 是否可用
- 容器启动失败：在服务器执行 `docker compose logs -f` 查看日志
