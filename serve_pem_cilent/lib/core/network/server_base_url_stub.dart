String resolvePlatformServePemBaseUrl() {
  const override = String.fromEnvironment('SERVE_PEM_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  return 'https://127.0.0.1:3030';
}
