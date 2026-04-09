import 'dart:async';
import 'dart:math' as math;

import 'package:squadron/squadron.dart';

import 'prime_lab.activator.g.dart';

part 'prime_lab.worker.g.dart';

@SquadronService.vm()
base class PrimeLab {
  @SquadronMethod()
  FutureOr<Map<String, Object>> scanPrimes(int limit) {
    final cappedLimit = limit.clamp(1_000, 200_000);
    final stopwatch = Stopwatch()..start();

    var primeCount = 0;
    var largestPrime = 0;
    var checksum = 0;

    for (var value = 2; value <= cappedLimit; value++) {
      if (_isPrime(value)) {
        primeCount++;
        largestPrime = value;
        checksum = (checksum + value) % 1_000_000_007;
      }
    }

    stopwatch.stop();
    return {
      'requestedLimit': limit,
      'limit': cappedLimit,
      'primeCount': primeCount,
      'largestPrime': largestPrime,
      'checksum': checksum,
      'elapsedMs': stopwatch.elapsedMicroseconds / 1000,
      'threadId': threadId,
    };
  }

  bool _isPrime(int candidate) {
    if (candidate < 2) {
      return false;
    }
    if (candidate == 2) {
      return true;
    }
    if (candidate.isEven) {
      return false;
    }

    final upperBound = math.sqrt(candidate).floor();
    for (var factor = 3; factor <= upperBound; factor += 2) {
      if (candidate % factor == 0) {
        return false;
      }
    }
    return true;
  }
}
