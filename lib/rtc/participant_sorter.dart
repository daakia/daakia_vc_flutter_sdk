import 'package:daakia_vc_flutter_sdk/rtc/widgets/participant_info.dart';
import 'package:livekit_client/livekit_client.dart';

class ParticipantSorter {

  static const Duration debounceDuration = Duration(milliseconds: 300);

  static List<ParticipantTrack> sortTrack(Room room, bool flagStartedReplayKit) {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];

    void addParticipantTracks(Participant participant) {
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
      if (!hasVideoTrack) {
        userMediaTracks.add(ParticipantTrack(participant: participant));
      }
    }

    room.remoteParticipants.values.forEach(addParticipantTracks);

    final localParticipant = room.localParticipant;
    if (localParticipant != null) {
      userMediaTracks.add(ParticipantTrack(participant: localParticipant));
      for (var t in localParticipant.videoTrackPublications) {
        if (t.isScreenShare) {
          if (lkPlatformIs(PlatformType.iOS) && !flagStartedReplayKit) {
            flagStartedReplayKit = true;
          }
          screenTracks.add(ParticipantTrack(
            participant: localParticipant,
            type: ParticipantTrackType.kScreenShare,
          ));
        }
      }
    }

    userMediaTracks.sort((a, b) {
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        return b.participant.audioLevel.compareTo(a.participant.audioLevel);
      }
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      if (aSpokeAt != bSpokeAt) {
        return bSpokeAt.compareTo(aSpokeAt);
      }
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }
      return a.participant.joinedAt.millisecondsSinceEpoch.compareTo(
          b.participant.joinedAt.millisecondsSinceEpoch);
    });

    return [...screenTracks, ...userMediaTracks];
  }
}
