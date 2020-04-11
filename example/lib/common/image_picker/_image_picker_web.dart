@JS()
library image_saver;

// ignore:avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'package:js/js.dart';

@JS()
external void _exportRaw(String key, Uint8List value);

class ImageSaver {
  static Future<String> save(String name, Uint8List fileData) async {
    _exportRaw(name, fileData);
    return name;
  }
}

Future<Uint8List> pickImage() async {
  final completer = Completer<Uint8List>();
  final input = document.createElement('input') as InputElement;

  input
    ..type = 'file'
    ..accept = 'image/*';
  input.onChange.listen((e) async {
    final files = input.files;
    final reader = FileReader();
    reader.readAsArrayBuffer(files[0]);
    reader.onError.listen((error) => completer.completeError(error));
    await reader.onLoad.first;
    completer.complete(reader.result as Uint8List);
  });
  input.click();
  return completer.future;
}
