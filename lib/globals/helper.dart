import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' as ui;

Future<void> loadFont(String path, String internalName) async {
  try {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Font file not found.');
    }

    // Read font bytes
    final Uint8List fontBytes = await file.readAsBytes();

    // Create loader and register
    final loader = ui.FontLoader(internalName); // internal name
    loader.addFont(Future.value(fontBytes.buffer.asByteData()));
    await loader.load(); // Register to Flutter engine
  } catch (e) {
    // Logging only. App still runs.
    print('Error loading font: $e');
  }
}
