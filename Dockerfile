# Stage 1: Get Gatus
FROM twinproduction/gatus:latest AS builder

# Stage 2: Small runtime image
FROM alpine:3.22

# Create a non-root user
RUN addgroup -S gatus && adduser -S gatus -G gatus

# Copy Gatus from the builder stage
COPY --from=builder /gatus /gatus

# Copy our Gatus configuration
COPY config.yaml /config/config.yaml

# Run as non-root
USER gatus

# Gatus listens on port 8080
EXPOSE 8080

# Start Gatus
ENTRYPOINT ["/gatus"]
