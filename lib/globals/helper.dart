import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' as ui;

Future<void> loadFont(String path, String internalName) async {
  try {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Font file not found.');
    }

    final Uint8List fontBytes = await file.readAsBytes();

    final loader = ui.FontLoader(internalName);
    loader.addFont(Future.value(fontBytes.buffer.asByteData()));
    await loader.load();
  } catch (e) {
    print('Error loading font: $e');
  }
}
