import 'package:flutter/material.dart';

class HostControlSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isChild; // 👈 new flag for child styling
  final bool isDividerRequired;

  const HostControlSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isChild = false,
    this.isDividerRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = isChild ? 20 : 25;
    final double subtitleFontSize = isChild ? 13 : 15;
    final double leftIndent = isChild ? 30 : 0;

    return Padding(
      padding: EdgeInsets.only(left: leftIndent),
      child: Column(
        children: [
          SwitchListTile(
            value: value,
            onChanged: onChanged,
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: subtitleFontSize,
              ),
            ),
            activeThumbColor: Colors.greenAccent,
          ),
          if (isDividerRequired) const Divider(color: Colors.white),
        ],
      ),
    );
  }
}
