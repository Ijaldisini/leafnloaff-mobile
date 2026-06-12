import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<List<File>> pickMultipleMedia() async {
    final List<XFile> media = await _picker.pickMultipleMedia(imageQuality: 70);
    return media.map((e) => File(e.path)).toList();
  }

  Future<File?> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  Future<File?> pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      return File(video.path);
    }
    return null;
  }
}
