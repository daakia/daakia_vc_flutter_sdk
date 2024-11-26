import 'package:livekit_client/livekit_client.dart';

abstract class RTCEvents{}

class ShowSnackBar extends RTCEvents {
  final String message;
  ShowSnackBar(this.message);
}
class ShowReaction extends RTCEvents{
  final String emoji;
  ShowReaction(this.emoji);
}

class OpenPrivateChat extends RTCEvents{
  final Participant? participant;
  OpenPrivateChat(this.participant);
}

class UpdateView extends RTCEvents{}