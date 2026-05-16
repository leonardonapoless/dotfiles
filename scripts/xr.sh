#!/usr/bin/env bash

set -euo pipefail

# Constants & Defaults
readonly DERIVED_DATA_PATH="./build_output"
readonly DEVICE_NAME="Leonardo's iPhone"
readonly DEFAULT_SIMULATOR="iPhone 15"

PLATFORM="mac"
SCHEME=""
TARGET_TYPE=""
TARGET_NAME=""

# Utility Functions
log_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1" >&2; }

extract_app_path() {
    local build_dir=$1
    local app_path
    
    app_path=$(find "$build_dir" -maxdepth 2 -type d -name "*.app" | head -n 1)
    
    if [[ -z "$app_path" ]]; then
        log_error "Could not find .app bundle in $build_dir"
        exit 1
    fi
    echo "$app_path"
}

extract_bundle_id() {
    local app_path=$1
    /usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$app_path/Info.plist"
}

# Interactive Prompts
prompt_ios_target() {
    echo -e "\n\033[1;36mSelect iOS Deployment Target:\033[0m"
    local options=("Simulator" "$DEVICE_NAME" "Cancel")
    
    select opt in "${options[@]}"; do
        case $opt in
            "Simulator")
                TARGET_TYPE="simulator"
                read -r -p "Enter Simulator name (Press Enter for default '$DEFAULT_SIMULATOR'): " input_sim
                TARGET_NAME=${input_sim:-$DEFAULT_SIMULATOR}
                break
                ;;
            "$DEVICE_NAME")
                TARGET_TYPE="device"
                TARGET_NAME="$DEVICE_NAME"
                break
                ;;
            "Cancel")
                log_info "Operation cancelled."
                exit 0
                ;;
            *) log_error "Invalid option $REPLY" ;;
        esac
    done
}

# Build & Run Functions
run_mac() {
    log_info "Building $SCHEME for macOS..."
    
    xcodebuild -scheme "$SCHEME" \
               -derivedDataPath "$DERIVED_DATA_PATH" \
               -configuration Debug \
               -sdk macosx \
               build | (command -v xcpretty >/dev/null && xcpretty || cat)

    local app_path
    app_path=$(extract_app_path "$DERIVED_DATA_PATH/Build/Products/Debug")
    
    log_info "Launching macOS App..."
    open "$app_path"
    log_success "App launched successfully."
}

run_ios_simulator() {
    log_info "Building $SCHEME for iOS Simulator ($TARGET_NAME)..."
    
    xcodebuild -scheme "$SCHEME" \
               -derivedDataPath "$DERIVED_DATA_PATH" \
               -configuration Debug \
               -sdk iphonesimulator \
               build | (command -v xcpretty >/dev/null && xcpretty || cat)

    local app_path bundle_id
    app_path=$(extract_app_path "$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator")
    bundle_id=$(extract_bundle_id "$app_path")

    log_info "Booting Simulator '$TARGET_NAME'..."
    xcrun simctl boot "$TARGET_NAME" 2>/dev/null || true
    open -a Simulator

    log_info "Installing App..."
    xcrun simctl install booted "$app_path"

    log_info "Launching $bundle_id..."
    xcrun simctl launch booted "$bundle_id"
    log_success "App launched on Simulator."
}

run_ios_device() {
    log_info "Building $SCHEME for Physical Device ($TARGET_NAME)..."
    
    xcodebuild -scheme "$SCHEME" \
               -derivedDataPath "$DERIVED_DATA_PATH" \
               -configuration Debug \
               -sdk iphoneos \
               -allowProvisioningUpdates \
               build | (command -v xcpretty >/dev/null && xcpretty || cat)

    local app_path bundle_id
    app_path=$(extract_app_path "$DERIVED_DATA_PATH/Build/Products/Debug-iphoneos")
    bundle_id=$(extract_bundle_id "$app_path")

    log_info "Installing App to $TARGET_NAME via devicectl..."
    xcrun devicectl device install app --device "$TARGET_NAME" "$app_path"

    log_info "Launching $bundle_id on $TARGET_NAME..."
    xcrun devicectl device process launch --device "$TARGET_NAME" "$bundle_id"
    log_success "App launched on Physical Device."
}

# Main Execution
usage() {
    echo "Usage: $0 -s <Scheme> [-p mac|ios]"
    exit 1
}

while getopts "s:p:" flag; do
    case "${flag}" in
        s) SCHEME=${OPTARG} ;;
        p) PLATFORM=${OPTARG} ;;
        *) usage ;;
    esac
done

if [[ -z "$SCHEME" ]]; then
    log_error "Missing required argument: -s <Scheme>"
    usage
fi

if [[ "$PLATFORM" == "mac" ]]; then
    run_mac
elif [[ "$PLATFORM" == "ios" ]]; then
    prompt_ios_target
    if [[ "$TARGET_TYPE" == "simulator" ]]; then
        run_ios_simulator
    elif [[ "$TARGET_TYPE" == "device" ]]; then
        run_ios_device
    fi
else
    log_error "Invalid platform '$PLATFORM'. Use 'mac' or 'ios'."
    usage
fi
