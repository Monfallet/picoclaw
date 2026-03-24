FROM golang:1.26-alpine AS builder
WORKDIR /app

# 1. Instalamos compiladores de C y la famosa librería olm para desarrollo
RUN apk add --no-cache gcc musl-dev olm-dev

COPY . .

# 2. Encendemos CGO porque PicoClaw lo exige
ENV CGO_ENABLED=1

RUN mkdir -p cmd/picoclaw/internal/onboard/workspace && touch cmd/picoclaw/internal/onboard/workspace/dummy.txt
RUN go build -o picoclaw ./cmd/picoclaw

FROM alpine:latest
WORKDIR /app

# 3. Instalamos la librería olm normal para que el bot pueda ejecutarse
RUN apk add --no-cache ca-certificates olm

COPY --from=builder /app/picoclaw .
CMD ["./picoclaw", "gateway"]
