FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN mkdir -p cmd/picoclaw/internal/onboard/workspace && touch cmd/picoclaw/internal/onboard/workspace/dummy.txt
RUN go build -o picoclaw ./cmd/picoclaw

FROM alpine:latest
WORKDIR /app
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw .
CMD ["./picoclaw", "gateway"]
