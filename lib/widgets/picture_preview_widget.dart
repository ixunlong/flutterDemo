import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PicturePreview extends StatefulWidget {
  const PicturePreview({super.key, this.imageUrl, this.path});

  final String? imageUrl;
  final String? path;

  @override
  State<PicturePreview> createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  final PhotoViewControllerBase _photoViewController = PhotoViewController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: GestureDetector(
        onTap: () => Get.back(),
        child: PhotoView(
          loadingBuilder: (context, event) => Center(
              child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                      value: event?.cumulativeBytesLoaded.toDouble()))),
          backgroundDecoration: const BoxDecoration(color: Colors.black45),
          controller: _photoViewController,
          minScale: PhotoViewComputedScale.contained * 0.5,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          imageProvider: widget.imageUrl == null
              ? Image.asset(widget.path!).image
              : NetworkImage(widget.imageUrl!),
        ),
      ),
    );
  }
}
