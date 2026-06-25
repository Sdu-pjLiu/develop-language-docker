#!/usr/bin/env bash
# 语言容器生命周期：start | stop | restart

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ALL_SERVICES=(python-3.13 python-3.11 go rust cpp)

usage() {
    echo "Usage: $0 <start|stop|restart> [target...]" >&2
    echo "  target: python-3.13 | python-3.11 | go | rust | cpp | all" >&2
    exit 1
}

resolve_services() {
    local -a targets=("$@")
    local -a resolved=()

    if ((${#targets[@]} == 0)); then
        usage
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

    if ((${#resolved[@]} == 0)); then
        echo "No services selected." >&2
        exit 1
    fi

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

ACTION="${1:-}"
shift || usage

case "$ACTION" in
    start|stop|restart) ;;
    *) usage ;;
esac

mapfile -t SERVICES < <(resolve_services "$@")

case "$ACTION" in
    start)
        docker compose up -d "${SERVICES[@]}"
        ;;
    stop)
        docker compose stop "${SERVICES[@]}"
        ;;
    restart)
        docker compose restart "${SERVICES[@]}"
        ;;
esac
