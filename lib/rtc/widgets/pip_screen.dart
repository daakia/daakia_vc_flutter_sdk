import 'package:daakia_vc_flutter_sdk/screens/customWidget/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PipScreen extends StatefulWidget {
  const PipScreen({required this.name, super.key});
  final String? name;

  @override
  State<PipScreen> createState() => _PipScreenState();
}

class _PipScreenState extends State<PipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color:CupertinoColors.black, child: Center(child: InitialsCircle(initials: Utils.getInitials(widget.name), backgroundColor: Colors.purple, size: 70,),)));
  }
}
