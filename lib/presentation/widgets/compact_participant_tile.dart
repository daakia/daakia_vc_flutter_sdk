import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';

class CompactParticipantTile extends StatelessWidget {
  const CompactParticipantTile({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          // Initials Circle
          InitialsCircle(
            initials: Utils.getInitials(name),
          ),
          const SizedBox(width: 10),
          // Participant Name
          Expanded(
            child: Text(
              name ?? "Unknown",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
