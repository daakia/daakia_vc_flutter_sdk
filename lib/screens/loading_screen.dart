import 'package:daakia_vc_flutter_sdk/resources/colors/color.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite, height: double.maxFinite,
      color: const Color.fromARGB(121, 0, 0, 0),
      child: const Center(child: CircularProgressIndicator(color: themeColor,)),
    );
  }

}