#!/usr/bin/env bash
# 语言容器工具链验收

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ALL_SERVICES=(python-3.13 python-3.11 go rust cpp)

usage() {
    echo "Usage: $0 [target...]" >&2
    echo "  target: python-3.13 | python-3.11 | go | rust | cpp | all (default: all)" >&2
    exit 1
}

resolve_services() {
    local -a targets=("$@")
    local -a resolved=()

    if ((${#targets[@]} == 0)); then
        printf '%s\n' "${ALL_SERVICES[@]}"
        return
    fi

    for target in "${targets[@]}"; do
        if [[ "$target" == "all" ]]; then
            resolved+=("${ALL_SERVICES[@]}")
            continue
        fi
        local found=0
        for svc in "${ALL_SERVICES[@]}"; do
            if [[ "$target" == "$svc" ]]; then
                resolved+=("$svc")
                found=1
                break
            fi
        done
        if [[ "$found" -eq 0 ]]; then
            echo "Unknown target: $target" >&2
            exit 1
        fi
    done

    local -A seen=()
    local -a unique=()
    for svc in "${resolved[@]}"; do
        if [[ -z "${seen[$svc]:-}" ]]; then
            seen[$svc]=1
            unique+=("$svc")
        fi
    done

    printf '%s\n' "${unique[@]}"
}

NO_GLOBAL_TOOLS='! command -v git && ! command -v curl'

verify_python_cmd() {
    cat <<'EOF'
set -e
python -V
pip -V
ruff --version
pyright --version
python -c "import debugpy"
python -m venv /tmp/tvenv
/tmp/tvenv/bin/pip -V
! command -v git && ! command -v curl
EOF
}

verify_go_cmd() {
    cat <<EOF
set -e
go version
golangci-lint --version
dlv version
gofmt -h >/dev/null 2>&1
${NO_GLOBAL_TOOLS}
EOF
}

verify_rust_cmd() {
    cat <<EOF
set -e
rustc --version
rustfmt --version
cargo clippy -V
lldb --version
${NO_GLOBAL_TOOLS}
EOF
}

verify_cpp_cmd() {
    cat <<EOF
set -e
gcc --version
cmake --version
ninja --version
clang-format --version
clang-tidy --version
clangd --version
gdb --version
${NO_GLOBAL_TOOLS}
EOF
}

run_checks() {
    local service="$1"
    local cmd=""

    case "$service" in
        python-3.13|python-3.11) cmd="$(verify_python_cmd)" ;;
        go) cmd="$(verify_go_cmd)" ;;
        rust) cmd="$(verify_rust_cmd)" ;;
        cpp) cmd="$(verify_cpp_cmd)" ;;
        *)
            echo "No checks defined for: $service" >&2
            return 1
            ;;
    esac

    docker compose run --rm "$service" sh -c "$cmd"
}

mapfile -t SERVICES < <(resolve_services "$@")

FAIL=0
for service in "${SERVICES[@]}"; do
    echo "==> verify $service"
    if run_checks "$service"; then
        echo "PASS: $service"
    else
        echo "FAIL: $service"
        FAIL=1
    fi
done

exit "$FAIL"
