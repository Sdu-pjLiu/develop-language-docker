FROM golang:1.25-bookworm

RUN go install github.com/go-delve/delve/cmd/dlv@v1.24.0 \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.61.0

WORKDIR /workspace
