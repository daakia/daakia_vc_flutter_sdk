import 'dart:io';

import 'package:flutter/material.dart';

class LocalFilePreview extends StatelessWidget {
  final File file;
  double progress = 0.0;

  LocalFilePreview({super.key, required this.file, this.progress = 0.0});

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;
    final fileExtension = fileName.split('.').last.toLowerCase();

    // Determine file type icon
    IconData getFileIcon() {
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
        case 'png':
        case 'gif':
          return Icons.image;
        case 'pdf':
          return Icons.picture_as_pdf;
        case 'doc':
        case 'docx':
          return Icons.description;
        case 'ppt':
        case 'pptx':
          return Icons.slideshow;
        case 'zip':
        case 'rar':
          return Icons.folder_zip;
        default:
          return Icons.insert_drive_file;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // File type icon
          Icon(
            getFileIcon(),
            size: 32,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 10),
          // File name
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          // Placeholder for upload progress
          if (progress != -1)
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: progress, // Progress value
                strokeWidth: 2.0,
                color: Colors.green,
                backgroundColor: Colors.grey,
              ),
            )
          else
            const Icon(
              Icons.upload, // Icon shown when progress is -1
              size: 20,
              color: Colors.white54,
            ),
        ],
      ),
    );
  }
}
