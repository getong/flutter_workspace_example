# flutter_rust_bridge_sui_example

基于 `flutter_rust_bridge` 的 `Flutter -> Rust -> Sui` 示例工程。

## 功能

- Flutter 调 Rust 查询 Sui 网络 `api_version`
- Flutter 调 Rust 做 Sui 地址规范化

Rust 侧 Sui 逻辑参考了：
`rust_example/sui_workspace_example`

## 目录结构

- `lib/main.dart`: Flutter 页面和交互入口
- `lib/src/rust/*`: FRB 生成的 Dart 绑定
- `rust/src/api/simple.rs`: Rust 业务 API（Sui 调用）
- `rust_builder/`: Flutter FFI 插件构建壳

## 运行

1. 拉取 Flutter 依赖

```bash
flutter pub get
```

2. 运行应用（示例）

```bash
flutter run -d macos
```

> 首次构建会编译 Rust 动态库；`sui-sdk` 是 git 依赖，需可访问网络。

## macOS 构建报 deployment target 冲突时

如果看到类似：

- `clang: error: conflicting deployment targets ...`
- `clang: warning: using sysroot for 'MacOSX' but targeting 'XR'`

通常是当前 shell 注入了跨平台 `*_DEPLOYMENT_TARGET` / `SDKROOT` / `LIBRARY_PATH` 环境变量。

可直接使用仓库内脚本清理环境后运行：

```bash
./scripts/run_macos_clean_env.sh
```

若仍失败，可打开 `xcrun` 环境日志：

```bash
FRB_DEBUG_XCRUN=1 ./scripts/run_macos_clean_env.sh
tail -n 120 /tmp/frb_xcrun_env.log
```
