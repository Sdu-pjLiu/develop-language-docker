FROM golang:1.25-bookworm

RUN go install github.com/go-delve/delve/cmd/dlv@v1.24.0 \
    && go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.4.0

WORKDIR /workspace
