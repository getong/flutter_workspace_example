// Build hook for the flutter_scene example gallery (copied from the
// flutter_scene example app's hook/build.dart): preprocesses the glTF
// corpus into .fsceneb scene packages, cooks loose textures, compiles the
// raw shader bundle, and compiles the .fmat custom materials.

import 'package:flutter_gpu_shaders/build.dart';
import 'package:flutter_scene/build_hooks.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) {
  build(args, (config, output) async {
    const corpus = [
      'assets_src/two_triangles.glb',
      'assets_src/flutter_logo_baked.glb',
      'assets_src/dash.glb',
      'assets_src/fcar.glb',
    ];
    // The corpus as `.fsceneb` packages, loaded by source path through
    // loadScene.
    buildScenes(
      buildInput: config,
      buildOutput: output,
      inputFilePaths: corpus,
      assetMode: SceneAssetMode.generatedTree,
      // Store imported textures as compressed KTX2 block payloads so the
      // import -> compress -> render path is exercised in the app (dash's
      // textures shrink the most).
      compressTextures: true,
    );
    // A loose (non-glTF) image cooked into the engine's compressed texture
    // container, loaded by source path through loadTexture (the Logo
    // example's ground).
    buildTextures(
      buildInput: config,
      buildOutput: output,
      textures: ['assets/ground_grid.png'],
      assetMode: TextureAssetMode.generatedTree,
    );
    await buildShaderBundleJson(
      buildInput: config,
      buildOutput: output,
      manifestFileName: 'shaders/example.shaderbundle.json',
      // Match the engine bundle's GLES dialect (see the flutter_scene hook).
      glesLanguageVersion: 300,
    );
    // Compile .fmat custom materials into a bundle plus a parameter sidecar,
    // consumed through loadFmatMaterial. With no explicit list,
    // assets/**/*.fmat is auto-discovered. Generated outputs resolve by source
    // path and support hot reload through flutter_scene_generated/.
    await buildMaterials(
      buildInput: config,
      buildOutput: output,
      assetMode: MaterialAssetMode.generatedTree,
    );
  });
}
