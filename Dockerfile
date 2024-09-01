# In order to add cross-compilation, we can use the BUILDPLATFORM argument
# This way the pulled image is always native to the current machine (e.g. linux/amd64)
FROM --platform=$BUILDPLATFORM golang:1.23 AS build
WORKDIR /src

# Leverage a cache mount to /go/pkg/mod/ to speed up subsequent builds
# Leverage a bind mount to avoid having to copy the source code into the container
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x

# Architecture from --platform, e.g. amd64
ARG TARGETARCH TARGETOS

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 GOARCH=$TARGETARCH GOOS=$TARGETOS go build -o /bin/server .
 
FROM alpine:3.20.2 AS final

# Create a non-privileged user to run the app
ARG UID=10001
RUN adduser \
    --disabled-password \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

COPY --from=build /bin/server /bin/

EXPOSE 8080

ENTRYPOINT [ "/bin/server" ]
