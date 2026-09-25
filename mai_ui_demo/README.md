# 远行 · Flutter 旅行规划应用

参考 `mai_ui_client/design-output/interactive` 的中文旅行规划设计，实现暖白、墨绿和橙色主题，山水插画由 Flutter CustomPainter 离线绘制。

## 运行

```sh
puro flutter pub get
puro flutter run -d macos
```

## 功能

- 首页：大理行程、实际日期倒计时、预算、四天安排、推荐目的地、准备清单。
- 行程：Day 1–4 切换、交通提示、预订记录、预算明细。
- 收藏：收藏/取消收藏、搜索、目的地详情。
- 我的：编辑昵称、旅行统计、应用内提醒开关；通知页可查看出发提醒。
- 收藏、清单、昵称、提醒状态通过 shared_preferences 保存到本机。
- 320px 起支持窄屏；宽窗口采用双栏首页，底部导航固定且不覆盖内容。

## 路由与结构

全部页面路由使用 **auto_route 11**，通过官方支持的 `NamedRouteDef` 声明，无需代码生成。

| 路径 | 页面 |
| --- | --- |
| `/` | 首页 |
| `/trips` | 行程 |
| `/saved` | 收藏 |
| `/profile` | 我的 |
| `/destination/:id` | 目的地详情 |
| `/notifications` | 旅行提醒 |

代码按功能组织，页面与专用组件分开：

```text
lib/
├── main.dart                    # 初始化本地存储、启动应用
├── app/
│   ├── travel_app.dart           # MaterialApp 与依赖注入
│   ├── router/app_router.dart    # auto_route 路由定义
│   ├── shell/app_shell.dart      # 四个 Tab 的导航容器
│   └── state/                   # 跨页面共享状态与 TravelScope
├── core/
│   ├── theme/                   # 色板、ThemeData
│   └── widgets/                 # 通用容器、标题、标签、插画
└── features/
    ├── home/                    # 首页、行程主视觉、指标栏
    ├── trips/                   # 行程页、日程、清单、预订与预算
    ├── saved/                   # 收藏列表与搜索
    ├── profile/                 # 个人资料、昵称编辑弹窗
    ├── destinations/            # 目的地详情与收藏卡片
    └── notifications/           # 旅行提醒页
```

每个功能按需设置 `pages/`、`widgets/`、`models/`、`data/`，模型和示例数据分别放在所属功能内。`core` 不依赖业务页面；跨页面复用的业务组件仍由对应功能维护（例如首页复用行程模块的日程和清单）。

`app/state/travel_store.dart` 统一管理并持久化跨 Tab 状态，`travel_scope.dart` 负责向组件提供状态。新增页面在对应功能的 `pages/` 中实现，再到 `app/router/app_router.dart` 注册；页面专用组件放在该功能的 `widgets/`，通用视觉组件放入 `core/widgets/`。

本应用为离线演示，预订、天气、价格和评分是示例数据，不会执行真实预订或后台通知。准备清单与预订记录分别管理，勾选清单不会产生订单。

## 检查

```sh
puro flutter analyze
puro flutter test
```

测试覆盖路由跳转和返回、每日安排切换、收藏搜索、本地状态恢复、昵称校验，以及 320/390/1100px 布局。

## Xcode 27 兼容

macOS 工程的 Flutter Assemble 脚本清除其他 Apple 平台的 deployment target 环境变量，避免 clang 将 macOS 框架错误编译为 xros。保留 macOS 12.0 最低部署目标，不修改 Puro 的 Flutter SDK。
