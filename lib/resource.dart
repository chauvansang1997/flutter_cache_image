library cache_image;

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class Resource {
  final String uri;
  final Duration duration;
  final double durationMultiplier;
  final Duration durationExpiration;

  Uri _temp;
  Uri _local;
  Duration _retry;

  Resource(
      this.uri, this.duration, this.durationMultiplier, this.durationExpiration)
      : assert(uri != null),
        _retry = duration;

  Uri get temp => _temp;
  Uri get local => _local;

  Uri _parse(String uri) {
    return Uri.parse(uri);
  }

  Future<Uri> _getTempDir() async {
    final Directory temp = await getTemporaryDirectory();
    return _parse(temp.path);
  }

  Future<Resource> init() async {
    _temp = await _getTempDir();
    _local = _parse(_temp.path);

    return this;
  }

  Future<bool> checkFile() async {
    final File file = File(_local.path);
    if (file.existsSync() && file.lengthSync() > 0) {
      return true;
    }
    return false;
  }

  Future<Uint8List> getFile() async {
    final File file = File(_local.path);
    if (file.existsSync() && file.lengthSync() > 0) {
      return file.readAsBytesSync();
    }
    return null;
  }

}
