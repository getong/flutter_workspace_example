#!/bin/sh

set -eu

if [ "${CODE_SIGNING_ALLOWED:-NO}" != "YES" ]; then
  exit 0
fi

if [ "${PLATFORM_NAME:-}" != "iphoneos" ]; then
  exit 0
fi

if [ -z "${EXPANDED_CODE_SIGN_IDENTITY:-}" ]; then
  exit 0
fi

frameworks_dir="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH:-Frameworks}"
plist_buddy="/usr/libexec/PlistBuddy"

if [ ! -d "${frameworks_dir}" ]; then
  exit 0
fi

for framework in "${frameworks_dir}"/*.framework; do
  if [ ! -d "${framework}" ]; then
    continue
  fi

  plist="${framework}/Info.plist"
  if [ ! -f "${plist}" ]; then
    continue
  fi

  identifier="$("${plist_buddy}" -c 'Print :CFBundleIdentifier' "${plist}" 2>/dev/null || true)"

  case "${identifier}" in
    io.flutter.flutter.native-assets.*)
      echo "Re-signing native asset framework: $(basename "${framework}")"
      /usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" \
        --preserve-metadata=identifier,entitlements \
        "${framework}"
      ;;
  esac
done
