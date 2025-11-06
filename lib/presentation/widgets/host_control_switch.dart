import 'package:flutter/material.dart';

class HostControlSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isChild;
  final bool isDividerRequired;
  final bool isEnable;

  const HostControlSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isChild = false,
    this.isDividerRequired = true,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = isChild ? 20 : 25;
    final double subtitleFontSize = isChild ? 13 : 15;
    final double leftIndent = isChild ? 30 : 0;

    // Adjust colors when disabled
    final Color textColor = isEnable ? Colors.white : Colors.grey.shade500;
    final Color activeColor = isEnable ? Colors.greenAccent : Colors.grey;
    // final Color thumbColor = isEnable ? Colors.greenAccent : Colors.grey.shade700;

    return Padding(
      padding: EdgeInsets.only(left: leftIndent),
      child: Column(
        children: [
          AbsorbPointer( // 👈 prevents interaction when disabled
            absorbing: !isEnable,
            child: Opacity( // 👈 adds visual feedback for disabled state
              opacity: isEnable ? 1.0 : 0.6,
              child: SwitchListTile(
                value: value,
                onChanged: onChanged,
                title: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor,
                    fontSize: subtitleFontSize,
                  ),
                ),
                activeThumbColor: activeColor,
              ),
            ),
          ),
          if (isDividerRequired) const Divider(color: Colors.white),
        ],
      ),
    );
  }
}
