import 'dart:async';
import 'dart:convert';

import 'package:daakia_vc_flutter_sdk/livekit/widgets/livekit_controls.dart';
import 'package:daakia_vc_flutter_sdk/livekit/widgets/participant.dart';
import 'package:daakia_vc_flutter_sdk/livekit/widgets/participant_info.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details.dart';
import 'package:daakia_vc_flutter_sdk/utils/exts.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/livekit_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../model/remote_activity_data.dart';
import '../utils/utils.dart';
import 'method_channels/replay_kit_channel.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  final EventsListener<RoomEvent> listener;
  final MeetingDetails meetingDetails;

  const RoomPage(
    this.room,
    this.listener,
    this.meetingDetails, {
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
        switch (event.reason) {
          case DisconnectReason.participantRemoved:
            {
              showSnackBar(message: "Host has removed you from the meeting!");
              Timer(const Duration(seconds: 3), () {
                WidgetsBindingCompatible.instance?.addPostFrameCallback(
                    (timeStamp) =>
                        Navigator.popUntil(context, (route) => route.isFirst));
              });
              break;
            }
          case DisconnectReason.duplicateIdentity:
            {
              showSnackBar(message: "You have joined with another device");
              Timer(const Duration(seconds: 3), () {
                WidgetsBindingCompatible.instance?.addPostFrameCallback(
                    (timeStamp) =>
                        Navigator.popUntil(context, (route) => route.isFirst));
              });
              break;
            }
          default:
            {
              Timer(const Duration(seconds: 3), () {
                WidgetsBindingCompatible.instance?.addPostFrameCallback(
                    (timeStamp) =>
                        Navigator.popUntil(context, (route) => route.isFirst));
              });
            }
        }
      }
    })
    ..on<ParticipantConnectedEvent>((event) {
      var viewModel = _livekitProviderKey.currentState?.viewModel;
      viewModel?.setRecording(widget.room.isRecording);
      _sortParticipants();
    })
    ..on<ParticipantEvent>((event) {
      var viewModel = _livekitProviderKey.currentState?.viewModel;
      viewModel?.setRecording(widget.room.isRecording);
      // sort participants on many track events as noted in documentation linked above
      _sortParticipants();
    })
    ..on<ParticipantConnectedEvent>((event) {
      _sortParticipants();
    })
    ..on<ParticipantDisconnectedEvent>((event) {
      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      var viewModel = _livekitProviderKey.currentState?.viewModel;
      viewModel?.setRecording(event.activeRecording);
      // context.showRecordingStatusChangedDialog(event.activeRecording);
    })
    ..on<RoomAttemptReconnectEvent>((event) {
      if (kDebugMode) {
        print(
          'Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
      }
    })
    ..on<LocalTrackSubscribedEvent>((event) {
      if (kDebugMode) {
        print('Local track subscribed: ${event.trackSid}');
      }
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<TrackE2EEStateEvent>(_onE2EEStateEvent)
    ..on<ParticipantNameUpdatedEvent>((event) {
      _sortParticipants();
    })
    ..on<ParticipantMetadataUpdatedEvent>((event) {
    })
    ..on<RoomMetadataChangedEvent>((event) {
    })
    ..on<DataReceivedEvent>((event) {
      _handleDataChannel(event);
    })
    ..on<AudioPlaybackStatusChanged>((event) async {
      if (!widget.room.canPlaybackAudio) {
        if (kDebugMode) {
          print('Audio playback failed for iOS Safari ..........');
        }
        bool? yesno = await context.showPlayAudioManuallyDialog();
        if (yesno == true) {
          await widget.room.startAudio();
        }
      }
    });

  void _handleDataChannel(DataReceivedEvent event) {
    var _eventData = parseJsonData(event.data);
    var eventData = _eventData.copyWith(identity: event.participant);
    _checkReceivedDataType(eventData);
  }

  Future<void> _checkReceivedDataType(RemoteActivityData remoteData) async {
    var viewModel = _livekitProviderKey.currentState?.viewModel;
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
      case "mute_camera":
        viewModel?.disableVideo();
        break;

      case "mute_mic":
        viewModel?.disableAudio();
        break;
      //
      case "ask_to_unmute_mic":
        showSnackBar(
            message: "Host is asking you to turn on your mic",
            actionText: "Accept",
            actionCallBack: () {
              viewModel?.enableAudio();
            });
        final result = await context
            .showPermissionAskDialog("Host is asking you to turn on your mic");
        if (result == true) viewModel?.enableAudio();
        break;

      case "ask_to_unmute_camera":
        final result = await context.showPermissionAskDialog(
            "Host is asking you to turn on your camera");
        if (result == true) viewModel?.enableVideo();
        break;

      case "makeCoHost":
        if (Utils.isCoHost(viewModel?.room.localParticipant?.metadata)) {
          viewModel?.setCoHost(true);
          viewModel?.meetingDetails.authorization_token =
              remoteData.token ?? "";
        } else {
          viewModel?.setCoHost(false);
        }
        break;

      case "force_mute_all":
        viewModel?.isAudioPermissionEnable = !remoteData.value;
        if (!(viewModel?.isAudioPermissionEnable ?? false)) {
          viewModel?.disableAudio();
          viewModel?.setMicAlpha(0.8);
        } else {
          viewModel?.setMicAlpha(1.0);
        }
        break;

      case "force_video_off_all":
        viewModel?.isVideoPermissionEnable = !remoteData.value;
        if (!(viewModel?.isVideoPermissionEnable ?? false)) {
          viewModel?.disableVideo();
          viewModel?.setCameraAlpha(0.8);
        } else {
          viewModel?.setCameraAlpha(1.0);
        }
        break;

      case "":
        // Handle empty action case if needed
        break;

      default:
        // Handle null or unknown action
        if (remoteData.message != null &&
            remoteData.message?.isNotEmpty == true) {
          viewModel?.addMessage(remoteData);
        }
    }
  }

  RemoteActivityData parseJsonData(List<int> jsonData) {
    final jsonString = utf8.decode(jsonData); // Convert Uint8List to String
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString); // Decode the JSON string
    return RemoteActivityData.fromJson(
        jsonMap); // Convert to RemoteActivityData
  }

  void _askPublish() async {
    final result = await context.showPublishDialog();
    if (result != true) return;
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      if (kDebugMode) {
        print('could not publish video: $error');
      }
      await context.showErrorDialog(error);
    }
    try {
      await widget.room.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      if (kDebugMode) {
        print('could not publish audio: $error');
      }
      await context.showErrorDialog(error);
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
    if (kDebugMode) {
      print('e2ee state: $e2eeState');
    }
  }

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];

    // Add remote participants
    for (var participant in widget.room.remoteParticipants.values) {
      bool hasVideoTrack = false;

      for (var t in participant.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: participant,
            type: ParticipantTrackType.kScreenShare,
          ));
        } else {
          hasVideoTrack = true;
          userMediaTracks.add(ParticipantTrack(participant: participant));
        }
      }

      // Add participant if they don't have any video tracks
      if (!hasVideoTrack) {
        userMediaTracks.add(ParticipantTrack(participant: participant));
      }
    }

    // Add local participant if they exist
    final localParticipant = widget.room.localParticipant;
    if (localParticipant != null) {
      userMediaTracks.add(ParticipantTrack(participant: localParticipant));

      // Handle local video tracks (for screen share and video)
      for (var t in localParticipant.videoTrackPublications) {
        if (t.isScreenShare) {
          if (lkPlatformIs(PlatformType.iOS) && !_flagStartedReplayKit) {
            _flagStartedReplayKit = true;
            ReplayKitChannel.startReplayKit();
          }
          screenTracks.add(ParticipantTrack(
            participant: localParticipant,
            type: ParticipantTrackType.kScreenShare,
          ));
        }
      }
    }

    // Sort the user media tracks
    userMediaTracks.sort((a, b) {
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        return a.participant.audioLevel > b.participant.audioLevel ? -1 : 1;
      }

      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    // Update the participant tracks
    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
    final viewmodel = _livekitProviderKey.currentState?.viewModel;
    viewmodel?.addParticipant(participantTracks);
  }

  final GlobalKey<LivekitProviderState> _livekitProviderKey =
      GlobalKey<LivekitProviderState>();

  @override
  Widget build(BuildContext context) {
    return LivekitProvider(
      key: _livekitProviderKey,
      room: widget.room,
      meetingDetails: widget.meetingDetails,
      child: WillPopScope(
        onWillPop: () async {
          // Check if any dialogs or bottom sheets are open
          bool isPopupOpen = Navigator.of(context).canPop();

          if (isPopupOpen) {
            // Close the current dialog/bottom sheet if any are open
            Navigator.of(context).pop();
            return false; // Prevent back navigation
          } else {
            // Show a confirmation dialog to exit
            bool shouldExit = await _showExitConfirmationDialog(context);
            return shouldExit;
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    // Main content area for participants
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: participantTracks.isNotEmpty
                                    ? ParticipantWidget.widgetFor(
                                        participantTracks.first,
                                        showStatsLayer: true,
                                      )
                                    : Container(),
                              ),
                              // Horizontal list of participants positioned above LivekitControls
                              if (participantTracks.length > 1)
                                SizedBox(
                                  height: 120,
                                  // Fixed height for the participant list
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: participantTracks.length - 1,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                      width: 180,
                                      height: 120,
                                      child: ParticipantWidget.widgetFor(
                                        participantTracks[index + 1],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (_livekitProviderKey
                                  .currentState?.viewModel.isRecording ==
                              true)
                            const Positioned(
                              right: 10,
                              top: 10,
                              child: Icon(Icons.radio_button_checked,
                                  color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    // LivekitControls positioned at the bottom
                    if (widget.room.localParticipant != null)
                      SafeArea(
                        top: false,
                        child: LivekitControls(
                          widget.room,
                          widget.room.localParticipant!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit Meeting'),
              content: const Text('Are you sure you want to exit the meeting?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't exit
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit
                  },
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void showSnackBar(
      {required String message, String? actionText, Function? actionCallBack}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: actionText != null
          ? SnackBarAction(
              label: actionText,
              onPressed: () {
                actionCallBack?.call();
              },
            )
          : null,
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
