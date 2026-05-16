import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.imageCropper)
class ImageCropperPage extends StatefulWidget {
  const ImageCropperPage({super.key});

  @override
  State<ImageCropperPage> createState() => _ImageCropperPageState();
}

class _ImageCropperPageState extends State<ImageCropperPage> {
  static const String _assetPath = 'assets/images/image_module_demo.png';

  final ImageCropper _cropper = ImageCropper();
  final List<CropAspectRatioPresetData> _presets = <CropAspectRatioPresetData>[
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio16x9,
    const _PosterPreset(),
  ];

  Uint8List? _sourceBytes;
  Uint8List? _croppedBytes;
  String? _preparedSourcePath;
  String _status = 'Preparing a bundled sample image for the cropper.';
  bool _isPreparing = false;
  bool _isCropping = false;
  bool _lockAspectRatio = false;
  CropStyle _cropStyle = CropStyle.rectangle;
  ImageCompressFormat _compressFormat = ImageCompressFormat.jpg;
  CropAspectRatioPresetData _selectedPreset = CropAspectRatioPreset.original;

  bool get _supportsInteractiveCropping {
    if (kIsWeb) {
      return true;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();
    _prepareSampleImage();
  }

  Future<void> _prepareSampleImage() async {
    setState(() {
      _isPreparing = true;
      _status = 'Loading the bundled demo image.';
    });

    try {
      final ByteData data = await rootBundle.load(_assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      String sourcePath = _assetPath;

      if (!kIsWeb) {
        final Directory tempDirectory = await getTemporaryDirectory();
        final File sampleFile = File(
          '${tempDirectory.path}${Platform.pathSeparator}image-cropper-demo.png',
        );
        await sampleFile.writeAsBytes(bytes, flush: true);
        sourcePath = sampleFile.path;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _sourceBytes = bytes;
        _preparedSourcePath = sourcePath;
        _isPreparing = false;
        _status = _supportsInteractiveCropping
            ? 'Sample image prepared. Launch the cropper to test the current settings.'
            : 'Sample image prepared. Interactive cropping is supported on Android, iOS, and Web.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isPreparing = false;
        _status = 'Failed to prepare the sample image: $error';
      });
    }
  }

  Future<void> _cropImage() async {
    final String? sourcePath = _preparedSourcePath;
    if (sourcePath == null || !_supportsInteractiveCropping) {
      return;
    }

    setState(() {
      _isCropping = true;
      _status = 'Opening the cropper with the current preset and UI settings.';
    });

    try {
      final CroppedFile? croppedFile = await _cropper.cropImage(
        sourcePath: sourcePath,
        maxWidth: 1400,
        maxHeight: 1400,
        aspectRatio: _lockAspectRatio
            ? _cropAspectRatioFor(_selectedPreset)
            : null,
        compressFormat: _compressFormat,
        compressQuality: 92,
        uiSettings: <PlatformUiSettings>[
          AndroidUiSettings(
            toolbarTitle: 'Widget Cropper Demo',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
            initAspectRatio: _selectedPreset,
            lockAspectRatio: _lockAspectRatio,
            cropStyle: _cropStyle,
            aspectRatioPresets: _presets,
          ),
          IOSUiSettings(
            title: 'Widget Cropper Demo',
            doneButtonTitle: 'Use Crop',
            cancelButtonTitle: 'Back',
            aspectRatioLockEnabled: _lockAspectRatio,
            resetAspectRatioEnabled: !_lockAspectRatio,
            cropStyle: _cropStyle,
            aspectRatioPresets: _presets,
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(width: 560, height: 420),
            initialAspectRatio: _selectedPreset.data == null
                ? null
                : _selectedPreset.data!.$1 / _selectedPreset.data!.$2,
            viewwMode: WebViewMode.mode_1,
            dragMode: WebDragMode.move,
            zoomable: true,
            movable: true,
            cropBoxResizable: true,
            cropBoxMovable: true,
            barrierColor: Colors.black54,
            translations: const WebTranslations(
              title: 'Widget Cropper Demo',
              rotateLeftTooltip: 'Rotate Left',
              rotateRightTooltip: 'Rotate Right',
              cancelButton: 'Cancel',
              cropButton: 'Crop',
            ),
          ),
        ],
      );

      if (!mounted) {
        return;
      }

      if (croppedFile == null) {
        setState(() {
          _status = 'Cropper closed without producing a result.';
          _isCropping = false;
        });
        return;
      }

      final Uint8List croppedBytes = await croppedFile.readAsBytes();
      setState(() {
        _croppedBytes = croppedBytes;
        _status =
            'Crop completed using `${_selectedPreset.name}` and `${_cropStyle.name}` with `${_compressFormat.name}` output.';
        _isCropping = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Cropping failed: $error';
        _isCropping = false;
      });
    }
  }

  CropAspectRatio? _cropAspectRatioFor(CropAspectRatioPresetData preset) {
    final (int ratioX, int ratioY)? ratio = preset.data;
    if (ratio == null) {
      return null;
    }

    return CropAspectRatio(
      ratioX: ratio.$1.toDouble(),
      ratioY: ratio.$2.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('image_cropper Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'image_cropper launches a platform crop UI and returns a cropped file, which makes it useful when Flutter needs native-feeling image editing without building the crop interaction from scratch.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates a bundled sample image with `cropImage`, `CropAspectRatio`, `CropStyle`, `ImageCompressFormat`, `AndroidUiSettings`, `IOSUiSettings`, and `WebUiSettings`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Source and Result Preview',
              description:
                  'The original asset is copied into a temporary file on native platforms because the cropper expects a file path.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _PreviewCard(
                    title: 'Bundled Source',
                    subtitle: _preparedSourcePath ?? 'Preparing source path...',
                    child: _sourceBytes == null
                        ? const SizedBox(
                            height: 220,
                            width: 220,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.memory(
                              _sourceBytes!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  _PreviewCard(
                    title: 'Cropped Result',
                    subtitle: _croppedBytes == null
                        ? 'No crop result yet.'
                        : '${_croppedBytes!.lengthInBytes} bytes',
                    child: _croppedBytes == null
                        ? Container(
                            width: 220,
                            height: 220,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text('Launch the cropper'),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.memory(
                              _croppedBytes!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Cropper Configuration',
              description:
                  'These controls change the arguments passed into `cropImage` so you can test aspect ratio locking, output format, and crop shape.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Aspect Ratio Presets',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _presets
                        .map(
                          (CropAspectRatioPresetData preset) => ChoiceChip(
                            label: Text(_presetLabel(preset)),
                            selected: identical(_selectedPreset, preset),
                            onSelected: (bool selected) {
                              if (!selected) {
                                return;
                              }
                              setState(() {
                                _selectedPreset = preset;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Lock aspect ratio'),
                        selected: _lockAspectRatio,
                        onSelected: (bool value) {
                          setState(() {
                            _lockAspectRatio = value;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Rectangle crop'),
                        selected: _cropStyle == CropStyle.rectangle,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _cropStyle = CropStyle.rectangle;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Circle crop'),
                        selected: _cropStyle == CropStyle.circle,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _cropStyle = CropStyle.circle;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('JPEG output'),
                        selected: _compressFormat == ImageCompressFormat.jpg,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _compressFormat = ImageCompressFormat.jpg;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('PNG output'),
                        selected: _compressFormat == ImageCompressFormat.png,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _compressFormat = ImageCompressFormat.png;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Actions and Platform Notes',
              description:
                  'Desktop platforms can still inspect the configuration and prepared file path, but the interactive crop view itself is only enabled where the plugin supports it.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isPreparing ? null : _prepareSampleImage,
                        icon: const Icon(Icons.file_download_done_outlined),
                        label: const Text('Prepare Sample Asset'),
                      ),
                      FilledButton.icon(
                        onPressed:
                            _isCropping ||
                                _isPreparing ||
                                !_supportsInteractiveCropping ||
                                _preparedSourcePath == null
                            ? null
                            : _cropImage,
                        icon: const Icon(Icons.crop_outlined),
                        label: const Text('Launch Cropper'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _croppedBytes == null
                            ? null
                            : () {
                                setState(() {
                                  _croppedBytes = null;
                                  _status =
                                      'Cleared the previous crop result. The sample image is still ready.';
                                });
                              },
                        icon: const Icon(Icons.layers_clear_outlined),
                        label: const Text('Clear Result'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_status, style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 12),
                          Text(
                            'Interactive crop support: ${_supportsInteractiveCropping ? 'enabled on this platform' : 'not available on this platform'}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Prepared source path: ${_preparedSourcePath ?? 'not ready yet'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'API Coverage in This Demo',
              description:
                  'The page intentionally exercises more than the minimum happy path so the module can act as a reference when you reuse the package elsewhere.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  _ApiLine(
                    '`ImageCropper().cropImage` with `maxWidth` and `maxHeight`.',
                  ),
                  _ApiLine(
                    '`CropAspectRatio` when aspect ratio locking is enabled.',
                  ),
                  _ApiLine(
                    '`ImageCompressFormat.jpg` and `ImageCompressFormat.png`.',
                  ),
                  _ApiLine('`CropStyle.rectangle` and `CropStyle.circle`.'),
                  _ApiLine(
                    'Platform-specific UI configuration for Android, iOS, and Web.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(CropAspectRatioPresetData preset) {
    final (int ratioX, int ratioY)? ratio = preset.data;
    if (ratio == null) {
      return 'Original';
    }
    return '${ratio.$1}:${ratio.$2}';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Center(child: child),
        ],
      ),
    );
  }
}

class _ApiLine extends StatelessWidget {
  const _ApiLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text),
    );
  }
}

class _PosterPreset implements CropAspectRatioPresetData {
  const _PosterPreset();

  @override
  (int ratioX, int ratioY)? get data => (2, 3);

  @override
  String get name => 'poster';
}
