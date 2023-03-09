# stage 1: builder
FROM golang:1.19.3-alpine AS builder

RUN apk update \
  && apk -U upgrade \
  && apk add build-base

ENV CGO_ENABLED=0
ENV GO111MODULE=on
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /src

COPY go.sum go.mod ./
COPY main.go ./
COPY handlers ./handlers
COPY models ./models

RUN go mod download

RUN CGO_ENABLED=$CGO_ENABLED go build -installsuffix cgo -o ./bin/app ./

# stage 2: runner
FROM gcr.io/distroless/static:nonroot

COPY --from=builder --chown=nonroot "/src/bin/app" "/app"

ENTRYPOINT ["/app"]
