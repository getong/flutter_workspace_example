# widget_layout_example2

A new Flutter project.

## Toggle controls

`toggle_switch` is retired from this project. Use the existing
`animated_toggle_switch` demo for animated choices, vertical layouts, optional
selection and asynchronous changes, or the `SegmentedButton` demo for Material
single/multiple selection. The old route links to both replacements.

## 环境变量（envied）

`flutter_dotenv` 已移除，改用 `envied` 在构建期把 `env/*.env` 生成为类型安全的
Dart 字段（`lib/features/envied/data/config/envied_demo_env.dart`）。旧的
`flutter_dotenv` 路由保留为跳转页。

修改 env 文件后重新生成：

```sh
puro flutter pub run build_runner build
```

`build.yaml` 在 build_runner 默认 sources 的基础上加入了 `env/**`，否则生成器读
不到 env 文件。`env/` 里只有演示用的假值；真实项目应把含密钥的 env 文件和生成的
`*.g.dart` 加入 `.gitignore`。`obfuscate: true` 只是混淆，客户端里的值仍可被还原。

## macOS SwiftPM 下载超时

如果报 `Couldn’t fetch updates from remote repositories`，这是 Git 仓库更新
失败，下面的二进制缓存脚本不能解决。先确认本机代理已启动，再为 GitHub 的
Git HTTPS 请求配置代理（当前用户全局生效，Xcode/SwiftPM 也会使用）：

```sh
git config --global http.https://github.com/.proxy http://127.0.0.1:7890
git ls-remote https://github.com/mattgallagher/CwlCatchException.git HEAD
git ls-remote https://github.com/getsentry/sentry-cocoa HEAD
puro flutter run -d macos
```

将端口替换为实际代理端口；运行时需要保持代理开启。如果以后恢复直连，移除
此配置：`git config --global --unset http.https://github.com/.proxy`。

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
