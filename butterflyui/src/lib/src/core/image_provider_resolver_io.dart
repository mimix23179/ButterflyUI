import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider? resolveImageProviderPlatform(String src) {
  final trimmed = src.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('data:')) {
    try {
      final data = UriData.parse(trimmed);
      return MemoryImage(data.contentAsBytes());
    } catch (_) {
      return null;
    }
  }
  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.hasScheme) {
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') {
      return NetworkImage(trimmed);
    }
    if (scheme == 'file') {
      return FileImage(File.fromUri(uri));
    }
  }
  return FileImage(File(trimmed));
}
