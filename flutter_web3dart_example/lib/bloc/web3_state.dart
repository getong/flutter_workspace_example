import '../models/web3_demo_models.dart';

class Web3SectionStatus {
  const Web3SectionStatus({
    this.isLoading = false,
    this.error,
    this.section,
  });

  final bool isLoading;
  final String? error;
  final Web3DemoSection? section;

  Web3SectionStatus copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    Web3DemoSection? section,
  }) {
    return Web3SectionStatus(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      section: section ?? this.section,
    );
  }
}

class Web3State {
  const Web3State({
    this.isOverviewLoading = false,
    this.overviewError,
    this.sections = const {},
  });

  final bool isOverviewLoading;
  final String? overviewError;
  final Map<String, Web3SectionStatus> sections;

  Web3State copyWith({
    bool? isOverviewLoading,
    String? overviewError,
    bool clearOverviewError = false,
    Map<String, Web3SectionStatus>? sections,
  }) {
    return Web3State(
      isOverviewLoading: isOverviewLoading ?? this.isOverviewLoading,
      overviewError:
          clearOverviewError ? null : (overviewError ?? this.overviewError),
      sections: sections ?? this.sections,
    );
  }

  List<Web3SectionStatus> get orderedSections => [
        if (sections.containsKey('network')) sections['network']!,
        if (sections.containsKey('raw-rpc')) sections['raw-rpc']!,
        if (sections.containsKey('address')) sections['address']!,
        if (sections.containsKey('erc20')) sections['erc20']!,
        if (sections.containsKey('encoding')) sections['encoding']!,
        if (sections.containsKey('wallet')) sections['wallet']!,
      ];
}
