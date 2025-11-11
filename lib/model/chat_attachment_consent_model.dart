class ChatAttachmentConsentModel {
  bool chatAttachmentDownloadConsent = false;

  ChatAttachmentConsentModel({required this.chatAttachmentDownloadConsent});

  factory ChatAttachmentConsentModel.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentConsentModel(
      chatAttachmentDownloadConsent: json['chat_attachment_download_consent'],
    );
  }

  Map<String, dynamic> toJson() => {
    'chat_attachment_download_consent': chatAttachmentDownloadConsent,
  };
}