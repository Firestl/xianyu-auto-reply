#!/usr/bin/env bash

set -Eeuo pipefail

log() {
  printf '[deploy] %s\n' "$1"
}

fail() {
  printf '[deploy] %s\n' "$1" >&2
  exit 1
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    fail "缺少命令: $1"
  fi
}

resolve_compose_cmd() {
  if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD=(docker compose)
    return
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD=(docker-compose)
    return
  fi

  fail '未检测到 docker compose 或 docker-compose'
}

maybe_enable_sudo() {
  if [ "${USE_SUDO:-false}" = 'true' ]; then
    require_command sudo
    DOCKER_CMD_PREFIX=(sudo)
  else
    DOCKER_CMD_PREFIX=()
  fi
}

main() {
  require_command git
  require_command docker
  maybe_enable_sudo
  resolve_compose_cmd

  DEPLOY_PATH="${DEPLOY_PATH:-}"
  DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
  COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"
  COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-xianyu-auto-reply}"
  COMPOSE_PROFILE="${COMPOSE_PROFILE:-}"
  SERVICES="${SERVICES:-}"
  GIT_REMOTE="${GIT_REMOTE:-origin}"

  [ -n "$DEPLOY_PATH" ] || fail 'DEPLOY_PATH 未设置'
  [ -d "$DEPLOY_PATH" ] || fail "部署目录不存在: $DEPLOY_PATH"

  cd "$DEPLOY_PATH"

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "不是 Git 仓库: $DEPLOY_PATH"

  log "切换到部署目录: $DEPLOY_PATH"
  log "拉取远程分支: ${GIT_REMOTE}/${DEPLOY_BRANCH}"
  git fetch "$GIT_REMOTE" --prune
  git checkout -B "$DEPLOY_BRANCH" "$GIT_REMOTE/$DEPLOY_BRANCH"
  git reset --hard "$GIT_REMOTE/$DEPLOY_BRANCH"

  compose_args=(-f "$COMPOSE_FILE" -p "$COMPOSE_PROJECT_NAME")
  if [ -n "$COMPOSE_PROFILE" ]; then
    compose_args+=(--profile "$COMPOSE_PROFILE")
  fi

  if [ -n "$SERVICES" ]; then
    read -r -a service_args <<<"$SERVICES"
  else
    service_args=()
  fi

  log '开始重建并重启 Docker 容器'
  "${DOCKER_CMD_PREFIX[@]}" "${COMPOSE_CMD[@]}" "${compose_args[@]}" up -d --build --remove-orphans "${service_args[@]}"

  log '当前容器状态'
  "${DOCKER_CMD_PREFIX[@]}" "${COMPOSE_CMD[@]}" "${compose_args[@]}" ps

  log '部署完成'
}

main "$@"
