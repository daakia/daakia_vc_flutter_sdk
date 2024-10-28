import 'dart:async';
import 'dart:convert';

import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../resources/colors/color.dart';
import '../../screens/bottomsheet/more_option_bottomsheet.dart';
import '../../utils/utils.dart';

class LivekitControls extends StatefulWidget{

  final Room room;
  final LocalParticipant participant;

  const LivekitControls(this.room,
      this.participant, {
        super.key,
      });

  @override
  State<StatefulWidget> createState() {
    return _LivekitControlState();
  }

}

class _LivekitControlState extends State<LivekitControls>{

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription? _subscription;

  bool _speakerphoneOn = Hardware.instance.preferSpeakerOutput;

  LocalParticipant get participant => widget.participant;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    setState(() {});
  }
  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _onTapSendData() async {
    final result = await context.showSendDataDialog();
    if (result == true) {
      await widget.participant.publishData(
        utf8.encode('{"action": "raise_hand"}'),
      );
    }
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(false);
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(true);
  }

  void _toggleCamera() async {
    final track = participant.videoTrackPublications.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }

  void _setSpeakerphoneOn() {
    _speakerphoneOn = !_speakerphoneOn;
    Hardware.instance.setSpeakerphoneOn(_speakerphoneOn);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparentMaskColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: Hardware.instance.canSwitchSpeakerphone
                ? _setSpeakerphoneOn
                : null,
            icon: Icon(
                _speakerphoneOn ? Icons.speaker_phone : Icons.phone_android),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              participant.isCameraEnabled() ? _disableVideo() : _enableVideo();
            },
            icon: Icon(
              participant.isCameraEnabled() ? Icons.videocam : Icons.videocam_off,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              participant.isMicrophoneEnabled() ? _disableAudio() : _enableAudio();
            },
            icon: Icon(
              participant.isMicrophoneEnabled() ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              _toggleCamera();
            },
            icon: const Icon(
              Icons.flip_camera_android,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
          // IconButton(
          //   onPressed: () {
          //     showMoreOptionBottomSheet();
          //   },
          //   icon: const Icon(
          //     Icons.more_horiz,
          //     color: Colors.white,
          //   ),
          //   iconSize: 30,
          // ),
          IconButton(
            onPressed: () {
              _onTapDisconnect();
              // if (Navigator.canPop(context)) {
              //   Navigator.pop(context);
              // } else {
              //   SystemNavigator.pop();
              // }
            },
            icon: const Icon(
              Icons.call_end,
              color: Colors.redAccent,
            ),
            iconSize: 30,
          )
        ],
      ),
    );
  }
  void showMoreOptionBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const MoreOptionBottomSheet();
        });
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }
}