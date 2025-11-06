import 'package:daakia_vc_flutter_sdk/presentation/widgets/file_type_preview_widget.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class PinnedMessageWidget extends StatelessWidget {
  final String? name;
  final String message;
  final VoidCallback? onPinPressed;
  final VoidCallback? onPinNavigatePressed;

  const PinnedMessageWidget(
      {super.key,
      required this.name,
      required this.message,
      this.onPinPressed,
      this.onPinNavigatePressed});

  @override
  Widget build(BuildContext context) {
    final initials = Utils.getInitials(name);
    final bgColor = Utils.generateUniqueColorFromInitials(name ?? "U");
    return GestureDetector(
      onTap: onPinNavigatePressed,
      child: Card(
        color: const Color(0xFF303030),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User initials
              InitialsCircle(
                initials: initials,
                size: 34,
                backgroundColor: bgColor,
              ),
              const SizedBox(width: 10),

              // Message text (single line, ellipsis)
              Expanded(
                child: (Utils.isOnlyLink(message) || Utils.isLink(message))
                    ? FileTypePreviewWidget(fileUrl: message)
                    : Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
              ),

              // Pinned icon button
              IconButton(
                onPressed: onPinPressed,
                icon: const Icon(
                  Icons.push_pin_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: "Unpin message",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
