# Makefile at root of pico-new

PROJECT ?= main_project
BUILD_DIR := build
TTY ?= /dev/ttyACM0
BAUD ?= 115200

.PHONY: all init compile compile-clean flash terminal clean help

# Default target
all: help


help: ## 📖 Help
	@echo "====================================="
	@echo "  Pico Project Makefile Commands     "
	@echo "====================================="
	@awk -F':|##' ' \
		/^## / { \
			heading=substr($$0,4); \
			printf "\n\033[1;32m%s\033[0m\n", heading; \
		} \
		/^[a-zA-Z0-9_.-]+:.*##/ { \
			sub(/^[ \t]+/, "", $$1); \
			sub(/[ \t]+$$/, "", $$1); \
			sub(/^[ \t]+/, "", $$3); \
			sub(/[ \t]+$$/, "", $$3); \
			printf "  \033[36m%-20s\033[0m %s\n", $$1, $$3; \
		} \
	' $(lastword $(MAKEFILE_LIST))

## 🔧 Build
compile: ## Compile the current project
	./compile.sh


compile-clean: ## Clean and recompile the project
	./compile.sh --clean


clean: ## Clean the build directory
	rm -rf $(BUILD_DIR)

## 🚀 Flash & Terminal
flash: ## Flash the compiled project to the Pico
	./flash.sh

terminal: ## Open USB serial terminal via picocom
	picocom -b $(BAUD) $(TTY)
