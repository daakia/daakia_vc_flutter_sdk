class InvitedParticipant {
  int? id;
  String? attendee;
  String? participantStatus;
  String? participantIdentity;

  InvitedParticipant(
      {this.id,
      this.attendee,
      this.participantStatus,
      this.participantIdentity});

  InvitedParticipant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attendee = json['attendee'];
    participantStatus = json['participant_status'];
    participantIdentity = json['participant_identity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attendee'] = attendee;
    data['participant_status'] = participantStatus;
    data['participant_identity'] = participantIdentity;
    return data;
  }
}

class InvitedParticipantsData {
  List<InvitedParticipant>? invitedParticipants;

  InvitedParticipantsData({this.invitedParticipants});

  InvitedParticipantsData.fromJson(Map<String, dynamic> json) {
    if (json['invited_participants'] != null) {
      invitedParticipants = (json['invited_participants'] as List)
          .map((item) => InvitedParticipant.fromJson(item))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (invitedParticipants != null) {
      data['invited_participants'] =
          invitedParticipants!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}
