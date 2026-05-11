import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/text_field_persist/data/repositories/in_memory_text_persistence_repository.dart';
import 'package:widget_layout_example2/features/text_field_persist/domain/repositories/text_persistence_repository.dart';
import 'package:widget_layout_example2/features/text_field_persist/presentation/bloc/text_persistence_event.dart';
import 'package:widget_layout_example2/features/text_field_persist/presentation/bloc/text_persistence_state.dart';

class TextPersistenceBloc
    extends Bloc<TextPersistenceEvent, TextPersistenceState> {
  TextPersistenceBloc({TextPersistenceRepository? repository})
    : _repository = repository ?? InMemoryTextPersistenceRepository(),
      super(const TextPersistenceInitial()) {
    on<TextPersistenceLoadRequested>(_onLoadRequested);
    on<TextPersistenceTextChanged>(_onTextChanged);
  }

  final TextPersistenceRepository _repository;

  void _onLoadRequested(
    TextPersistenceLoadRequested event,
    Emitter<TextPersistenceState> emit,
  ) {
    emit(TextPersistenceLoaded(text: _repository.loadText().text));
  }

  void _onTextChanged(
    TextPersistenceTextChanged event,
    Emitter<TextPersistenceState> emit,
  ) {
    _repository.saveText(event.text);
    emit(TextPersistenceLoaded(text: event.text));
  }
}
