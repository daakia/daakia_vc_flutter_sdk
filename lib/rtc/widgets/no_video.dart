import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';


class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({this.name, this.userAvatar, super.key});

  final String? name;
  final String? userAvatar;

  @override
  Widget build(BuildContext context) {
    final initials = Utils.getInitials(name);
    final bgColor = Utils.generateUniqueColorFromInitials(name ?? "U");

    final bool hasAvatar =
        userAvatar != null && userAvatar!.trim().isNotEmpty;

    return Container(
      alignment: Alignment.center,
      child: hasAvatar
          ? ClipOval(
        child: Image.network(
          userAvatar!,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _buildInitials(initials, bgColor),
        ),
      )
          : _buildInitials(initials, bgColor),
    );
  }

  Widget _buildInitials(String initials, Color bgColor) {
    return InitialsCircle(
      initials: initials,
      backgroundColor: bgColor,
    );
  }
}

