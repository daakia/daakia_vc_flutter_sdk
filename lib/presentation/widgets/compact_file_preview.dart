import 'dart:io';

import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../events/rtc_events.dart';

class LocalFilePreview extends StatefulWidget {
  final File file;
  double progress = 0.0;
  final RtcViewmodel viewModel;

  LocalFilePreview(
      {super.key,
      required this.file,
      this.progress = 0.0,
      required this.viewModel});

  @override
  State<LocalFilePreview> createState() => _LocalFilePreviewState();
}

class _LocalFilePreviewState extends State<LocalFilePreview> {
  @override
  Widget build(BuildContext context) {
    collectLobbyEvents(widget.viewModel);
    final fileName = widget.file.path.split('/').last;
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
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
          if (widget.progress != -1)
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: widget.progress, // Progress value
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

  bool isEventAdded = false;

  void collectLobbyEvents(RtcViewmodel? viewModel) {
    if (isEventAdded) return;
    isEventAdded = true;
    viewModel?.uploadAttachmentController.listen((event) {
      if (event is UpdateView) {
        if (mounted) {
          setState(() {});
        }
      } else if (event is ShowProgress) {
        if (mounted) {
          setState(() {
            widget.progress = event.progress;
          });
        }
      }
    });
  }
}
