# --- Stage 1: The Build Environment ---
FROM ubuntu:noble AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set version based on your GitHub list
ENV GODOT_VERSION="4.6.1"
ENV RELEASE_NAME="stable"

# 1. Download the standard Linux 64-bit binary
RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

# 2. Download and install Export Templates
RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME}/ \
    && rm -rf templates Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz

# 3. Build the project
WORKDIR /src
COPY . .
RUN mkdir -p build/web
# We use the standard binary with the --headless flag
RUN godot --headless --export-release "Web" build/web/index.html

# --- Stage 2: The Web Server ---
FROM nginx:alpine

COPY --from=builder /src/build/web /usr/share/nginx/html

# Overwrite default config with the necessary COOP/COEP headers
RUN printf 'server {\n\
    listen 80;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html;\n\
        add_header "Cross-Origin-Opener-Policy" "same-origin";\n\
        add_header "Cross-Origin-Embedder-Policy" "require-corp";\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80