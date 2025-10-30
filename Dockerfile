# Dockerfile for terminal-screenshot
# Pre-built image with Chromium, Puppeteer, and terminal-screenshot CLI
# Published as: purefish/terminal-screenshot

ARG FISH_VERSION=4.0.2
FROM purefish/docker-fish:${FISH_VERSION} AS base-image

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

FROM base-image AS with-os-requirements
USER root
# Install Chromium, fonts, and Node.js
# hadolint ignore=DL3018
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm \
    font-noto \
    font-noto-emoji
USER nemo

# Configure Puppeteer to use system Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

FROM with-os-requirements AS with-js-tools-installed
USER root
# Install Yarn and Puppeteer (pinned versions)
RUN npm install --global \
    yarn@1.22.22 \
    puppeteer@21.10.0 \
 && npm cache clean --force \
 && rm -rf /root/.npm /tmp/*
USER nemo

FROM with-js-tools-installed AS with-terminal-screenshot-installed
# Build and install terminal-screenshot
USER root
RUN git clone --depth 1 https://github.com/edouard-lopez/terminal-screenshot.git --branch feat/add-color-scheme-support \
 && cd terminal-screenshot \
 && yarn install --production --frozen-lockfile \
 && yarn cache clean \
 && yarn build \
 && mkdir -p /usr/local/lib/terminal-screenshot \
 && cp -r out /usr/local/lib/terminal-screenshot/ \
 && cp -r node_modules /usr/local/lib/terminal-screenshot/ \
 && ln -s /usr/local/lib/terminal-screenshot/out/src/cli.js /usr/local/bin/terminal-screenshot \
 && chmod +x /usr/local/bin/terminal-screenshot \
 && cd .. \
 && rm -rf terminal-screenshot /root/.npm /tmp/*
USER nemo

FROM with-terminal-screenshot-installed AS final
USER nemo
WORKDIR /home/nemo

# Verify installation
RUN terminal-screenshot --help

ENTRYPOINT ["fish", "-c"]
CMD ["terminal-screenshot --help"]
