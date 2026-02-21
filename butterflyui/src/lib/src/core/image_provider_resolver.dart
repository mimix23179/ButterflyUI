import 'package:flutter/material.dart';

import 'image_provider_resolver_stub.dart'
    if (dart.library.io) 'image_provider_resolver_io.dart';

ImageProvider? resolveImageProviderImpl(String src) {
  return resolveImageProviderPlatform(src);
}
