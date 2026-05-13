import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/repositories/segmented_button_repository.dart';
import 'package:widget_layout_example2/features/segmented_button/presentation/cubit/segmented_button_state.dart';

class SegmentedButtonCubit extends Cubit<SegmentedButtonDemoState> {
  SegmentedButtonCubit({required SegmentedButtonRepository repository})
    : _repository = repository,
      super(SegmentedButtonDemoState(snapshot: repository.loadSnapshot()));

  final SegmentedButtonRepository _repository;

  void selectCalendarView(Set<CalendarView> selection) {
    if (selection.isEmpty) {
      return;
    }

    _repository.saveCalendarView(selection.first);
    _emitSnapshot();
  }

  void selectSizes(Set<ApparelSize> selection) {
    _repository.saveSelectedSizes(selection);
    _emitSnapshot();
  }

  void reset() {
    _repository.reset();
    _emitSnapshot();
  }

  void _emitSnapshot() {
    emit(SegmentedButtonDemoState(snapshot: _repository.loadSnapshot()));
  }
}
