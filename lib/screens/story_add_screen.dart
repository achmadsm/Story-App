import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:submission/provider/pick_image_provideer.dart';

import '../provider/upload_provider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class StoryAddScreen extends StatefulWidget {
  const StoryAddScreen({Key? key}) : super(key: key);

  @override
  State<StoryAddScreen> createState() => _StoryAddScreenState();
}

class _StoryAddScreenState extends State<StoryAddScreen> {
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Story'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: context.watch<PickImageProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 300,
                      ),
                    )
                  : _showImage(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  button: 'Elevated',
                  text: 'Camera',
                  onPressed: () => _onCameraView(),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  button: 'Elevated',
                  text: 'Gallery',
                  onPressed: () => _onGalleryView(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 300,
              child: CustomTextFormField(
                controller: descriptionController,
                hitText: 'Description',
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              child: context.watch<UploadProvider>().isUploading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : CustomButton(
                      button: 'Elevated',
                      text: 'Upload',
                      onPressed: () => _onUpload(descriptionController.text),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _onUpload(String description) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final pickImageProvider = context.read<PickImageProvider>();
    final uploadProvider = context.read<UploadProvider>();

    final imagePath = pickImageProvider.imagePath;
    final imageFile = pickImageProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(
      newBytes,
      fileName,
      description,
      'Token',
    );

    if (uploadProvider.uploadResponse != null) {
      pickImageProvider.setImageFile(null);
      pickImageProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<PickImageProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<PickImageProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<PickImageProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.cover,
          );
  }
}
