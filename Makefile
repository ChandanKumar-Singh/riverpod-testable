.PHONY: help install setup test build clean format analyze coverage docs docker-up docker-down server

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo '$(BLUE)Available commands:$(NC)'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Install fvm Flutter dependencies
	@echo '$(BLUE)Installing dependencies...$(NC)'
	fvm flutter pub get
	cd server && npm install

setup: ## Initial project setup
	@echo '$(BLUE)Setting up project...$(NC)'
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo '$(GREEN)Created .env file from .env.example$(NC)'; \
	fi
	fvm flutter pub get
	fvm flutter pub run build_runner build --delete-conflicting-outputs
	cd server && npm install
	@echo '$(GREEN)Setup complete!$(NC)'

test: ## Run tests
	@echo '$(BLUE)Running tests...$(NC)'
	fvm flutter test

test-coverage: ## Run tests with coverage
	@echo '$(BLUE)Running tests with coverage...$(NC)'
	fvm flutter test --coverage
	@echo '$(GREEN)Coverage report generated in coverage/lcov.info$(NC)'

build: ## Build the app for all platforms
	@echo '$(BLUE)Building app...$(NC)'
	fvm flutter build apk --release
	fvm flutter build ios --release --no-codesign
	@echo '$(GREEN)Build complete!$(NC)'

build-android: ## Build Android APK
	@echo '$(BLUE)Building Android APK...$(NC)'
	fvm flutter build apk --release

build-ios: ## Build iOS app
	@echo '$(BLUE)Building iOS app...$(NC)'
	fvm flutter build ios --release --no-codesign

build-web: ## Build web app
	@echo '$(BLUE)Building web app...$(NC)'
	fvm flutter build web

clean: ## Clean build files
	@echo '$(BLUE)Cleaning...$(NC)'
	fvm flutter clean
	cd server && rm -rf node_modules
	@echo '$(GREEN)Clean complete!$(NC)'

format: ## Format code
	@echo '$(BLUE)Formatting code...$(NC)'
	dart format .

format-check: ## Check code formatting
	@echo '$(BLUE)Checking code format...$(NC)'
	dart format --output=none --set-exit-if-changed .

analyze: ## Analyze code
	@echo '$(BLUE)Analyzing code...$(NC)'
	fvm flutter analyze

generate: ## Generate code (build_runner)
	@echo '$(BLUE)Generating code...$(NC)'
	fvm flutter pub run build_runner build --delete-conflicting-outputs

generate-watch: ## Generate code in watch mode
	@echo '$(BLUE)Generating code in watch mode...$(NC)'
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

coverage: test-coverage ## Alias for test-coverage
	@echo '$(GREEN)Coverage report available in coverage/lcov.info$(NC)'

docs: ## Generate documentation
	@echo '$(BLUE)Generating documentation...$(NC)'
	dart doc
	@echo '$(GREEN)Documentation generated in doc/api$(NC)'

docker-up: ## Start Docker containers
	@echo '$(BLUE)Starting Docker containers...$(NC)'
	docker-compose up -d
	@echo '$(GREEN)Docker containers started!$(NC)'

docker-down: ## Stop Docker containers
	@echo '$(BLUE)Stopping Docker containers...$(NC)'
	docker-compose down
	@echo '$(GREEN)Docker containers stopped!$(NC)'

server: ## Start development server
	@echo '$(BLUE)Starting development server...$(NC)'
	cd server && npm run dev

server-install: ## Install server dependencies
	@echo '$(BLUE)Installing server dependencies...$(NC)'
	cd server && npm install

run: ## Run the app
	@echo '$(BLUE)Running app...$(NC)'
	fvm flutter run

run-dev: ## Run app in development mode
	@echo '$(BLUE)Running app in development mode...$(NC)'
	fvm flutter run --dart-define=ENV=dev

run-prod: ## Run app in production mode
	@echo '$(BLUE)Running app in production mode...$(NC)'
	fvm flutter run --dart-define=ENV=prod --release

lint: analyze ## Alias for analyze

check: format-check analyze test ## Run all checks (format, analyze, test)
	@echo '$(GREEN)All checks passed!$(NC)'

pre-commit: format-check analyze ## Run pre-commit checks
	@echo '$(GREEN)Pre-commit checks passed!$(NC)'

ci: install generate analyze test ## Run CI pipeline locally
	@echo '$(GREEN)CI pipeline completed successfully!$(NC)'

