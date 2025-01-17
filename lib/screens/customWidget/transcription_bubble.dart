import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/transcription_model.dart';

class TranscriptionBubble extends StatefulWidget {
  final TranscriptionModel transcriptionData;
  final RtcViewmodel viewModel;

  const TranscriptionBubble(
      {required this.viewModel, required this.transcriptionData, super.key});

  @override
  State<TranscriptionBubble> createState() => _TranscriptionBubbleState();
}

class _TranscriptionBubbleState extends State<TranscriptionBubble> {
  bool _isTranslating = false; // State to track if translation is in progress

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Name
            Text(
              widget.transcriptionData.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5.0),

            // Message Bubble
            Card(
              color: const Color(0xFF303030),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200, minWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transcription Text
                      Text(
                        widget.transcriptionData.translatedTranscription ??
                            widget.transcriptionData.transcription,
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (widget.transcriptionData.isFinal &&
                          (widget.transcriptionData.targetLang !=
                              (widget.viewModel.translationLanguage?.code ??
                                  widget.transcriptionData.targetLang)))
                        Align(
                          alignment: Alignment.centerRight,
                          child: _isTranslating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : GestureDetector(
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_translate_chats_colored.svg',
                                    package: 'daakia_vc_flutter_sdk',
                                    fit: BoxFit.fill,
                                    height: 20,
                                    width: 20,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isTranslating =
                                          true; // Start the translation task
                                    });

                                    widget.viewModel.translateText(
                                        widget.transcriptionData, callBack: () {
                                      setState(() {
                                        _isTranslating =
                                            false; // Task completed
                                      });
                                    });
                                  },
                                ),
                        ),
                      const SizedBox(height: 5.0),
                      // Sent Time
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.transcriptionData.timestamp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
