#!/bin/bash

# Setup script for Testable Flutter App
# This script sets up the development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if Flutter is installed
check_flutter() {
    print_info "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter is installed: $FLUTTER_VERSION"
    else
        print_error "Flutter is not installed. Please install Flutter first."
        exit 1
    fi
}

# Check if Dart is installed
check_dart() {
    print_info "Checking Dart installation..."
    if command -v dart &> /dev/null; then
        DART_VERSION=$(dart --version)
        print_success "Dart is installed: $DART_VERSION"
    else
        print_error "Dart is not installed. Please install Dart first."
        exit 1
    fi
}

# Check if Node.js is installed
check_node() {
    print_info "Checking Node.js installation..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js is installed: $NODE_VERSION"
    else
        print_warning "Node.js is not installed. Server will not work."
    fi
}

# Create .env file if it doesn't exist
setup_env() {
    print_info "Setting up environment variables..."
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            print_success "Created .env file from .env.example"
        else
            print_warning ".env.example not found. Please create .env manually."
        fi
    else
        print_info ".env file already exists"
    fi
}

# Install Flutter dependencies
install_flutter_deps() {
    print_info "Installing Flutter dependencies..."
    flutter pub get
    print_success "Flutter dependencies installed"
}

# Generate code
generate_code() {
    print_info "Generating code..."
    flutter pub run build_runner build --delete-conflicting-outputs
    print_success "Code generated"
}

# Install server dependencies
install_server_deps() {
    print_info "Installing server dependencies..."
    if [ -d "server" ] && command -v npm &> /dev/null; then
        cd server
        npm install
        cd ..
        print_success "Server dependencies installed"
    else
        print_warning "Server directory not found or npm not installed. Skipping server setup."
    fi
}

# Main setup function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Testable Flutter App - Setup Script                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_flutter
    check_dart
    check_node
    setup_env
    install_flutter_deps
    generate_code
    install_server_deps
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Setup completed successfully!                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Update .env file with your configuration"
    echo "  2. Start the server: make server"
    echo "  3. Run the app: make run"
    echo ""
}

# Run main function
main

