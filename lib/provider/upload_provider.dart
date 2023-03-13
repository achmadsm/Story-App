import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../data/api/api_service.dart';
import '../data/model/upload_response.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService apiService;

  UploadProvider(this.apiService);

  bool isUploading = false;
  String message = '';
  UploadResponse? uploadResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
    String token,
  ) async {
    try {
      message = '';
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      uploadResponse = await apiService.uploadImage(
        bytes,
        fileName,
        description,
        token,
      );

      message = uploadResponse?.message ?? 'success';
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(Uint8List bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }
}
