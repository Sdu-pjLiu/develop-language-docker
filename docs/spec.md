# develop_lang 规格说明

语言运行时与工具链容器：五语言完全分离，Host 负责 git/curl/IDE，容器仅含 runtime + toolchain。

## 边界

| 层级 | 职责 |
|------|------|
| Host (WSL2) | git、curl、IDE、Docker CLI |
| 本仓库 | 5 个语言 Dockerfile、compose、启停脚本、验收脚本 |

**镜像内禁止**：git、curl、wget、ssh、vim 及非语言工具链的通用 OS 工具。

**不做**：`.devcontainer`、IDE 配置、镜像内 git/curl、Node 容器。

## 目录结构

```text
develop_lang/
├── docker-compose.yml
├── docs/spec.md
├── scripts/container.sh
├── scripts/verify-env.sh
├── python-3.13/Dockerfile
├── python-3.11/Dockerfile
├── go/Dockerfile
├── rust/Dockerfile
└── cpp/Dockerfile
```

每目录 = 1 容器 = 1 Dockerfile，无 shared base、无跨目录 COPY。

## 五容器

| 目录 | Service | container_name | 镜像 tag | 角色 |
|------|---------|----------------|----------|------|
| python-3.13 | python-3.13 | devlang-python-3.13 | devlang/python:3.13-dev | 主开发 Python |
| python-3.11 | python-3.11 | devlang-python-3.11 | devlang/python:3.11-dev | legacy 兼容 |
| go | go | devlang-go | devlang/go:1.25-dev | Go toolchain |
| rust | rust | devlang-rust | devlang/rust:1.84-dev | Rust toolchain |
| cpp | cpp | devlang-cpp | devlang/cpp:24.04-dev | C/C++ toolchain |

## 工具链

| 容器 | Format | Lint | Type | 语言服务 | Debug |
|------|--------|------|------|----------|-------|
| python-3.13 | ruff format | ruff check | pyright | Host IDE | debugpy |
| python-3.11 | ruff format | ruff check | pyright | Host IDE | debugpy |
| go | gofmt | golangci-lint | — | Host IDE | delve |
| rust | rustfmt | clippy | — | Host IDE | lldb |
| cpp | clang-format | clang-tidy | — | clangd | gdb |

**使用约定（非镜像安装项）**：Python 项目用 venv；Go 用 go mod；C++ 用 cmake+ninja。

### 镜像内安装清单

**python-3.13 / python-3.11**

- apt: build-essential
- pip: pip, setuptools, wheel, ruff, pyright, debugpy

**go**

- go install: dlv@v1.24.0, golangci-lint@v1.61.0

**rust**

- apt: pkg-config, libssl-dev, lldb
- rustup component: rustfmt, clippy

**cpp**

- apt: build-essential, gcc, g++, cmake, ninja-build, clang-format, clang-tidy, clangd, gdb, pkg-config

## Compose 配置

- `volumes: .:/workspace`、`working_dir: /workspace`
- 无 `.env`、无 USER_ID/GROUP_ID、无 restart、无 networks、无 build.args

## 脚本

### container.sh

```bash
./scripts/container.sh <start|stop|restart> [target...]
# target: python-3.13 | python-3.11 | go | rust | cpp | all
```

### verify-env.sh

```bash
./scripts/verify-env.sh [target...]   # 默认 all
```

始终 `docker compose run --rm`；不依赖容器已 start。

## 快速开始

```bash
docker compose build
./scripts/verify-env.sh all
./scripts/container.sh start all
./scripts/container.sh stop all
```
