import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FileService {
  static Future<File?> pickImage({required ImageSource src}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: src);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      // return File('');
      return null;
    } on PlatformException catch (e) {
      debugPrint('Filed to pick image: $e');
    } on Exception catch (e) {
      log(e.toString());
      // return File('');
      return null;
    }
    return null;
  }

  static Future<dynamic> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['mp4'],
        type: FileType.custom,
        allowCompression: true,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<List<File>> pickMultiImage() async {
    List<File>? imageFileList = [];

    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage();

      log(images!.length.toString());

      if (images.isNotEmpty) {
        for (var element in images) {
          imageFileList.add(File(element.path));
        }
        return imageFileList;
      }
      log(images.toString());
      return [];
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
