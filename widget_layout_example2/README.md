# widget_layout_example2

A new Flutter project.

## Toggle controls

`toggle_switch` is retired from this project. Use the existing
`animated_toggle_switch` demo for animated choices, vertical layouts, optional
selection and asynchronous changes, or the `SegmentedButton` demo for Material
single/multiple selection. The old route links to both replacements.

## macOS SwiftPM 下载超时

如果 `puro flutter run -d macos` 在下载 Sentry / MDK 的 GitHub Release
时超时，可以先通过可用代理预填充 SwiftPM 缓存：

```sh
python3 tool/cache_macos_spm_artifacts.py --proxy http://127.0.0.1:7890
puro flutter run -d macos
```

把代理地址替换为本机实际地址。脚本读取 Flutter 生成的 Package.swift 及
SwiftPM checkout 中的二进制 URL 和 SHA-256，校验后才写入用户缓存；已校验的
文件会跳过。首次使用前需要运行一次 Flutter，让它生成包描述文件。
升级依赖后若再次超时，可重新运行脚本，无需关闭 Swift Package Manager。

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
