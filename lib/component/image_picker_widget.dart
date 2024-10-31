// image_picker_widget.dart
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHandler {
  final ImagePicker _picker = ImagePicker();
  final double imageMaxSizeKB;
  final double videoMaxSizeMB;

  ImagePickerHandler({
    this.imageMaxSizeKB = 100.0,
    this.videoMaxSizeMB = 5.0,
  });

  Future<List<XFile>> pickImages(
      {required bool fromCamera, bool isMultiple = false}) async {
    List<XFile> images = [];
    List<XFile>? pickedFiles;

    if (isMultiple) {
      pickedFiles = await _picker.pickMultiImage();
    } else {
      final XFile? pickedFile = await _picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        pickedFiles = [pickedFile];
      }
    }

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        XFile? compressedImage = await _compressImage(File(file.path));
        if (compressedImage != null) {
          images.add(compressedImage);
        }
      }
    }

    return images;
  }

  // Future<File?> pickVideo() async {
  //   final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final File videoFile = File(pickedFile.path);
  //     if (await _validateVideoSize(videoFile)) {
  //       return videoFile;
  //     }
  //   }
  //   return null;
  // }

  Future< /*File?*/ XFile?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 800,
      minHeight: 600,
    );
    log("Image size----- : $imageMaxSizeKB");
    if (compressedFile != null &&
        await compressedFile.length() / 1024 <= imageMaxSizeKB) {
      log("------- ${(await compressedFile.length()).toString()}");
      return compressedFile;
    }
    return null;
  }

  // Future<bool> _validateVideoSize(File file) async {
  //   final sizeInMB = await file.length() / (1024 * 1024);
  //   return sizeInMB <= videoMaxSizeMB;
  // }
}
