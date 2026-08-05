import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';

final class RiverpodTaskModel {
  const RiverpodTaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final bool isCompleted;

  RiverpodTaskModel copyWith({bool? isCompleted}) {
    return RiverpodTaskModel(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  RiverpodTask toEntity() {
    return RiverpodTask(id: id, title: title, isCompleted: isCompleted);
  }
}
