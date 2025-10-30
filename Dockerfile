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
    puppeteer@21.10.0
USER nemo

FROM with-js-tools-installed AS with-terminal-screenshot-installed
# Build and install terminal-screenshot
USER root
WORKDIR /home/nemo
RUN git clone \
    --depth 1 \
    --branch feat/add-color-scheme-support \
    https://github.com/edouard-lopez/terminal-screenshot.git \
    && cd terminal-screenshot \
    && yarn install --frozen-lockfile \
    && yarn cache clean \
    && yarn build \
    && mkdir -p /usr/local/lib/terminal-screenshot \
    && cp -r out /usr/local/lib/terminal-screenshot/ \
    && cp -r node_modules /usr/local/lib/terminal-screenshot/ \
    && ln -s /usr/local/lib/terminal-screenshot/out/src/cli.js /usr/local/bin/terminal-screenshot \
    && chmod +x /usr/local/bin/terminal-screenshot 
USER nemo

FROM with-terminal-screenshot-installed AS final
USER root

# cleaning
WORKDIR /home/nemo
RUN rm -rf terminal-screenshot /root/.npm /tmp/* \
    && npm cache clean --force \
    && rm -rf /root/.npm /tmp/*
USER nemo

# Verify installation
RUN terminal-screenshot --help

ENTRYPOINT ["fish", "-c"]
CMD ["terminal-screenshot --help"]
