# --- Stage 1: The Build Environment ---
FROM ubuntu:noble AS builder

# Install dependencies
RUN apt-get update && apt-get install -y     wget     unzip     python3     && rm -rf /var/lib/apt/lists/*

# Set Godot version (Adjust to your exact 2026 version if different)
ENV GODOT_VERSION=4.4
ENV RELEASE_NAME=stable

# Download Godot Headless and Export Templates
RUN wget https://github.com/godotengine/godot/releases/download/-/Godot_v-_linux_headless.64.zip     && unzip Godot_v-_linux_headless.64.zip     && mv Godot_v-_linux_headless.64 /usr/local/bin/godot     && chmod +x /usr/local/bin/godot

RUN wget https://github.com/godotengine/godot/releases/download/-/Godot_v-_export_templates.tpz     && mkdir -p ~/.local/share/godot/export_templates/.     && unzip Godot_v-_export_templates.tpz     && mv templates/* ~/.local/share/godot/export_templates/./     && rm -rf templates Godot_v-_export_templates.tpz

# Build the project
WORKDIR /src
COPY . .
RUN mkdir -p build/web
RUN godot --headless --export-release Web build/web/index.html

# --- Stage 2: The Web Server ---
FROM nginx:alpine

# Copy the build files from the first stage
COPY --from=builder /src/build/web /usr/share/nginx/html

# VERY IMPORTANT: Add the COOP/COEP headers for SharedArrayBuffer
RUN sed -i 's/location \/ {/location \/ {
        add_header Cross-Origin-Opener-Policy same-origin;
        add_header Cross-Origin-Embedder-Policy require-corp;/' /etc/nginx/conf.d/default.conf

EXPOSE 80
