// Procedurally baked sprite textures for the particle explosion demo,
// copied from the flutter_scene example app (examples/flutter_app/lib/
// vfx_textures.dart): a fireball flipbook, an eroding smoke flipbook, and a
// soft dot, all generated from fbm noise at load time.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_scene/noise.dart';

double vfxSmoothstep(double a, double b, double x) {
  final double t = ((x - a) / (b - a)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}

/// Maps a normalized temperature to an approximate blackbody color (sRGB),
/// from extinguished black through deep red, orange, and yellow to
/// near-white.
(double, double, double) vfxBlackbody(double temp) {
  const List<(double, double, double, double)> stops =
      <(double, double, double, double)>[
        (0.0, 0.0, 0.0, 0.0),
        (0.20, 0.32, 0.02, 0.0),
        (0.45, 0.85, 0.22, 0.01),
        (0.70, 1.0, 0.62, 0.10),
        (0.88, 1.0, 0.86, 0.42),
        (1.0, 1.0, 0.98, 0.82),
      ];
  final double t = temp.clamp(0.0, 1.0);
  for (int i = 1; i < stops.length; i++) {
    if (t <= stops[i].$1) {
      final (double, double, double, double) a = stops[i - 1];
      final (double, double, double, double) b = stops[i];
      final double f = (t - a.$1) / (b.$1 - a.$1);
      return (
        a.$2 + (b.$2 - a.$2) * f,
        a.$3 + (b.$3 - a.$3) * f,
        a.$4 + (b.$4 - a.$4) * f,
      );
    }
  }
  return (1.0, 0.98, 0.82);
}

Future<ui.Image> vfxImageFromPixels(Uint8List pixels, int size) {
  final Completer<ui.Image> completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    pixels,
    size,
    size,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}

/// Bakes the 8x8 fireball flipbook (played once over life): a turbulent
/// radial ball that flashes white-hot, rolls as it expands, then erodes away
/// through cooling blackbody colors.
Future<ui.Image> bakeFireballAtlas() async {
  const int grid = 8;
  const int cell = 96;
  const int size = grid * cell;
  const int frames = grid * grid;
  final Uint8List pixels = Uint8List(size * size * 4);

  final FastNoiseLite warpNoise = FastNoiseLite()
    ..seed = 57
    ..frequency = 1.0
    ..fractalType = FractalType.fbm
    ..octaves = 3;
  final FastNoiseLite mainNoise = FastNoiseLite()
    ..seed = 58
    ..frequency = 1.0
    ..fractalType = FractalType.fbm
    ..octaves = 3;

  for (int f = 0; f < frames; f++) {
    final double t = f / (frames - 1);
    final double evolve = f * 0.05;
    // The ball reaches full radius quickly and holds while it erodes.
    final double radius = 0.55 + 0.4 * vfxSmoothstep(0.0, 0.35, t);
    final double erosion = 0.10 + 0.72 * vfxSmoothstep(0.25, 1.0, t);
    final double cooling = 1.0 - 0.55 * vfxSmoothstep(0.2, 1.0, t);

    final int cellX = (f % grid) * cell;
    final int cellY = (f ~/ grid) * cell;
    for (int py = 0; py < cell; py++) {
      final double y = ((py + 0.5) / cell) * 2.0 - 1.0;
      final int rowBase = ((cellY + py) * size + cellX) * 4;
      for (int px = 0; px < cell; px++) {
        final double x = ((px + 0.5) / cell) * 2.0 - 1.0;

        // Radial warp rolls the ball's surface as it grows.
        final double w = warpNoise.getNoise3(x * 2.4, y * 2.4, evolve + 11.1);
        final double r = sqrt(x * x + y * y) + w * 0.22;
        final double radial = (1.0 - (r / radius) * (r / radius)).clamp(
          0.0,
          1.0,
        );
        final double n =
            mainNoise.getNoise3(x * 2.8, y * 2.8, evolve) * 0.5 + 0.5;
        final double density = radial * (0.4 + 0.6 * n) * 1.5;
        final double value = ((density - erosion) / 0.25).clamp(0.0, 1.0);

        final double temp = (value * (0.7 + 0.6 * n) * cooling).clamp(
          0.0,
          1.0,
        );
        final (double cr, double cg, double cb) = vfxBlackbody(temp);
        final double alpha = (value * 1.5).clamp(0.0, 1.0);
        final int o = rowBase + px * 4;
        pixels[o] = (cr * 255).round();
        pixels[o + 1] = (cg * 255).round();
        pixels[o + 2] = (cb * 255).round();
        pixels[o + 3] = (alpha * 255).round();
      }
    }
    // Yield between frames so the loading UI stays responsive.
    if (f % 8 == 7) await Future<void>.delayed(Duration.zero);
  }
  return vfxImageFromPixels(pixels, size);
}

/// Bakes the 4x4 smoke flipbook (played once over life): a billowy fbm puff
/// with baked shading that is progressively eaten by a rising erosion
/// threshold, so old smoke tears apart instead of uniformly fading.
Future<ui.Image> bakeSmokeAtlas() async {
  const int grid = 4;
  const int cell = 128;
  const int size = grid * cell;
  const int frames = grid * grid;
  final Uint8List pixels = Uint8List(size * size * 4);

  final FastNoiseLite noise = FastNoiseLite()
    ..seed = 17
    ..frequency = 1.0
    ..fractalType = FractalType.fbm
    ..octaves = 4;

  for (int f = 0; f < frames; f++) {
    final double t = f / (frames - 1);
    final double evolve = f * 0.22;
    final double erosion = 0.18 + 0.55 * vfxSmoothstep(0.2, 1.0, t);

    final int cellX = (f % grid) * cell;
    final int cellY = (f ~/ grid) * cell;
    for (int py = 0; py < cell; py++) {
      final double y = ((py + 0.5) / cell) * 2.0 - 1.0;
      final int rowBase = ((cellY + py) * size + cellX) * 4;
      for (int px = 0; px < cell; px++) {
        final double x = ((px + 0.5) / cell) * 2.0 - 1.0;
        final double r2 = x * x + y * y;
        final double base = (1 - r2).clamp(0.0, 1.0);

        // Billow noise (folded fbm) gives the cauliflower look.
        final double n = noise.getNoise3(x * 1.9, y * 1.9, evolve);
        final double billow = 1.0 - n.abs();
        final double density = base * (0.35 + 0.65 * billow * billow);
        // A softer edge and a late-life fade keep eroded frames wispy rather
        // than stringy.
        final double value =
            ((density - erosion) / 0.42).clamp(0.0, 1.0) *
            (1.0 - 0.45 * vfxSmoothstep(0.5, 1.0, t));

        // Bake soft self-shading, brighter toward the puff's upper lobe.
        final double shade = (0.62 + 0.38 * billow) * (0.85 - 0.15 * y);
        final int o = rowBase + px * 4;
        final int v = (shade.clamp(0.0, 1.0) * 255).round();
        pixels[o] = v;
        pixels[o + 1] = v;
        pixels[o + 2] = v;
        pixels[o + 3] = (value * 255).round();
      }
    }
    if (f % 4 == 3) await Future<void>.delayed(Duration.zero);
  }
  return vfxImageFromPixels(pixels, size);
}

/// A 64x64 white dot with a Gaussian falloff (slope zero at the rim), for
/// embers, sparks, and glows.
Future<ui.Image> bakeSoftDot() {
  const int size = 64;
  final Uint8List pixels = Uint8List(size * size * 4);
  const double half = size / 2;
  const double sigma = size * 0.20;
  final double rim = exp(-0.5 * (half / sigma) * (half / sigma));
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final double dx = x + 0.5 - half;
      final double dy = y + 0.5 - half;
      final double r = sqrt(dx * dx + dy * dy);
      final double g = exp(-0.5 * (r / sigma) * (r / sigma));
      final double a = ((g - rim) / (1.0 - rim)).clamp(0.0, 1.0);
      final int i = (y * size + x) * 4;
      pixels[i] = 255;
      pixels[i + 1] = 255;
      pixels[i + 2] = 255;
      pixels[i + 3] = (a * 255).round();
    }
  }
  return vfxImageFromPixels(pixels, size);
}
