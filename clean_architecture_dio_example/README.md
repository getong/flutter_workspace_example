# clean_architecture_dio_example

A Flutter 示例项目，使用基于 feature 的 clean architecture，并结合 Dio 进行网络请求。

当前项目只保留了一个 `advice` feature，用来演示从 `data` 到 `domain` 再到 `presentation` 的完整依赖链路。

## Clean Architecture 目录说明

`lib` 目录采用“按 feature 组织”的方式，每个 feature 内部再拆分为 `data`、`domain`、`presentation` 三层。

```text
lib/
	main.dart
	core/
		di/
		network/
	features/
		advice/
			data/
				models/
				repositories/
				services/
			domain/
				entities/
				repositories/
				usecases/
			presentation/
				bloc/
				views/
```

## 目录职责

### `main.dart`

应用入口文件，负责初始化依赖注入并启动根组件。

### `core/`

放置可被多个 feature 复用的共享基础设施。

- `core/di/`：依赖注入配置，包括 `get_it`、`injectable` 和模块注册。
- `core/network/`：共享网络层基础设施，例如 Dio 工厂和平台差异化配置。

`core` 不应承载具体 feature 的业务逻辑。

### `features/<feature>/domain/`

最内层的业务层，不应依赖 `data` 或 `presentation`。

- `entities/`：核心业务实体，例如 `Advice`。
- `repositories/`：仓库抽象接口，供 use case 使用。
- `usecases/`：应用业务动作，例如 `GetRandomAdviceUseCase`。

### `features/<feature>/data/`

数据实现层，可以依赖 `domain`，负责访问外部数据源以及数据转换。

- `models/`：DTO 或 API 数据模型，用于解析外部返回结果。
- `services/`：对 API、数据库或其他外部来源的直接封装。
- `repositories/`：对 domain 仓库接口的具体实现。

在当前项目里：

- `advice/data/services/` 用于封装远程 advice API 和本地 fallback 数据来源。
- `advice/data/repositories/` 负责把原始数据转换成 domain entity。
- `advice/data/models/` 用于承接接口返回数据，并映射为领域对象。

### `features/<feature>/presentation/`

UI 展示层，可以依赖 `domain` 的 use case，并向 Widget 暴露状态。

- `bloc/`：状态管理和 UI 事件处理。
- `views/`：页面与视图组件。

`presentation` 不应直接调用 `service`，而应通过 use case 和 repository abstraction 间接访问数据。

## 依赖方向

依赖方向应始终保持为：

```text
presentation -> domain <- data
```

这意味着：

- `presentation` 可以依赖 `domain`
- `data` 可以依赖 `domain`
- `domain` 不应依赖 `presentation` 或 `data`
- 共享基础设施应该放在 `core`，而不是某个 feature 的业务层里

## 新增 Feature 的方式

新增 feature 时，按下面的结构继续扩展：

1. 创建 `features/<feature_name>/domain/`，定义 entity、repository contract 和 use case。
2. 创建 `features/<feature_name>/data/`，实现 service、model 和 repository implementation。
3. 创建 `features/<feature_name>/presentation/`，补充 bloc 和 view。
4. 在 `core/di/register_module.dart` 中注册依赖。
5. 如果需要，重新生成 injectable 配置。

## 当前已有 Feature

- `features/advice/`：完整示例，包含 Dio 请求、fallback service、repository、use case、bloc 和 view。

## advice Feature 对应关系

当前 `advice` feature 可以按下面的方式理解：

- `domain/entities/advice.dart`：定义 Advice 业务实体。
- `domain/repositories/advice_repository.dart`：定义 Advice 仓库抽象。
- `domain/usecases/get_random_advice_usecase.dart`：封装“获取随机 advice”这一业务动作。
- `data/models/advice_model.dart`：解析远程接口返回的数据结构。
- `data/services/advice_api_service.dart`：请求远程 advice API。
- `data/services/fallback_advice_service.dart`：在网络异常时提供本地 fallback 数据。
- `data/repositories/advice_repository_impl.dart`：组合 service，处理超时、fallback 和 entity 转换。
- `presentation/bloc/advice_bloc.dart`：负责页面状态流转。
- `presentation/views/advice_view.dart`：负责展示 UI 和派发用户事件。

## 运行项目

```bash
flutter pub get
flutter run
```

## 更新依赖注入配置

当你修改了 `injectable` 相关注册后，可以重新生成依赖注入代码：

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 参考资料

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dio 文档](https://pub.dev/packages/dio)
- [injectable 文档](https://pub.dev/packages/injectable)
- [flutter_bloc 文档](https://pub.dev/packages/flutter_bloc)
