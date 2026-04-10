import 'package:equatable/equatable.dart';

enum OfflineOrdersStatus { initial, loading, ready, failure }

class OfflineOrdersState extends Equatable {
  const OfflineOrdersState({
    this.status = OfflineOrdersStatus.initial,
    this.isOnline = false,
    this.isSaving = false,
    this.isSyncing = false,
    this.message,
    this.errorMessage,
  });

  final OfflineOrdersStatus status;
  final bool isOnline;
  final bool isSaving;
  final bool isSyncing;
  final String? message;
  final String? errorMessage;

  bool get isBusy =>
      status == OfflineOrdersStatus.loading || isSaving || isSyncing;

  OfflineOrdersState copyWith({
    OfflineOrdersStatus? status,
    bool? isOnline,
    bool? isSaving,
    bool? isSyncing,
    String? message,
    String? errorMessage,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return OfflineOrdersState(
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      isSaving: isSaving ?? this.isSaving,
      isSyncing: isSyncing ?? this.isSyncing,
      message: clearMessage ? null : (message ?? this.message),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    isOnline,
    isSaving,
    isSyncing,
    message,
    errorMessage,
  ];
}
