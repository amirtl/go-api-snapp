FROM golang:1.19 AS builder

WORKDIR /go/src/as-search
COPY . .
COPY *.yaml .

RUN GO111MODULE=on CGO_ENABLED=1 GOOS=linux go build -ldflags="-extldflags=-static" -a -installsuffix nocgo -tags=nomsgpack -o /app cmd/main.go

FROM debian:buster-slim

EXPOSE 8080
COPY --from=builder /app ./
COPY config.yaml .

ENTRYPOINT ["./app"]
