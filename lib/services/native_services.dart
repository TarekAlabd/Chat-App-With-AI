import 'dart:io';

import 'package:image_picker/image_picker.dart';

class NativeServices {
  final _imagePicker = ImagePicker();

  Future<File?> pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
