import 'package:flutter_zoom_example/meeting_controller.dart';
import 'package:get/get.dart';


class MeetingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeetingController());
  }
}
