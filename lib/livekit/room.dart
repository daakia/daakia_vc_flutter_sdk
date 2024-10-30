import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:daakia_vc_flutter_sdk/livekit/widgets/livekit_controls.dart';
import 'package:daakia_vc_flutter_sdk/livekit/widgets/participant.dart';
import 'package:daakia_vc_flutter_sdk/livekit/widgets/participant_info.dart';
import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/livekit_provider.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../model/remote_activity_data.dart';
import '../utils/utils.dart';
import 'method_channels/replay_kit_channel.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  final EventsListener<RoomEvent> listener;

  const RoomPage(
    this.room,
    this.listener, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<ParticipantTrack> participantTracks = [];
  EventsListener<RoomEvent> get _listener => widget.listener;
  bool get fastConnection => widget.room.engine.fastConnectOptions != null;
  bool _flagStartedReplayKit = false;
  @override
  void initState() {
    super.initState();
    // add callback for a `RoomEvent` as opposed to a `ParticipantEvent`
    widget.room.addListener(_onRoomDidUpdate);
    // add callbacks for finer grained events
    _setUpListeners();
    _sortParticipants();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
      if (!fastConnection) {
        _askPublish();
      }
    });

    if (lkPlatformIs(PlatformType.android)) {
      Hardware.instance.setSpeakerphoneOn(true);
    }

    if (lkPlatformIs(PlatformType.iOS)) {
      ReplayKitChannel.listenMethodChannel(widget.room);
    }

    if (lkPlatformIsDesktop()) {
      onWindowShouldClose = () async {
        unawaited(widget.room.disconnect());
        await _listener.waitFor<RoomDisconnectedEvent>(
            duration: const Duration(seconds: 5));
      };
    }
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {
      if (lkPlatformIs(PlatformType.iOS)) {
        ReplayKitChannel.closeReplayKit();
      }
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room.dispose();
    })();
    onWindowShouldClose = null;
    super.dispose();
  }

  /// for more information, see [event types](https://docs.livekit.io/client/events/#events)
  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        print('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback(
          (timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
    })
    ..on<ParticipantEvent>((event) {
      print('Participant event');
      // sort participants on many track events as noted in documentation linked above
      _sortParticipants();
    })
    ..on<ParticipantConnectedEvent> ((event){
      _sortParticipants();
    })
    ..on<ParticipantDisconnectedEvent> ((event){
      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      context.showRecordingStatusChangedDialog(event.activeRecording);
    })
    ..on<RoomAttemptReconnectEvent>((event) {
      print(
          'Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
    })
    ..on<LocalTrackSubscribedEvent>((event) {
      print('Local track subscribed: ${event.trackSid}');
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<TrackE2EEStateEvent>(_onE2EEStateEvent)
    ..on<ParticipantNameUpdatedEvent>((event) {
      print(
          'Participant name updated: ${event.participant.identity}, name => ${event.name}');
      _sortParticipants();
    })
    ..on<ParticipantMetadataUpdatedEvent>((event) {
      print(
          'Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}');
    })
    ..on<RoomMetadataChangedEvent>((event) {
      print('Room metadata changed: ${event.metadata}');
    })
    ..on<DataReceivedEvent>((event) {
      // String decoded = 'Failed to decode';
      // try {
      //   decoded = utf8.decode(event.data);
      // } catch (err) {
      //   print('Failed to decode: $err');
      // }
      // context.showDataReceivedDialog(decoded);
      _handleDataChannel(event);
    })
    ..on<AudioPlaybackStatusChanged>((event) async {
      if (!widget.room.canPlaybackAudio) {
        print('Audio playback failed for iOS Safari ..........');
        bool? yesno = await context.showPlayAudioManuallyDialog();
        if (yesno == true) {
          await widget.room.startAudio();
        }
      }
    });

  void _handleDataChannel(DataReceivedEvent event){
    var identity = event.participant?.identity ?? "server";
    var message = utf8.decode(event.data);
    var _eventData = parseJsonData(event.data);
    var eventData = _eventData.copyWith(identity: event.participant);
    _checkReceivedDataType(eventData);
  }

  void _checkReceivedDataType(RemoteActivityData remoteData) {
    var viewmodel = _livekitProviderKey.currentState?.viewModel;
    switch (remoteData.action) {
      // case "raise_hand":
      //   showSnackBar("${remoteData.identity?.name ?? ''} raised hand");
      //   break;
      //
      // case "stop_raise_hand":
      // // Handle stop raise hand action if needed
      //   break;

      // case "send_private_message":
      // // Handle send private message action if needed
      //   break;
      //
      // case "lobby":
      //   showLobbyRequest(remoteData);
      //   break;
      //
      // case "heart":
      // case "blush":
      // case "clap":
      // case "smile":
      // case "thumbsUp":
      //   showSnackBar("${remoteData.identity?.name ?? ''} sent a reaction");
      //   showReaction(remoteData.action);
      //   break;
      //
      // case "mute_camera":
      //
      //   viewModel.setCameraEnabled(false);
      //   break;
      //
      // case "mute_mic":
      //   viewModel.setMicEnabled(false);
      //   break;
      //
      // case "ask_to_unmute_mic":
      //   showSnackBar("Host is asking you to turn on your mic", actionLabel: "Accept", onAction: () {
      //     viewModel.setMicEnabled(true);
      //   });
      //   break;

      // case "ask_to_unmute_camera":
      //   showSnackBar("Host is asking you to turn on your camera", actionLabel: "Accept", onAction: () {
      //     viewModel.setCameraEnabled(true);
      //   });
      //   break;

      // case "makeCoHost":
      //   debugPrint("isCoHost: ${viewModel.checkCoHostPermission()}");
      //   debugPrint("metadata: ${viewModel.room.localParticipant.metadata}");
      //   if (viewModel.checkCoHostPermission()) {
      //     viewModel.isCoHost = true;
      //     viewModel.hostToken = remoteData.token ?? "";
      //   } else {
      //     viewModel.isCoHost = false;
      //   }
      //   break;

      // case "force_mute_all":
      //   viewModel.isAudioPermissionEnable = !remoteData.value;
      //   if (!viewModel.isAudioPermissionEnable) {
      //     viewModel.setMicEnabled(false);
      //     setMicAlpha(0.8);
      //   } else {
      //     setMicAlpha(1.0);
      //   }
      //   break;

      // case "force_video_off_all":
      //   viewModel.isVideoPermissionEnable = !remoteData.value;
      //   if (!viewModel.isVideoPermissionEnable) {
      //     viewModel.setCameraEnabled(false);
      //     setCameraAlpha(0.8);
      //   } else {
      //     setCameraAlpha(1.0);
      //   }
      //   break;

      case "":
      // Handle empty action case if needed
        break;

      default:
      // Handle null or unknown action
        viewmodel?.addMessage(remoteData);
        Utils.showSnackBar(context, message: "${remoteData.identity?.name ?? ''} sent a message");
    }
  }

  RemoteActivityData parseJsonData(List<int> jsonData) {
    final jsonString = utf8.decode(jsonData); // Convert Uint8List to String
    final Map<String, dynamic> jsonMap = json.decode(jsonString); // Decode the JSON string
    return RemoteActivityData.fromJson(jsonMap); // Convert to RemoteActivityData
  }

  void _askPublish() async {
    final result = await context.showPublishDialog();
    if (result != true) return;
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      print('could not publish video: $error');
      await context.showErrorDialog(error);
    }
    try {
      await widget.room.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      print('could not publish audio: $error');
      await context.showErrorDialog(error);
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
    print('e2ee state: $e2eeState');
  }

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    for (var participant in widget.room.remoteParticipants.values) {
      for (var t in participant.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: participant,
            type: ParticipantTrackType.kScreenShare,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(participant: participant));
        }
      }
    }
    // sort speakers for the grid
    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipantTracks =
        widget.room.localParticipant?.videoTrackPublications;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        if (t.isScreenShare) {
          if (lkPlatformIs(PlatformType.iOS)) {
            if (!_flagStartedReplayKit) {
              _flagStartedReplayKit = true;

              ReplayKitChannel.startReplayKit();
            }
          }
          screenTracks.add(ParticipantTrack(
            participant: widget.room.localParticipant!,
            type: ParticipantTrackType.kScreenShare,
          ));
        } else {
          if (lkPlatformIs(PlatformType.iOS)) {
            if (_flagStartedReplayKit) {
              _flagStartedReplayKit = false;

              ReplayKitChannel.closeReplayKit();
            }
          }

          userMediaTracks.add(
              ParticipantTrack(participant: widget.room.localParticipant!));
        }
      }
    }
    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }
  final GlobalKey<LivekitProviderState> _livekitProviderKey = GlobalKey<LivekitProviderState>();

  @override
  Widget build(BuildContext context) {
    return LivekitProvider(
      key: _livekitProviderKey,
      room: widget.room,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: participantTracks.isNotEmpty
                            ? ParticipantWidget.widgetFor(
                            participantTracks.first,
                            showStatsLayer: true)
                            : Container()),
                    if (widget.room.localParticipant != null)
                      SafeArea(
                        top: false,
                        child: LivekitControls(
                            widget.room, widget.room.localParticipant!),
                      )
                  ],
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: math.max(0, participantTracks.length - 1),
                        itemBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              width: 180,
                              height: 120,
                              child: ParticipantWidget.widgetFor(
                                  participantTracks[index + 1]),
                            ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
