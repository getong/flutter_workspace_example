import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/riverpod_task_dependencies.dart';

enum RiverpodTaskFilter { all, active, completed }

// 本示例中的“实时效果”是响应式状态传播，不是定时轮询：
// 1. 页面通过 ref.read 调用 Notifier 命令；
// 2. Notifier 写入 state 后，Riverpod 立即通知所有 ref.watch 订阅者；
// 3. Flutter 在下一帧只重建依赖该 Provider 的 Widget；
// 4. Repository 返回新数据后再次写入 state，加载态会实时切换为数据态或错误态。
// 如果数据来自 WebSocket 等远端实时源，可在 Data 层暴露 Stream，并用
// StreamProvider/StreamNotifier 接入；页面侧的 watch 消费方式保持不变。

// AsyncNotifierProvider 同时暴露异步 UI 状态和用户命令。Consumer 通过 watch
// 订阅状态变化，通过 read 获取 Notifier 执行命令，形成单向数据流。
final AsyncNotifierProvider<RiverpodTaskNotifier, List<RiverpodTask>>
riverpodTaskListProvider =
    AsyncNotifierProvider<RiverpodTaskNotifier, List<RiverpodTask>>(
      RiverpodTaskNotifier.new,
    );

final NotifierProvider<RiverpodTaskFilterNotifier, RiverpodTaskFilter>
riverpodTaskFilterProvider =
    NotifierProvider<RiverpodTaskFilterNotifier, RiverpodTaskFilter>(
      RiverpodTaskFilterNotifier.new,
    );

// 这是实时派生状态：任务列表或筛选条件任意一项变化时，Riverpod 会让该
// Provider 立即失效并重新计算；页面不需要手动调用 setState 或重新查询数据。
final Provider<AsyncValue<List<RiverpodTask>>> visibleRiverpodTasksProvider =
    Provider<AsyncValue<List<RiverpodTask>>>((Ref ref) {
      final AsyncValue<List<RiverpodTask>> tasks = ref.watch(
        riverpodTaskListProvider,
      );
      final RiverpodTaskFilter filter = ref.watch(riverpodTaskFilterProvider);

      return tasks.whenData((List<RiverpodTask> items) {
        return switch (filter) {
          RiverpodTaskFilter.all => items,
          RiverpodTaskFilter.active =>
            items
                .where((RiverpodTask task) => !task.isCompleted)
                .toList(growable: false),
          RiverpodTaskFilter.completed =>
            items
                .where((RiverpodTask task) => task.isCompleted)
                .toList(growable: false),
        };
      });
    });

final class RiverpodTaskNotifier extends AsyncNotifier<List<RiverpodTask>> {
  @override
  Future<List<RiverpodTask>> build() {
    // watch 建立响应式依赖；仓库绑定被 override 或依赖失效时，Riverpod 会
    // 自动重新执行 build，并把新的 AsyncValue 实时发布给页面。
    return ref.watch(getRiverpodTasksProvider).call();
  }

  Future<void> addTask(String title) {
    return _mutate(() => ref.read(addRiverpodTaskProvider).call(title));
  }

  Future<void> toggleTask(String id) {
    return _mutate(() => ref.read(toggleRiverpodTaskProvider).call(id));
  }

  Future<void> deleteTask(String id) {
    return _mutate(() => ref.read(deleteRiverpodTaskProvider).call(id));
  }

  Future<void> clearCompletedTasks() {
    return _mutate(() => ref.read(clearCompletedRiverpodTasksProvider).call());
  }

  Future<void> retry() async {
    // 第一次赋值会立即发布 loading，watch 该 Provider 的按钮和列表下一帧更新。
    state = const AsyncLoading<List<RiverpodTask>>();
    // 第二次赋值在异步查询结束时发布 data/error，页面自动离开 loading 状态。
    state = await AsyncValue.guard(
      () => ref.read(getRiverpodTasksProvider).call(),
    );
  }

  Future<void> _mutate(Future<void> Function() operation) async {
    // state= 是 Riverpod 实时效果的触发点：无需 notifyListeners，也无需页面
    // setState；所有 watch 订阅者会收到 loading 并按依赖关系局部重建。
    state = const AsyncLoading<List<RiverpodTask>>();
    state = await AsyncValue.guard(() async {
      await operation();
      // 写操作完成后读取单一数据源，并将最新不可变列表作为 AsyncData 发布。
      // 汇总数字、过滤结果和任务列表会由各自的 watch 自动同步刷新。
      return ref.read(getRiverpodTasksProvider).call();
    });
  }
}

final class RiverpodTaskFilterNotifier extends Notifier<RiverpodTaskFilter> {
  @override
  RiverpodTaskFilter build() => RiverpodTaskFilter.all;

  void select(RiverpodTaskFilter filter) {
    // 只要写入新的筛选状态，visibleRiverpodTasksProvider 就会立即重新计算，
    // 页面下一帧显示对应列表，不需要重新访问 Repository。
    state = filter;
  }
}
