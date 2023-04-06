import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_zoom/zoom_options.dart';
import 'package:flutter_zoom/zoom_view.dart';

class MeetingController extends GetxController {
// set force debug mode for pint()
  bool forceDebugMode = true;

// for view
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

//for feature
  late Timer timer;
  ZoomOptions zoomOptions = ZoomOptions(
    domain: "zoom.us",
    appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM -- SDK KEY
    appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM -- SDK SECRET
  );

// for value
  String zoomAccessTokenZAK =
      'eyJ0eXAiOiJKV1QiLCJzdiI6IjAwMDAwMSIsInptX3NrbSI6InptX28ybSIsImFsZyI6IkhTMjU2In0.eyJhdWQiOiJjbGllbnRzbSIsInVpZCI6InVvTlNtOEVNUjgtMWV5TDlaMk5Td3ciLCJpc3MiOiJ3ZWIiLCJzayI6IjAiLCJzdHkiOjEwMCwid2NkIjoiYXcxIiwiY2x0IjowLCJleHAiOjE2NzExMTE0NDMsImlhdCI6MTY3MTEwNDI0MywiYWlkIjoiZkxXTUtmdVRRSGFlSkl3Mml2SWdkZyIsImNpZCI6IiJ9.lctRrzvEv-0TT8nB2khUqMxCZvQV3CRE9Lq1aaXnswc';
  String userId = "";

  /// Username For Join Meeting & Host Email For Start Meeting
  String userPassword = "";

  /// Host Password For Start Meeting
  String displayName = "";

  /// Display Name
  String meetingId = "";

  /// Personal meeting id for start meeting required
  String meetingPassword = "";

  /// Disable No Audio
  String zoomToken = "";

  /// Zoom token for SDK
  String zoomAccessToken = "";

  ///To Hide Meeting Invite Url
  @override
  void onReady() {
    super.onReady();
    meetingIdController.text = "";
    meetingPasswordController.text = "";
  }

  /// Join meeting with meeting id

  joinMeeting(BuildContext context) {
    if (meetingIdController.text.isNotEmpty && meetingPasswordController.text.isNotEmpty) {
      var meetingOptions = ZoomMeetingOptions(
        userId: userId,
        meetingId: meetingId.isNotEmpty ? meetingId : meetingIdController.text,
        meetingPassword: meetingPassword.isNotEmpty ? meetingPassword : meetingPasswordController.text,
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        disableTitleBar: "false",
        viewOptions: "true",
        noAudio: "false",
        noDisconnectAudio: "false",
        meetingViewOptions: ZoomMeetingOptions.NO_TEXT_PASSWORD +
            ZoomMeetingOptions.NO_TEXT_MEETING_ID +
            ZoomMeetingOptions.NO_BUTTON_PARTICIPANTS,
      );

      var zoom = ZoomView();

      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            if (kDebugMode || forceDebugMode) {
              print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            }
            if (_isMeetingEnded(status[0])) {
              if (kDebugMode || forceDebugMode) {
                print("[Meeting Status] :- Ended");
              }
              timer.cancel();
            }
          });
          if (kDebugMode || forceDebugMode) {
            print("listen on event channel");
          }
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(const Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                if (kDebugMode || forceDebugMode) {
                  print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
                }
              });
            });
          });
        }
      }).catchError((error) {
        if (kDebugMode || forceDebugMode) {
          print("[Error Generated] : " + error.toString());
        }
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  /// Start Meeting With Custom Meeting ID and ZAK token
  startMeetingNormal(BuildContext context) {
    var meetingOptions = ZoomMeetingOptions(
      userId: userId,
      userPassword: userPassword,
      meetingId: meetingId.isNotEmpty ? meetingId : meetingIdController.text,
      disableDialIn: "false",
      disableDrive: "false",
      disableInvite: "false",
      disableShare: "false",
      disableTitleBar: "false",
      viewOptions: "false",
      noAudio: "false",
      noDisconnectAudio: "false",
    );

    var zoom = ZoomView();

    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          if (kDebugMode || forceDebugMode) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          }
          if (_isMeetingEnded(status[0])) {
            if (kDebugMode || forceDebugMode) {
              print("[Meeting Status] :- Ended");
            }
            timer.cancel();
          }
          if (status[0] == "MEETING_STATUS_INMEETING") {
            zoom.meetingDetails().then((meetingDetailsResult) {
              if (kDebugMode || forceDebugMode) {
                print("[MeetingDetailsResult] :- " + meetingDetailsResult.toString());
              }
            });
          }
        });
        zoom.startMeetingNormal(meetingOptions).then((loginResult) {
          if (kDebugMode || forceDebugMode) {
            print("[LoginResult] :- " + loginResult.toString());
          }
          if (loginResult[0] == "SDK ERROR") {
            //SDK INIT FAILED
            if (kDebugMode || forceDebugMode) {
              print((loginResult[1]).toString());
            }
          } else if (loginResult[0] == "LOGIN ERROR") {
            //LOGIN FAILED - WITH ERROR CODES
            if (kDebugMode || forceDebugMode) {
              print((loginResult[1]).toString());
            }
          } else {
            //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
            if (kDebugMode || forceDebugMode) {
              print((loginResult[0]).toString());
            }
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode || forceDebugMode) {
        print("[Error Generated] : " + error);
      }
    });
  }

  /// get [bool] meeting status is ended
  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    } else {
      result = status == "MEETING_STATUS_IDLE";
    }

    return result;
  }
}
