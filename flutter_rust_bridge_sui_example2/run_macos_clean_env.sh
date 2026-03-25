#!/usr/bin/env bash
set -euo pipefail

clear_deployment_env() {
  # Clear deployment target env vars that can make clang target non-macOS
  # platforms (e.g. DriverKit/XR) during Flutter macOS builds.
  unset MACOSX_DEPLOYMENT_TARGET || true
  unset DRIVERKIT_DEPLOYMENT_TARGET || true
  unset IPHONEOS_DEPLOYMENT_TARGET || true
  unset TVOS_DEPLOYMENT_TARGET || true
  unset WATCHOS_DEPLOYMENT_TARGET || true
  unset XROS_DEPLOYMENT_TARGET || true
  unset VISIONOS_DEPLOYMENT_TARGET || true
}

clear_deployment_env

# Clear global SDK/flags that are often set for Rust bindgen but interfere with Flutter.
unset SDKROOT || true
unset BINDGEN_EXTRA_CLANG_ARGS || true
unset LIBRARY_PATH || true
unset CFLAGS || true
unset CXXFLAGS || true
unset CPPFLAGS || true
unset LDFLAGS || true

# Some build scripts can re-inject deployment target variables after Flutter starts.
# Wrap xcrun so every clang call is cleaned right before execution.
tmp_bin_dir="$(mktemp -d)"
flutter_bin="$(command -v flutter || true)"
if [[ -z "$flutter_bin" ]]; then
  echo "flutter not found in current PATH" >&2
  exit 127
fi
flutter_bin_dir="$(dirname "$flutter_bin")"
cleanup() {
  rm -rf "$tmp_bin_dir"
}
trap cleanup EXIT

cat >"$tmp_bin_dir/xcrun" <<'EOF'
#!/usr/bin/env bash
if [[ "${FRB_DEBUG_XCRUN:-0}" == "1" ]]; then
  {
    echo "----- $(date '+%F %T') xcrun $* -----"
    env | /usr/bin/egrep 'DEPLOYMENT_TARGET|SDKROOT|LIBRARY_PATH|CFLAGS|CXXFLAGS|CPPFLAGS|LDFLAGS' || true
  } >> /tmp/frb_xcrun_env.log
fi

unset MACOSX_DEPLOYMENT_TARGET || true
unset DRIVERKIT_DEPLOYMENT_TARGET || true
unset IPHONEOS_DEPLOYMENT_TARGET || true
unset TVOS_DEPLOYMENT_TARGET || true
unset WATCHOS_DEPLOYMENT_TARGET || true
unset XROS_DEPLOYMENT_TARGET || true
unset VISIONOS_DEPLOYMENT_TARGET || true
unset SDKROOT || true
unset LIBRARY_PATH || true
unset CFLAGS || true
unset CXXFLAGS || true
unset CPPFLAGS || true
unset LDFLAGS || true
unset CC || true
exec /usr/bin/xcrun "$@"
EOF

chmod +x "$tmp_bin_dir/xcrun"

clean_path="$tmp_bin_dir:$flutter_bin_dir:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.cargo/bin"

# Preserve Flutter/Dart package registry settings. When mirror vars are not set,
# default to the CN mirror (opt out with FRB_USE_CN_MIRROR=0) to avoid
# pub.dev DNS/socket failures in restricted networks.
pub_hosted_url="${PUB_HOSTED_URL:-}"
flutter_storage_base_url="${FLUTTER_STORAGE_BASE_URL:-}"
if [[ -z "$pub_hosted_url" && "${FRB_USE_CN_MIRROR:-1}" != "0" ]]; then
  pub_hosted_url="https://pub.flutter-io.cn"
fi
if [[ -z "$flutter_storage_base_url" && "$pub_hosted_url" == "https://pub.flutter-io.cn" ]]; then
  flutter_storage_base_url="https://storage.flutter-io.cn"
fi
pub_cache="${PUB_CACHE:-$HOME/.pub-cache}"

exec env -i \
  HOME="$HOME" \
  USER="${USER:-}" \
  LOGNAME="${LOGNAME:-}" \
  SHELL="${SHELL:-/bin/zsh}" \
  TMPDIR="${TMPDIR:-/tmp}" \
  LANG="${LANG:-zh_CN.UTF-8}" \
  LC_ALL="${LC_ALL:-zh_CN.UTF-8}" \
  PATH="$clean_path" \
  ALL_PROXY="${ALL_PROXY:-}" \
  all_proxy="${all_proxy:-}" \
  HTTP_PROXY="${HTTP_PROXY:-}" \
  http_proxy="${http_proxy:-}" \
  HTTPS_PROXY="${HTTPS_PROXY:-}" \
  https_proxy="${https_proxy:-}" \
  NO_PROXY="${NO_PROXY:-}" \
  no_proxy="${no_proxy:-}" \
  SSL_CERT_FILE="${SSL_CERT_FILE:-}" \
  SSL_CERT_DIR="${SSL_CERT_DIR:-}" \
  PUB_HOSTED_URL="$pub_hosted_url" \
  FLUTTER_STORAGE_BASE_URL="$flutter_storage_base_url" \
  PUB_CACHE="$pub_cache" \
  PUB_ENVIRONMENT="${PUB_ENVIRONMENT:-}" \
  FRB_USE_CN_MIRROR="${FRB_USE_CN_MIRROR:-1}" \
  FRB_DEBUG_XCRUN="${FRB_DEBUG_XCRUN:-0}" \
  flutter run -d macos "$@"
