import 'dart:async';
import 'package:daakia_vc_flutter_sdk/model/features.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details_model.dart';
import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/injection.dart';
import '../resources/colors/color.dart';
import '../rtc/room.dart';
import '../utils/utils.dart';

@protected
class PreJoinScreen extends StatefulWidget {
  const PreJoinScreen(
      {required this.meetingId,
      required this.secretKey,
      this.isHost = false,
        required this.basicMeetingDetails,
      super.key});

  final String meetingId;
  final String secretKey;
  final bool isHost;
  final MeetingDetailsModel? basicMeetingDetails;

  @override
  State<StatefulWidget> createState() {
    return _PreJoinState();
  }
}

class _PreJoinState extends State<PreJoinScreen> {
  bool isHostVerified = false;
  String hostToken = "";

  late MeetingDetails meetingDetails;

  var name = "";
  var email = "";
  var password = "";

  var _obscurePassword = true;

  var alertMessage = 'Please check your audio/video settings';
  var isRejected = false;

  var isLoading = false;
  var _enableAudio = false;
  var _enableVideo = false;

  //============== RTC ===============
  StreamSubscription? _subscription;
  List<MediaDevice> _audioInputs = [];
  List<MediaDevice> _videoInputs = [];
  LocalVideoTrack? _videoTrack;
  MediaDevice? _selectedVideoDevice;
  MediaDevice? _selectedAudioDevice;
  final VideoParameters _selectedVideoParameters =
      VideoParametersPresets.h720_169;

  LocalAudioTrack? _audioTrack;

  Features? features;

  @override
  void initState() {
    checkPermission();
    _subscription =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
    super.initState();
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();

    if (_audioInputs.isNotEmpty && _selectedAudioDevice == null) {
      _selectedAudioDevice = _audioInputs.first;
    }

    if (_videoInputs.isNotEmpty && _selectedVideoDevice == null) {
      // Try to find a front camera, otherwise default to the first available
      _selectedVideoDevice = _videoInputs.firstWhere(
        (device) => device.label.toLowerCase().contains('front'),
        orElse: () => _videoInputs.first,
      );
    }

    setState(() {}); // Update the UI with selected devices
  }

  Future<void> _setEnableAudio(bool value) async {
    _enableAudio = value;
    if (_enableAudio) {
      await _changeLocalAudioTrack();
    } else {
      await _audioTrack?.stop();
      _audioTrack = null;
    }
    setState(() {});
  }

  Future<void> _changeLocalAudioTrack() async {
    if (_audioTrack != null) {
      await _audioTrack!.stop();
      _audioTrack = null;
    }

    if (_enableAudio && _selectedAudioDevice != null) {
      _audioTrack = await LocalAudioTrack.create(AudioCaptureOptions(
        deviceId: _selectedAudioDevice!.deviceId,
      ));
      await _audioTrack!.start();
    }
  }

  Future<void> _setEnableVideo(bool value) async {
    _enableVideo = value;
    if (_enableVideo) {
      await _changeLocalVideoTrack();
    } else {
      await _videoTrack?.stop();
      _videoTrack = null;
    }
    setState(() {});
  }

  Future<void> _changeLocalVideoTrack() async {
    if (_videoTrack != null) {
      await _videoTrack!.stop();
      _videoTrack = null;
    }

    if (_enableVideo && _selectedVideoDevice != null) {
      _videoTrack =
          await LocalVideoTrack.createCameraTrack(CameraCaptureOptions(
        deviceId: _selectedVideoDevice!.deviceId,
        params: _selectedVideoParameters,
      ));
      await _videoTrack!.start();
    }
  }

  String lobbyRequestId = "";
  bool isUserCanJoin = false;

  void joinMeeting(Function stopLoading, {bool isParticipant = false}) async {
    isLoading = true;

    var token = hostToken;
    Map<String, dynamic> body = {
      "meeting_uid": widget.meetingId,
      "preferred_video_server_id": "ap1",
      "display_name": name
    };
    if(isParticipant){
      body["lobby_request_id"] = lobbyRequestId;
    }

    apiClient.getMeetingJoinDetail(token, body).then((response) {
      if (response.success == 1) {
        if (response.data == null) {
          Utils.showSnackBar(context, message: "Something went wrong!");
          return;
        }
        var it = response.data!;
        if (!widget.isHost) {
          if (it.accessToken == null ||
              it.livekitServerURL == null ||
              it.accessToken?.isEmpty == true ||
              it.livekitServerURL?.isEmpty == true) {
            setState(() {
              alertMessage = response.message ?? "";
            });
            meetingNotStarted(stopLoading);
            return;
          }

          if (it.isRejected == true) {
            isRejected = true;
            setState(() {
              alertMessage = response.message ?? "";
              Utils.showSnackBar(context, message: alertMessage);
              Navigator.of(context).pop();
            });
            return;
          }
          if (it.participantCanJoin == true) {
            isUserCanJoin = true;
            _join(context, stopLoading,
                livekitUrl: response.data?.livekitServerURL ?? "",
                livekitToken: response.data?.accessToken ?? "");
          }
        } else {
          if (it.accessToken == null ||
              it.livekitServerURL == null ||
              it.accessToken?.isEmpty == true ||
              it.livekitServerURL?.isEmpty == true) {
            setState(() {
              alertMessage = response.message ?? "";
            });
            meetingNotStarted(stopLoading);
            return;
          }
          _join(context, stopLoading,
              livekitUrl: response.data?.livekitServerURL ?? "",
              livekitToken: response.data?.accessToken ?? "");
        }
      }
    }).onError((handleError, stackStress) {
      setState(() {
        isLoading = false;
        stopLoading.call();
      });
      Utils.showSnackBar(context, message: "Something went wrong!");
    });
  }

  Future<void> meetingNotStarted(Function stopLoading) async {
    await Future.delayed(const Duration(seconds: 10));
    joinMeeting(stopLoading);
  }

  void verifyHost(String email, String pin, Function stopLoading) async {
    isLoading = true;

    Map<String, dynamic> body = {
      "email": email,
      "pin": pin,
      "meeting_id": widget.meetingId
    };

    apiClient.verifyHostToken(body).then((response) {
      if (response.success == 1) {
        Utils.showSnackBar(context, message: response.message ?? "");
        isHostVerified = true;
        hostToken = response.data?.token ?? "";
        getFeaturesAndJoinMeeting(stopLoading);
        Navigator.of(context).pop();
      } else {
        Utils.showSnackBar(context, message: response.message ?? "Invalid Pin");
      }
      setState(() {
        isLoading = false;
      });
    }).onError((handleError, stackStress) {
      setState(() {
        isLoading = false;
        stopLoading.call();
      });
      Utils.showSnackBar(context, message: "Something went wrong!");
    });
  }

  void addParticipantToLobby(Function stopLoading){
    Map<String, dynamic> body = {
      "meeting_uid": widget.meetingId,
      "display_name": name,
    };

    apiClient.addParticipantToLobby(body).then((response){
      if(response.success == 1){
        lobbyRequestId = response.data?.requestId ?? "";
        Future.delayed(const Duration(seconds: 10), () {
          joinMeeting(stopLoading, isParticipant: true);
        });
      } else {
        Utils.showSnackBar(context, message: response.message ?? "Something went wrong!");
        stopLoading();
      }
    });
  }

  Timer? _participantTimer;
  void startAddingParticipantsPool(Function stopLoading) {
    int iterations = 0;

    _participantTimer?.cancel(); // Cancel any previous timer if exists

    // Set up a timer to repeat every 10 seconds
    _participantTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (isUserCanJoin || isRejected || iterations >= 50) {
        // Stop the timer if the user can join, has been rejected, or after 2 minutes
        stopLoading();
        timer.cancel();
        return;
      }

      // Call the function to add a participant to the lobby
      addParticipantToLobby(stopLoading);

      iterations++; // Track the number of iterations
    });
  }

  void _showVerificationDialog(BuildContext context, Function stopLoading) {
    final emailController = TextEditingController();
    final pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify Email and PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress, // Email input only
                textInputAction: TextInputAction.next, // Move to next field
              ),
              TextField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  hintText: 'Enter your PIN',
                ),
                keyboardType: TextInputType.number,
                obscureText: true, // Hide the PIN input
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                stopLoading.call();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String email = emailController.text;
                String pin = pinController.text;

                verifyHost(email, pin, stopLoading);

                // Close the dialog
                // Navigator.of(context).pop();
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void checkPermission() async {
    await [Permission.camera, Permission.microphone, Permission.notification].request();
  }

  _join(BuildContext context, Function stopLoading,
      {required String livekitUrl, required String livekitToken}) async {
    isLoading = true;

    setState(() {});

    // var args = widget.args;

    try {
      //create new room
      var cameraEncoding = const VideoEncoding(
        maxBitrate: 5 * 1000 * 1000,
        maxFramerate: 30,
      );

      var screenEncoding = const VideoEncoding(
        maxBitrate: 3 * 1000 * 1000,
        maxFramerate: 15,
      );

      // E2EEOptions? e2eeOptions;
      // if (args.e2ee && args.e2eeKey != null) {
      //   final keyProvider = await BaseKeyProvider.create();
      //   e2eeOptions = E2EEOptions(keyProvider: keyProvider);
      //   await keyProvider.setKey(args.e2eeKey!);
      // }

      final room = Room(
        roomOptions: RoomOptions(
          adaptiveStream: false,
          dynacast: false,
          defaultAudioPublishOptions: const AudioPublishOptions(
            name: 'custom_audio_track_name',
          ),
          defaultCameraCaptureOptions: const CameraCaptureOptions(
              maxFrameRate: 30,
              params: VideoParameters(
                dimensions: VideoDimensions(1280, 720),
              )),
          defaultScreenShareCaptureOptions: const ScreenShareCaptureOptions(
              useiOSBroadcastExtension: true,
              params: VideoParameters(
                dimensions: VideoDimensionsPresets.h1080_169,
              )),
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: false,
            videoEncoding: cameraEncoding,
            screenShareEncoding: screenEncoding,
          ),
        ),
      );
      // Create a Listener before connecting
      final listener = room.createListener();

      await room.prepareConnection(livekitUrl, livekitToken);

      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        livekitUrl,
        livekitToken,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(track: _audioTrack),
          camera: TrackOption(track: _videoTrack),
        ),
      );

      meetingDetails = MeetingDetails(
          meeting_uid: widget.meetingId,
          authorization_token: hostToken,
          features: features);

      await Navigator.push<void>(
        context,
        MaterialPageRoute(
            builder: (_) => RoomPage(room, listener, meetingDetails)),
      );
    } catch (error) {
      if (kDebugMode) {
        print('Could not connect $error');
      }
      await context.showErrorDialog(error);
    } finally {
      setState(() {
        stopLoading();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prejoin Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeColor,
        elevation: 3,
        shadowColor: Colors.grey,
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Set the color you want for the back button here
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: emptyVideoColor,
                    elevation: 5,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: Utils.isMobileDevice() ? 250 : 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _videoTrack != null && _enableVideo
                              ? Visibility(
                                  visible: _enableVideo,
                                  child: VideoTrackRenderer(
                                    renderMode: VideoRenderMode.auto,
                                    _videoTrack!,
                                  ),
                                )
                              : Visibility(
                                  visible: !_enableVideo,
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam_off,
                                        size: 55,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Your Camera is turned off',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: transparentMaskColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                        _enableVideo
                                            ? Icons.videocam
                                            : Icons.videocam_off,
                                        color: Colors.white),
                                    iconSize: 30,
                                    onPressed: () async {
                                      bool permissionsGranted =
                                          await checkAndRequestPermissions(
                                              context,
                                              checkForAudio: false);
                                      if (!permissionsGranted) return;
                                      setState(() {
                                        _enableVideo = !_enableVideo;
                                        _setEnableVideo(_enableVideo);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        _enableAudio
                                            ? Icons.mic
                                            : Icons.mic_off,
                                        color: Colors.white),
                                    iconSize: 30,
                                    onPressed: () async {
                                      bool permissionsGranted =
                                          await checkAndRequestPermissions(
                                              context,
                                              checkForCamera: false);
                                      if (!permissionsGranted) return;
                                      setState(() {
                                        _enableAudio = !_enableAudio;
                                        _setEnableAudio(_enableAudio);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      alertMessage,
                      textAlign:
                          TextAlign.center, // Equivalent to gravity="center"
                      style: const TextStyle(
                        color: Colors
                            .black, // Equivalent to textColor="@color/black"
                        fontSize: 15, // Equivalent to textSize="15sp"
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    // Equivalent to marginHorizontal="20dp" and marginTop="10dp"
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name*', // Equivalent to hint="Name*"
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        color: Colors
                            .black, // Equivalent to textColor="@color/black"
                      ),
                      enabled: true, // Equivalent to android:enabled="false"
                      onChanged: (String? value) {
                        setState(() {
                          name = value ?? "";
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: !widget.isHost && (widget.basicMeetingDetails?.isStandardPassword == true),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      // Equivalent to marginHorizontal="20dp" and marginTop="10dp"
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email*', // Equivalent to hint="Name*"
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          color: Colors
                              .black, // Equivalent to textColor="@color/black"
                        ),
                        enabled: true, // Equivalent to android:enabled="false"
                        onChanged: (String? value) {
                          setState(() {
                            email = value ?? "";
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !widget.isHost && (widget.basicMeetingDetails?.isCommonPassword == true || widget.basicMeetingDetails?.isStandardPassword == true),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password*',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors
                              .black,
                        ),
                        enabled: true,
                        obscureText: _obscurePassword,
                        onChanged: (String? value) {
                          setState(() {
                            password = value ?? "";
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoadingBtn(
                    height: 50,
                    borderRadius: 8,
                    animate: true,
                    color: themeColor,
                    width: MediaQuery.of(context).size.width * 0.45,
                    loader: Container(
                      padding: const EdgeInsets.all(10),
                      width: 40,
                      height: 40,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    child: const Text(
                      "Join Meeting",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (btnState == ButtonState.idle) {
                        if (name.isEmpty) {
                          Utils.showSnackBar(context,
                              message: "Please enter your name");
                          return;
                        }
                        if(!widget.isHost) {
                          var event = widget.basicMeetingDetails;
                          if(event?.isStandardPassword == true){
                            if(!checkValidity()){
                              return;
                            }
                          }
                          if(event?.isCommonPassword == true){
                            if(password.isEmpty) {
                              Utils.showSnackBar(context, message: "Please enter your password");
                              return;
                            }
                          }
                        }
                        // Check and request permissions
                        startLoading();
                        if (isLoading) {
                          return;
                        } else {
                          if (widget.isHost && !isHostVerified) {
                            _showVerificationDialog(context, stopLoading);
                          } else {
                            checkMeetingType(stopLoading);
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _subscription?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void getFeaturesAndJoinMeeting(Function stopLoading) {
    isLoading = true;
    apiClient.getFeatures(widget.meetingId).then((response) {
      if (response.success == 1) {
        features = response.data?.features;
        joinMeeting(stopLoading);
      } else {
        setState(() {
          isLoading = false;
          stopLoading.call();
        });
        Utils.showSnackBar(context,
            message: response.message ?? "Something went wrong!");
      }
    }).onError((handleError, stackStress) {
      setState(() {
        isLoading = false;
        stopLoading.call();
      });
      Utils.showSnackBar(context, message: "Something went wrong!");
    });
  }

  Future<bool> checkAndRequestPermissions(BuildContext context,
      {bool checkForCamera = true, bool checkForAudio = true}) async {
    // Check and request microphone permission
    if (checkForAudio) {
      if (await Permission.microphone.isDenied) {
        // Request permission
        PermissionStatus micStatus = await Permission.microphone.request();
        if (micStatus.isDenied) {
          _showPermissionDialog(context, "Microphone");
          return false;
        } else if (micStatus.isPermanentlyDenied) {
          _showSettingsDialog(context, "Microphone");
          return false;
        }
      }
    }

    if (checkForCamera) {
      // Check and request camera permission
      if (await Permission.camera.isDenied) {
        // Request permission
        PermissionStatus cameraStatus = await Permission.camera.request();
        if (cameraStatus.isDenied) {
          _showPermissionDialog(context, "Camera");
          return false;
        } else if (cameraStatus.isPermanentlyDenied) {
          _showSettingsDialog(context, "Camera");
          return false;
        }
      }
    }

    // Return true if both permissions are granted
    return true;
  }

// Show dialog if permission is temporarily denied
  void _showPermissionDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$permissionType Permission Required"),
          content: Text(
              "Please allow $permissionType permission to join the meeting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

// Show dialog with a link to app settings if permission is permanently denied
  void _showSettingsDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$permissionType Permission Required"),
          content: Text(
              "$permissionType permission is permanently denied. Please enable it from the app settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open the app settings
                Navigator.of(context).pop();
              },
              child: const Text("Settings"),
            ),
          ],
        );
      },
    );
  }

  void checkMeetingType(Function stopLoading) {
    var event = widget.basicMeetingDetails;
    if(widget.isHost){
      getFeaturesAndJoinMeeting(stopLoading);
    } else if(event?.isStandardPassword ==  true){
      if(checkValidity()){
        verifyPasswordProtectedMeeting(stopLoading);
      } else{
        stopLoading();
      }
    } else if(event?.isCommonPassword == true){
      if (password.isEmpty) {
        Utils.showSnackBar(context, message: "Please enter your password");
        stopLoading();
        return;
      }
      verifyCommonPasswordProtectedMeeting(stopLoading);
    } else {
      if(event?.isLobbyMode == true){
        startAddingParticipantsPool(stopLoading);
      } else {
        getFeaturesAndJoinMeeting(stopLoading);
      }
    }
  }

  bool checkValidity(){
    var isValid = false;
    if(email.isNotEmpty) {
      if (Utils.isValidEmail(email)){
        isValid = true;
      } else {
        Utils.showSnackBar(context, message: "Invalid email");
        return false;
      }
    } else {
      Utils.showSnackBar(context, message: "Please enter your email");
      return false;
    }
    if (password.isEmpty) {
      Utils.showSnackBar(context, message: "Please enter your password");
      return false;
    } else {
      isValid = true;
    }
    return isValid;
  }

  void verifyCommonPasswordProtectedMeeting(Function stopLoading) {
    Map<String, dynamic> body = {
      "password": password,
      "meeting_uid": widget.meetingId
    };
    apiClient.verifyCommonMeetingPassword(body).then((response){
      if(response.success == 1){
        if(response.data?.passwordVerified == true){
          passwordVerified(stopLoading);
        } else {
          passwordNotVerified(stopLoading, message: "Not verified");
        }
      } else {
        passwordNotVerified(stopLoading, message: response.message ?? "Something went wrong!");
      }
    }).onError((_,__){
      passwordNotVerified(stopLoading);
    });
  }

  void verifyPasswordProtectedMeeting(Function stopLoading) {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "meeting_uid": widget.meetingId
    };
    apiClient.verifyMeetingPassword(body).then((response){
      if(response.success == 1){
        if(response.data?.passwordVerified == true){
          passwordVerified(stopLoading);
        } else {
          passwordNotVerified(stopLoading, message: "Not verified");
        }
      } else {
        passwordNotVerified(stopLoading, message: response.message ?? "Something went wrong!");
      }
    }).onError((_,__){
      passwordNotVerified(stopLoading);
    });
  }

  void passwordNotVerified(Function stopLoading, {String message = "Something went wrong!"}){
    stopLoading();
    Utils.showSnackBar(context, message: message);
  }

  void passwordVerified(Function stopLoading) {
    if(widget.basicMeetingDetails?.isLobbyMode == true){
      startAddingParticipantsPool(stopLoading);
    } else {
      getFeaturesAndJoinMeeting(stopLoading);
    }
  }
}
