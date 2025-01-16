import 'dart:io';

import 'package:image_picker/image_picker.dart';

class NativeServices {
  final _imagePicker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
