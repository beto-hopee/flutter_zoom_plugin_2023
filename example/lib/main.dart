import 'package:flutter/material.dart';
import 'package:flutter_zoom_example/meeting_bindings.dart';
import 'package:get/get.dart';
import 'meeting_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'zoom meeting',
      defaultTransition: Transition.fadeIn,
      home: const MeetingScreen(),
      initialBinding: MeetingBindings(),
    );
  }
}
