// transcript_download_choice_dialog.dart
import 'package:flutter/material.dart';

enum TranscriptDownloadChoice {
  original,
  translated,
}

class TranscriptDownloadChoiceDialog extends StatelessWidget {
  const TranscriptDownloadChoiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Download Transcription", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Choose which version of the transcription you want to download.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black87,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.text_snippet_outlined),
          label: const Text("Original"),
          onPressed: () =>
              Navigator.pop(context, TranscriptDownloadChoice.original),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.translate),
          label: const Text("Translated"),
          onPressed: () =>
              Navigator.pop(context, TranscriptDownloadChoice.translated),
        ),
      ],
    );
  }
}
