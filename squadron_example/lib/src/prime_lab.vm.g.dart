// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: WorkerGenerator 9.0.0+2 (Squadron 7.4.3)
// **************************************************************************

import 'package:squadron/squadron.dart';

import 'prime_lab.dart';

void _start$PrimeLab(WorkerRequest command) {
  /// VM entry point for PrimeLab
  run($PrimeLabInitializer, command);
}

EntryPoint $getPrimeLabActivator(SquadronPlatformType platform) {
  if (platform.isVm) {
    return _start$PrimeLab;
  } else {
    throw UnsupportedError('${platform.label} not supported.');
  }
}
