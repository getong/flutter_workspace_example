import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/repositories/fetch_history_repository.dart';
import '../domain/fetch_history_entry.dart';

enum FetchRequestStatus { initial, loading, success, failure }

const Object _sentinel = Object();

class FetchRequestState extends Equatable {
  const FetchRequestState({
    this.status = FetchRequestStatus.initial,
    this.currentUrl = '',
    this.responseBody = '',
    this.lastStatusCode,
    this.lastRequestSucceeded = false,
    this.lastFetchedAt,
    this.errorMessage,
  });

  final FetchRequestStatus status;
  final String currentUrl;
  final String responseBody;
  final int? lastStatusCode;
  final bool lastRequestSucceeded;
  final DateTime? lastFetchedAt;
  final String? errorMessage;

  FetchRequestState copyWith({
    FetchRequestStatus? status,
    String? currentUrl,
    String? responseBody,
    Object? lastStatusCode = _sentinel,
    bool? lastRequestSucceeded,
    Object? lastFetchedAt = _sentinel,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FetchRequestState(
      status: status ?? this.status,
      currentUrl: currentUrl ?? this.currentUrl,
      responseBody: responseBody ?? this.responseBody,
      lastStatusCode: identical(lastStatusCode, _sentinel)
          ? this.lastStatusCode
          : lastStatusCode as int?,
      lastRequestSucceeded: lastRequestSucceeded ?? this.lastRequestSucceeded,
      lastFetchedAt: identical(lastFetchedAt, _sentinel)
          ? this.lastFetchedAt
          : lastFetchedAt as DateTime?,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.name,
      'currentUrl': currentUrl,
      'responseBody': responseBody,
      'lastStatusCode': lastStatusCode,
      'lastRequestSucceeded': lastRequestSucceeded,
      'lastFetchedAt': lastFetchedAt?.millisecondsSinceEpoch,
      'errorMessage': errorMessage,
    };
  }

  factory FetchRequestState.fromJson(Map<String, dynamic> json) {
    final String rawStatus = (json['status'] ?? FetchRequestStatus.initial.name)
        .toString();
    final int? rawFetchedAt = (json['lastFetchedAt'] as num?)?.toInt();

    return FetchRequestState(
      status: FetchRequestStatus.values.firstWhere(
        (FetchRequestStatus value) => value.name == rawStatus,
        orElse: () => FetchRequestStatus.initial,
      ),
      currentUrl: (json['currentUrl'] ?? '').toString(),
      responseBody: (json['responseBody'] ?? '').toString(),
      lastStatusCode: (json['lastStatusCode'] as num?)?.toInt(),
      lastRequestSucceeded: json['lastRequestSucceeded'] == true,
      lastFetchedAt: rawFetchedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(rawFetchedAt),
      errorMessage: json['errorMessage']?.toString(),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    currentUrl,
    responseBody,
    lastStatusCode,
    lastRequestSucceeded,
    lastFetchedAt,
    errorMessage,
  ];
}

sealed class FetchRequestEvent {
  const FetchRequestEvent();
}

class FetchRequestUrlChanged extends FetchRequestEvent {
  const FetchRequestUrlChanged(this.url);

  final String url;
}

class FetchRequestSubmitted extends FetchRequestEvent {
  const FetchRequestSubmitted();
}

class FetchRequestBloc
    extends HydratedBloc<FetchRequestEvent, FetchRequestState> {
  FetchRequestBloc(this._repository) : super(const FetchRequestState()) {
    on<FetchRequestUrlChanged>(_onUrlChanged);
    on<FetchRequestSubmitted>(_onSubmitted);
  }

  final FetchHistoryRepository _repository;

  void _onUrlChanged(
    FetchRequestUrlChanged event,
    Emitter<FetchRequestState> emit,
  ) {
    emit(state.copyWith(currentUrl: event.url, clearError: true));
  }

  Future<void> _onSubmitted(
    FetchRequestSubmitted event,
    Emitter<FetchRequestState> emit,
  ) async {
    final String trimmedUrl = state.currentUrl.trim();
    if (trimmedUrl.isEmpty) {
      emit(
        state.copyWith(
          status: FetchRequestStatus.failure,
          errorMessage: 'Please enter a URL before fetching.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FetchRequestStatus.loading,
        currentUrl: trimmedUrl,
        clearError: true,
      ),
    );

    try {
      final FetchHistoryEntry result = await _repository.fetchAndStore(
        trimmedUrl,
      );
      emit(
        state.copyWith(
          status: result.isSuccess
              ? FetchRequestStatus.success
              : FetchRequestStatus.failure,
          currentUrl: result.url,
          responseBody: result.responseBody,
          lastStatusCode: result.statusCode,
          lastRequestSucceeded: result.isSuccess,
          lastFetchedAt: result.fetchedAt,
          errorMessage: result.isSuccess
              ? null
              : 'Request finished with a non-success result and was still saved to Drift history.',
          clearError: result.isSuccess,
        ),
      );
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: FetchRequestStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FetchRequestStatus.failure,
          errorMessage: 'Unexpected error: $error',
        ),
      );
    }
  }

  @override
  FetchRequestState? fromJson(Map<String, dynamic> json) {
    return FetchRequestState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(FetchRequestState state) {
    return state.toJson();
  }
}
