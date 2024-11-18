import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/chat_bottomsheet.dart';
import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../resources/colors/color.dart';
import '../../screens/bottomsheet/more_option_bottomsheet.dart';
import '../../viewmodel/rtc_viewmodel.dart';

class RtcControls extends StatefulWidget {
  final Room room;
  final LocalParticipant participant;

  const RtcControls(
    this.room,
    this.participant, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _RtcControlState();
  }
}

class _RtcControlState extends State<RtcControls> {
  CameraPosition position = CameraPosition.front;

  bool _speakerphoneOn = Hardware.instance.preferSpeakerOutput;

  LocalParticipant get participant => widget.participant;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  void _loadDevices(List<MediaDevice> devices) async {
    if (mounted) {
      setState(() {});
    }
  }

  void _onChange() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get isMuted => participant.isMuted;

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
      if (kDebugMode) {
        print('could not restart track: $error');
      }
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
    final viewModel = Provider.of<RtcViewmodel>(context);
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
              _speakerphoneOn ? Icons.speaker_phone : Icons.phone_android,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              if(viewModel.isVideoPermissionEnable) {
                participant.isCameraEnabled()
                    ? viewModel.disableVideo()
                    : viewModel.enableVideo();
              }
            },
            icon: Icon(
              participant.isCameraEnabled()
                  ? Icons.videocam
                  : Icons.videocam_off,
              color: Colors.white.withOpacity(viewModel.getCameraAlpha()),
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              if(viewModel.isAudioPermissionEnable) {
                participant.isMicrophoneEnabled()
                    ? viewModel.disableAudio()
                    : viewModel.enableAudio();
              }
            },
            icon: Icon(
              participant.isMicrophoneEnabled() ? Icons.mic : Icons.mic_off,
              color: Colors.white.withOpacity(viewModel.getMicAlpha()),
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
              showMoreOptionBottomSheet();
            },
            icon: Badge(
              isLabelVisible: viewModel.getUnReadCount() > 0,
              label: Text(
                viewModel.getUnReadCount().toString(),
                style: const TextStyle(color: Colors.white),
              ),
              offset: const Offset(8, 8),
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
            iconSize: 30,
          ),
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

  void showChatBottomSheet() {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return const ChatBottomSheet();
        },
        fullscreenDialog: true));
  }

  void _onTapDisconnect() async {
    if (!mounted) return;
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  @override
  void dispose() {
    participant.removeListener(_onChange);
    super.dispose();
  }
}
