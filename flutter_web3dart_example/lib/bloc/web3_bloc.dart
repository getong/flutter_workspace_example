import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/web3_demo_models.dart';
import '../services/web3_demo_service.dart';
import 'web3_event.dart';
import 'web3_state.dart';

class Web3Bloc extends Bloc<Web3Event, Web3State> {
  Web3Bloc({
    Web3DemoService? service,
  })  : _service = service ?? Web3DemoService(),
        super(const Web3State()) {
    on<LoadWeb3Overview>(_onLoadWeb3Overview);
    on<InspectAddressRequested>(_onInspectAddressRequested);
    on<InspectTokenRequested>(_onInspectTokenRequested);
    on<DemonstrateEncodingRequested>(_onDemonstrateEncodingRequested);
    on<InspectWalletRequested>(_onInspectWalletRequested);
  }

  final Web3DemoService _service;

  Future<void> _onLoadWeb3Overview(
    LoadWeb3Overview event,
    Emitter<Web3State> emit,
  ) async {
    emit(
      state.copyWith(
        isOverviewLoading: true,
        clearOverviewError: true,
      ),
    );

    try {
      final sections = await _service.loadOverview();
      emit(
        state.copyWith(
          isOverviewLoading: false,
          sections: {
            for (final section in sections)
              section.id: Web3SectionStatus(section: section),
          },
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isOverviewLoading: false,
          overviewError: 'Failed to load overview: $e',
        ),
      );
    }
  }

  Future<void> _onInspectAddressRequested(
    InspectAddressRequested event,
    Emitter<Web3State> emit,
  ) async {
    await _updateSection(
      emit: emit,
      sectionId: 'address',
      loader: () => _service.inspectAddress(event.address),
    );
  }

  Future<void> _onInspectTokenRequested(
    InspectTokenRequested event,
    Emitter<Web3State> emit,
  ) async {
    await _updateSection(
      emit: emit,
      sectionId: 'erc20',
      loader: () => _service.inspectToken(
        event.tokenAddress,
        event.ownerAddress,
      ),
    );
  }

  Future<void> _onDemonstrateEncodingRequested(
    DemonstrateEncodingRequested event,
    Emitter<Web3State> emit,
  ) async {
    await _updateSection(
      emit: emit,
      sectionId: 'encoding',
      loader: () => _service.demonstrateEncoding(
        event.tokenAddress,
        event.recipientAddress,
      ),
    );
  }

  Future<void> _onInspectWalletRequested(
    InspectWalletRequested event,
    Emitter<Web3State> emit,
  ) async {
    await _updateSection(
      emit: emit,
      sectionId: 'wallet',
      loader: () => _service.inspectWallet(
        event.privateKey,
        event.message,
      ),
    );
  }

  Future<void> _updateSection({
    required Emitter<Web3State> emit,
    required String sectionId,
    required Future<Web3DemoSection> Function() loader,
  }) async {
    final current = state.sections[sectionId] ?? const Web3SectionStatus();
    emit(
      state.copyWith(
        sections: {
          ...state.sections,
          sectionId: current.copyWith(
            isLoading: true,
            clearError: true,
          ),
        },
      ),
    );

    try {
      final section = await loader();
      emit(
        state.copyWith(
          sections: {
            ...state.sections,
            sectionId: Web3SectionStatus(section: section),
          },
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sections: {
            ...state.sections,
            sectionId: current.copyWith(
              isLoading: false,
              error: e.toString(),
            ),
          },
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _service.dispose();
    return super.close();
  }
}
