import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButtons extends StatelessWidget {
  final void Function(File?) onImageSelected;
  final bool loading;
  const ImagePickerButtons({
    required this.onImageSelected,
    required this.loading,
    Key? key,
  }) : super(key: key);

  Future<void> _pick(BuildContext context, ImageSource source) async {
    if (loading) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) onImageSelected(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black26,
            ),
            icon: const Icon(Icons.image),
            label: const Text('Pick Image'),
            onPressed:
                loading ? null : () => _pick(context, ImageSource.gallery),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black38,
            ),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            onPressed:
                loading ? null : () => _pick(context, ImageSource.camera),
          ),
        ),
      ],
    );
  }
}
