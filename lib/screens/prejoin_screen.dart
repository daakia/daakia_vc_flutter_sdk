import 'dart:async';

import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/injection.dart';
import '../livekit/room.dart';
import '../resources/colors/color.dart';
import '../utils/utils.dart';

class PreJoinScreen extends StatefulWidget {
  PreJoinScreen({required this.meetingId, required this.secretKey, this.isHost = false, super.key});
  String meetingId;
  String secretKey;
  bool isHost;

  @override
  State<StatefulWidget> createState() {
    return _PreJoinState(meetingId: meetingId, secretKey: secretKey, isHost: isHost);
  }
}

class _PreJoinState extends State<PreJoinScreen> {
  _PreJoinState({required this.meetingId, required this.secretKey, this.isHost = false});
  String meetingId;
  String secretKey;
  bool isHost;

  bool isHostVerified = false;
  String hostToken = "";

  var name = "";

  var alertMessage = 'Please check your audio/video settings';
  var isRejected = false;

  var isLoading = false;
  var _enableAudio = false;
  var _enableVideo = false;

  //============== Livekit ===============
  StreamSubscription? _subscription;
  List<MediaDevice> _audioInputs = [];
  List<MediaDevice> _videoInputs = [];
  LocalVideoTrack? _videoTrack;
  MediaDevice? _selectedVideoDevice;
  MediaDevice? _selectedAudioDevice;
  final VideoParameters _selectedVideoParameters =
      VideoParametersPresets.h720_169;

  LocalAudioTrack? _audioTrack;

  @override
  void initState() {
    // getUser();
    checkPermission();
    _subscription =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
    super.initState();
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();

    if (_audioInputs.isNotEmpty) {
      if (_selectedAudioDevice == null) {
        _selectedAudioDevice = _audioInputs.first;
        Future.delayed(const Duration(milliseconds: 100), () async {
          await _changeLocalAudioTrack();
          setState(() {});
        });
      }
    }

    if (_videoInputs.isNotEmpty) {
      if (_selectedVideoDevice == null) {
        _selectedVideoDevice = _videoInputs.first;
        Future.delayed(const Duration(milliseconds: 100), () async {
          await _changeLocalVideoTrack();
          setState(() {});
        });
      }
    }
    setState(() {});
  }

  Future<void> _setEnableAudio(value) async {
    _enableAudio = value;
    if (!_enableAudio) {
      await _audioTrack?.stop();
      _audioTrack = null;
    } else {
      await _changeLocalAudioTrack();
    }
    setState(() {});
  }

  Future<void> _changeLocalAudioTrack() async {
    if (_audioTrack != null) {
      await _audioTrack!.stop();
      _audioTrack = null;
    }

    if (_selectedAudioDevice != null) {
      _audioTrack = await LocalAudioTrack.create(AudioCaptureOptions(
        deviceId: _selectedAudioDevice!.deviceId,
      ));
      if(_enableAudio) {
        await _audioTrack!.start();
      }
    }
  }

  Future<void> _setEnableVideo(value) async {
    _enableVideo = value;
    if (!_enableVideo) {
      await _videoTrack?.stop();
      _videoTrack = null;
    } else {
      await _changeLocalVideoTrack();
    }
    setState(() {});
  }

  Future<void> _changeLocalVideoTrack() async {
    if (_videoTrack != null) {
      await _videoTrack!.stop();
      _videoTrack = null;
    }

    if (_selectedVideoDevice != null) {
      _videoTrack =
          await LocalVideoTrack.createCameraTrack(CameraCaptureOptions(
        deviceId: _selectedVideoDevice!.deviceId,
        params: _selectedVideoParameters,
      ));
      if(_enableVideo) {
        await _videoTrack!.start();
      }
    }
  }

  void _actionBack(BuildContext context) async {
    await _setEnableVideo(false);
    await _setEnableAudio(false);
    Navigator.of(context).pop();
  }

  void joinMeeting(Function stopLoading) async {
    isLoading = true;

    var token = hostToken;
    Map<String, dynamic> body = {
      "meeting_uid": meetingId,
      "preferred_video_server_id": "ap1",
      "display_name": name
    };

    apiClient.getMeetingJoinDetail(token, body).then((response){
      if(response.success == 1){
        _join(context, stopLoading, livekitUrl: response.data?.livekitServerURL??"", livekitToken: response.data?.accessToken??"");
        if(response.data == null){
          Utils.showSnackBar(context, message: "Something went wrong!");
          return;
        }
        var it = response.data!;
        if (!isHost) {
          if (it.isRejected== true){
            isRejected = true;
            setState(() {
              alertMessage = response.message??"";
              Utils.showSnackBar(context, message: alertMessage);
              Navigator.of(context).pop();
            });
            return;
          }
          if (it.accessToken.toString().isEmpty || it.livekitServerURL.toString().isEmpty){
            meetingNotStarted(stopLoading);
            return;
          }
          if (it.participantCanJoin == true) {
            // isUserCanJoin = true TODO:: Need to work on lobby
            _join(context, stopLoading, livekitUrl: response.data?.livekitServerURL??"", livekitToken: response.data?.accessToken??"");
          }
        } else {
          if (it.accessToken.toString().isEmpty || it.livekitServerURL.toString().isEmpty){
            meetingNotStarted(stopLoading);
            return;
          }
          _join(context, stopLoading, livekitUrl: response.data?.livekitServerURL??"", livekitToken: response.data?.accessToken??"");
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
    await Future.delayed(Duration(seconds: 10));
    joinMeeting(stopLoading);
  }

  void verifyHost(String email, String pin, Function stopLoading) async {
    isLoading = true;

    Map<String, dynamic> body = {
      "email": email,
      "pin": pin,
      "meeting_id": meetingId
    };

    apiClient.verifyHostToken(body).then((response){
      if(response.success == 1){
        Utils.showSnackBar(context, message: response.message ?? "");
        isHostVerified = true;
        hostToken = response.data?.token??"";
        joinMeeting(stopLoading);
        Navigator.of(context).pop();
      } else {
        Utils.showSnackBar(context, message: response.message ?? "Invalid Pin");
      }
      setState(() {
        isLoading = false;
      });

      print("Api Value: ${response.message}");
    }).onError((handleError, stackStress) {
      setState(() {
        isLoading = false;
        stopLoading.call();
      });
      Utils.showSnackBar(context, message: "Something went wrong!");
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
          title: Text('Verify Email and PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress, // Email input only
                textInputAction: TextInputAction.next, // Move to next field
              ),
              TextField(
                controller: pinController,
                decoration: InputDecoration(
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String email = emailController.text;
                String pin = pinController.text;

                verifyHost(email, pin, stopLoading);

                // Close the dialog
                // Navigator.of(context).pop();
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void checkPermission() async {
    var status = await [Permission.camera, Permission.microphone].request();
  }


  _join(BuildContext context, Function stopLoading, {required String livekitUrl, required String livekitToken}) async {
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

      await room.prepareConnection(livekitUrl,livekitToken);

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

      await Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
      );
    } catch (error) {
      print('Could not connect $error');
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
                                    onPressed: () {
                                      setState(() {
                                        _enableVideo = !_enableVideo;
                                        _setEnableVideo(_enableVideo);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        _enableAudio ? Icons.mic : Icons.mic_off,
                                        color: Colors.white),
                                    iconSize: 30,
                                    onPressed: () {
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
                        horizontal: 20,
                        vertical:
                            10), // Equivalent to marginHorizontal="20dp" and marginTop="10dp"
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
                        if(name.isEmpty){
                          Utils.showSnackBar(context, message: "Please enter your name");
                          return;
                        }
                        startLoading();
                        if(isLoading){
                          return;
                        } else {
                          if(isHost && !isHostVerified) _showVerificationDialog(context, stopLoading);
                          else joinMeeting(stopLoading);
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
}
