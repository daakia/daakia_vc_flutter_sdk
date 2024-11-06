import 'package:daakia_vc_flutter_sdk/screens/customWidget/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


import '../../resources/colors/color.dart';

class NoVideoWidget extends StatelessWidget {
  //
  NoVideoWidget({this.name, super.key});
  String? name;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: InitialsCircle(
            initials: Utils.getInitials(name),
          backgroundColor: Utils.generateUniqueColorFromInitials(name??"U"),
        )
      );
}
