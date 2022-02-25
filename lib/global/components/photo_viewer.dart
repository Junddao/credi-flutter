import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({Key? key, String? filePath})
      : _filePath = filePath,
        super(key: key);

  final String? _filePath;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget._filePath!),
        ),
      ),
    );
  }
}
