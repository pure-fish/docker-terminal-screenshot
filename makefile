# Makefile for purefish/terminal-screenshot
# Pre-built image with Chromium, Puppeteer, and terminal-screenshot CLI

FISH_VERSION ?= 4.0.2
IMAGE_NAME ?= purefish/terminal-screenshot
TAG ?= fish-$(FISH_VERSION)

# fail on first error
SHELL := /bin/bash
.SHELLFLAGS := -e -c

.PHONY: help build test push clean

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo " Building $(IMAGE_NAME):$(TAG) with Fish $(FISH_VERSION)"
	docker build \
		--file Dockerfile \
		--build-arg FISH_VERSION=$(FISH_VERSION) \
		--tag $(IMAGE_NAME):$(TAG) \
		--tag $(IMAGE_NAME):latest \
		.

test: ## Test the built image
	@echo "Testing terminal-screenshot installation..."
	docker run --rm $(IMAGE_NAME):$(TAG) "terminal-screenshot --help"
	@echo "Testing fish version..."
	docker run --rm $(IMAGE_NAME):$(TAG) "fish --version"
	@echo "Testing Chromium..."
	docker run --rm $(IMAGE_NAME):$(TAG) "chromium-browser --version"

push: ## Push image to Docker Hub
	@echo " Pushing $(IMAGE_NAME):$(TAG)"
	docker push $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):latest

clean: ## Remove local images
	docker rmi $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest || true

all: build test ## Build and test
