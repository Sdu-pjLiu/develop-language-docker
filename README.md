# develop_lang

五语言开发运行时与工具链 Docker 容器（Python 3.13/3.11、Go、Rust、C/C++）。

详细规格见 [docs/spec.md](docs/spec.md)。

## 快速开始

```bash
docker compose build
./scripts/verify-env.sh all
./scripts/container.sh start all
./scripts/container.sh stop all
```

## 脚本用法

### 启停（container.sh）

```bash
./scripts/container.sh start python-3.13
./scripts/container.sh start python-3.13 go rust
./scripts/container.sh stop all
./scripts/container.sh restart cpp
```

合法 target：`python-3.13` | `python-3.11` | `go` | `rust` | `cpp` | `all`

### 验收（verify-env.sh）

```bash
./scripts/verify-env.sh all
./scripts/verify-env.sh python-3.13 go
```

验收使用 `docker compose run --rm`，无需先 start。
