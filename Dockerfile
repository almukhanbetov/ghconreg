# Этап сборки
FROM golang:1.24 AS builder

WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

# 🛠 ВАЖНО: статическая линковка для Alpine
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Финальный минимальный образ
FROM alpine:latest
# Финальный образ с curl
FROM alpine:latest

# 🆕 Устанавливаем curl
RUN apk add --no-cache curl
WORKDIR /root/
COPY --from=builder /app/app .

EXPOSE 8087

CMD ["./app"]
