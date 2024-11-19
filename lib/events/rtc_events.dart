abstract class RTCEvents{}

class ShowSnackBar extends RTCEvents {
  final String message;
  ShowSnackBar(this.message);
}
class ShowReaction extends RTCEvents{
  final String emoji;
  ShowReaction(this.emoji);
}

class UpdateView extends RTCEvents{}