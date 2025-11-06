import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../utils/utils.dart';

class FileTypePreviewWidget extends StatelessWidget {
  final String fileUrl;
  final double iconSize;

  const FileTypePreviewWidget({
    super.key,
    required this.fileUrl,
    this.iconSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    final mimeType = lookupMimeType(fileUrl) ?? '';
    final fileExtension = fileUrl.split('.').last.toLowerCase();
    final fileName = Utils.extractFileName(fileUrl);

    Widget buildFileIcon() {
      if (mimeType.startsWith('image/')) {
        return const Icon(Icons.image, size: 25, color: Colors.lightBlue);
      } else if (mimeType.startsWith('video/')) {
        return const Icon(Icons.video_library, size: 25, color: Colors.purple);
      } else if (mimeType.startsWith('audio/')) {
        return const Icon(Icons.audiotrack, size: 25, color: Colors.orange);
      } else if (mimeType.startsWith('application/pdf')) {
        return const Icon(Icons.picture_as_pdf, size: 25, color: Colors.red);
      } else if (mimeType.startsWith('application/vnd') ||
          fileExtension.contains('ppt')) {
        return const Icon(Icons.slideshow, size: 25, color: Colors.orange);
      } else if (mimeType.startsWith('application/msword') ||
          mimeType.startsWith(
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document')) {
        return const Icon(Icons.description, size: 25, color: Colors.blue);
      } else if (mimeType
          .startsWith('application/vnd.android.package-archive')) {
        return const Icon(Icons.android, size: 25, color: Colors.green);
      } else if (mimeType.startsWith('application/')) {
        return const Icon(Icons.insert_drive_file,
            size: 25, color: Colors.white70);
      } else {
        return const Icon(Icons.link,
            size: 25, color: Colors.white);
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          buildFileIcon(),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
