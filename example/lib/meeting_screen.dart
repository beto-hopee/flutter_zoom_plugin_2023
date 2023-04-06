import 'package:flutter/material.dart';
import 'package:flutter_zoom_example/meeting_controller.dart';
import 'package:flutter_zoom_example/widgets/button.dart';
import 'package:flutter_zoom_example/widgets/text_field.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MeetingScreen extends GetWidget<MeetingController> {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join meeting')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Column(
          children: [
            TextFieldWidget(
              controller: controller.meetingIdController,
              label: 'Meeting ID',
            ),
            TextFieldWidget(
              controller: controller.meetingPasswordController,
              label: 'Password',
            ),
            ButtonWidget(
              onTap: () => controller.joinMeeting(context),
              label: 'Join',
            ),
            ButtonWidget(
              onTap: () => controller.startMeetingNormal(context),
              label: 'Start Meeting With Meeting ID',
            ),
          ],
        ),
      ),
    );
  }
}
