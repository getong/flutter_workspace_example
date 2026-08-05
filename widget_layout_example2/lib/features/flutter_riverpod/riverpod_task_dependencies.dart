import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/datasources/in_memory_riverpod_task_data_source.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/repositories/in_memory_riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/use_cases/riverpod_task_use_cases.dart';

// 这些 Provider 构成 feature 的 composition root：它们只负责把 Data 层实现
// 绑定到 Domain 层接口。测试或线上 API 可通过 override 替换实现，而无需修改 UI。
final Provider<RiverpodTaskRepository> riverpodTaskRepositoryProvider =
    Provider<RiverpodTaskRepository>((Ref ref) {
      return InMemoryRiverpodTaskRepository(
        dataSource: InMemoryRiverpodTaskDataSource(),
      );
    });

final Provider<GetRiverpodTasks> getRiverpodTasksProvider =
    Provider<GetRiverpodTasks>((Ref ref) {
      return GetRiverpodTasks(ref.watch(riverpodTaskRepositoryProvider));
    });

final Provider<AddRiverpodTask> addRiverpodTaskProvider =
    Provider<AddRiverpodTask>((Ref ref) {
      return AddRiverpodTask(ref.watch(riverpodTaskRepositoryProvider));
    });

final Provider<ToggleRiverpodTask> toggleRiverpodTaskProvider =
    Provider<ToggleRiverpodTask>((Ref ref) {
      return ToggleRiverpodTask(ref.watch(riverpodTaskRepositoryProvider));
    });

final Provider<DeleteRiverpodTask> deleteRiverpodTaskProvider =
    Provider<DeleteRiverpodTask>((Ref ref) {
      return DeleteRiverpodTask(ref.watch(riverpodTaskRepositoryProvider));
    });

final Provider<ClearCompletedRiverpodTasks>
clearCompletedRiverpodTasksProvider = Provider<ClearCompletedRiverpodTasks>((
  Ref ref,
) {
  return ClearCompletedRiverpodTasks(ref.watch(riverpodTaskRepositoryProvider));
});
