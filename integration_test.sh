#!/usr/bin/env bash

# Integration Test Runner for Ditonton Flutter App
# This script runs end-to-end integration tests on connected devices/emulators

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEVICE=""
TEST_FILE=""
USE_DRIVE=false
COVERAGE=false
TIMEOUT=600 # 10 minutes in seconds

show_help() {
    printf "${BLUE}Integration Test Runner for Ditonton${NC}\n\n"
    printf "Usage: $0 [OPTIONS]\n\n"
    printf "Runs integration tests on connected devices or emulators.\n\n"
    printf "OPTIONS:\n"
    printf "  -d, --device DEVICE_ID    Specify device ID (use 'flutter devices' to list)\n"
    printf "  -f, --file TEST_FILE      Run specific test file (default: all integration tests)\n"
    printf "  -D, --drive              Use flutter drive instead of flutter test (legacy mode)\n"
    printf "  -c, --coverage           Generate coverage report (flutter test only)\n"
    printf "  -t, --timeout SECONDS    Set timeout in seconds (default: 600)\n"
    printf "  -l, --list-devices       List available devices\n"
    printf "  -h, --help               Show this help message\n\n"
    printf "EXAMPLES:\n"
    printf "  $0                                    # Run all integration tests on default device\n"
    printf "  $0 -d android                        # Run tests on Android device/emulator\n"
    printf "  $0 -d emulator-5554                   # Run tests on specific emulator\n"
    printf "  $0 -f app_test.dart                   # Run specific test file\n"
    printf "  $0 -D -d emulator-5554                # Use flutter drive on emulator\n"
    printf "  $0 -c                                 # Run with coverage report\n\n"
    printf "PREREQUISITES:\n"
    printf "  - Device connected or emulator running\n"
    printf "  - Flutter SDK installed and configured\n"
    printf "  - App must compile successfully\n\n"
    printf "DEVICES:\n"
    printf "  Use 'flutter devices' or '$0 -l' to see available devices\n\n"
}

list_devices() {
    printf "${BLUE}Available devices:${NC}\n"
    flutter devices
}

check_prerequisites() {
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        printf "${RED}Error: Flutter SDK not found. Please install Flutter first.${NC}\n"
        exit 1
    fi

    # Check if we're in a Flutter project
    if ! [ -f "pubspec.yaml" ]; then
        printf "${RED}Error: Not in a Flutter project root directory.${NC}\n"
        exit 1
    fi

    # Check if integration_test directory exists
    if ! [ -d "integration_test" ]; then
        printf "${RED}Error: integration_test directory not found.${NC}\n"
        printf "Create integration_test/ directory with test files first.\n"
        exit 1
    fi

    # Check if any test files exist
    if ! ls integration_test/*.dart &> /dev/null; then
        printf "${RED}Error: No integration test files found in integration_test/ directory.${NC}\n"
        exit 1
    fi
}

check_device() {
    if [ -n "$DEVICE" ]; then
        # Check if specified device exists
        if ! flutter devices | grep -q "$DEVICE"; then
            printf "${RED}Error: Device '$DEVICE' not found.${NC}\n"
            printf "${YELLOW}Available devices:${NC}\n"
            flutter devices
            exit 1
        fi
        printf "${GREEN}Using device: $DEVICE${NC}\n"
    else
        # Check if any device is available
        device_count=$(flutter devices | grep -E "^[a-zA-Z0-9]" | grep -v "No devices detected" | wc -l)
        if [ "$device_count" -eq 0 ]; then
            printf "${RED}Error: No devices detected.${NC}\n"
            printf "Please connect a device or start an emulator.\n"
            printf "Use 'flutter devices' to check available devices.\n"
            exit 1
        fi
        printf "${GREEN}Using default device${NC}\n"
    fi
}

# Function to run command with timeout (works on both macOS and Linux)
run_with_timeout() {
    local timeout_duration=$1
    shift
    local cmd="$@"
    
    # Try different timeout commands
    if command -v gtimeout &> /dev/null; then
        # GNU coreutils timeout (available via brew install coreutils)
        gtimeout "$timeout_duration" $cmd
    elif command -v timeout &> /dev/null; then
        # Standard timeout command (Linux)
        timeout "$timeout_duration" $cmd
    else
        # Fallback: run without timeout but with background process monitoring
        printf "${YELLOW}Warning: timeout command not available, running without timeout${NC}\n"
        $cmd &
        local pid=$!
        local count=0
        while kill -0 $pid 2>/dev/null && [ $count -lt $timeout_duration ]; do
            sleep 1
            count=$((count + 1))
        done
        
        if kill -0 $pid 2>/dev/null; then
            printf "${RED}Process timed out after ${timeout_duration} seconds${NC}\n"
            kill $pid
            wait $pid 2>/dev/null
            return 124 # Timeout exit code
        fi
        wait $pid
        return $?
    fi
}

run_integration_tests() {
    local test_target="integration_test/"
    
    if [ -n "$TEST_FILE" ]; then
        test_target="integration_test/$TEST_FILE"
        if ! [ -f "$test_target" ]; then
            printf "${RED}Error: Test file '$test_target' not found.${NC}\n"
            exit 1
        fi
        printf "${BLUE}Running integration test: $TEST_FILE${NC}\n"
    else
        printf "${BLUE}Running all integration tests${NC}\n"
    fi

    # Build command based on options
    if [ "$USE_DRIVE" = true ]; then
        run_flutter_drive "$test_target"
    else
        run_flutter_test "$test_target"
    fi
}

run_flutter_test() {
    local test_target="$1"
    local cmd="flutter test $test_target"
    
    # Add device option
    if [ -n "$DEVICE" ]; then
        cmd="$cmd -d $DEVICE"
    fi
    
    # Add coverage option
    if [ "$COVERAGE" = true ]; then
        cmd="$cmd --coverage"
    fi
    
    printf "${YELLOW}Executing: $cmd${NC}\n"
    
    # Run the command with timeout
    if run_with_timeout "$TIMEOUT" $cmd; then
        printf "${GREEN}✓ Integration tests completed successfully!${NC}\n"
        
        # Show coverage report if generated
        if [ "$COVERAGE" = true ] && [ -f "coverage/lcov.info" ]; then
            printf "${BLUE}Coverage report generated: coverage/lcov.info${NC}\n"
            if command -v genhtml &> /dev/null; then
                genhtml coverage/lcov.info -o coverage/html --no-function-coverage -s -p "$(pwd)"
                printf "${BLUE}HTML coverage report: coverage/html/index.html${NC}\n"
            fi
        fi
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            printf "${RED}✗ Integration tests timed out after $TIMEOUT seconds${NC}\n"
        else
            printf "${RED}✗ Integration tests failed${NC}\n"
        fi
        exit 1
    fi
}

run_flutter_drive() {
    local test_target="$1"
    
    # For flutter drive, we need both driver and target files
    if [ -n "$TEST_FILE" ]; then
        # Single test file
        local target_file="integration_test/$TEST_FILE"
        local driver_file="integration_test/driver.dart"
        
        if ! [ -f "$driver_file" ]; then
            printf "${RED}Error: Driver file '$driver_file' not found.${NC}\n"
            printf "Flutter drive requires a driver file. Create it or use flutter test instead.\n"
            exit 1
        fi
        
        local cmd="flutter drive --driver=$driver_file --target=$target_file"
    else
        # All tests - find first driver file
        local driver_file=$(find integration_test -name "driver.dart" | head -1)
        if [ -z "$driver_file" ]; then
            printf "${RED}Error: No driver.dart file found in integration_test/ directory.${NC}\n"
            printf "Flutter drive requires a driver file. Create it or use flutter test instead.\n"
            exit 1
        fi
        
        # Find test files
        local test_files=($(find integration_test -name "*_test.dart"))
        if [ ${#test_files[@]} -eq 0 ]; then
            printf "${RED}Error: No *_test.dart files found.${NC}\n"
            exit 1
        fi
        
        # Run first test file found
        local cmd="flutter drive --driver=$driver_file --target=${test_files[0]}"
    fi
    
    # Add device option
    if [ -n "$DEVICE" ]; then
        cmd="$cmd -d $DEVICE"
    fi
    
    printf "${YELLOW}Executing: $cmd${NC}\n"
    
    # Run the command with timeout
    if run_with_timeout "$TIMEOUT" $cmd; then
        printf "${GREEN}✓ Integration tests completed successfully!${NC}\n"
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            printf "${RED}✗ Integration tests timed out after $TIMEOUT seconds${NC}\n"
        else
            printf "${RED}✗ Integration tests failed${NC}\n"
        fi
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -f|--file)
            TEST_FILE="$2"
            shift 2
            ;;
        -D|--drive)
            USE_DRIVE=true
            shift
            ;;
        -c|--coverage)
            COVERAGE=true
            shift
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        -l|--list-devices)
            list_devices
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            printf "${RED}Unknown option: $1${NC}\n"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
printf "${BLUE}🚀 Ditonton Integration Test Runner${NC}\n\n"

# Run checks
check_prerequisites
check_device

# Get dependencies
printf "${YELLOW}Getting dependencies...${NC}\n"
flutter pub get

# Run tests
printf "\n${BLUE}Starting integration tests...${NC}\n"
run_integration_tests

printf "\n${GREEN}🎉 All done!${NC}\n"