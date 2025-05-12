import 'dart:io';

import 'package:daakia_vc_flutter_sdk/model/consent_status_data.dart';
import 'package:daakia_vc_flutter_sdk/model/feature_data.dart';
import 'package:daakia_vc_flutter_sdk/model/licence_verify_model.dart';
import 'package:daakia_vc_flutter_sdk/model/participant_attendance_data.dart';
import 'package:daakia_vc_flutter_sdk/model/translation_data.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/base_list_response.dart';
import '../model/base_response.dart';
import '../model/event_password_protected_data.dart';
import '../model/host_token_model.dart';
import '../model/meeting_details_model.dart';
import '../model/rtc_data.dart';
import '../model/upload_data.dart';
import '../model/white_board_data.dart';

part 'api_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST("rtc/meeting/join")
  Future<BaseResponse<RtcData>> getMeetingJoinDetail(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/delete")
  Future<BaseResponse> endMeeting(
    @Body() Map<String, dynamic> body,
  );

  @POST("meeting/verifyHost")
  Future<BaseResponse<HostTokenModel>> verifyHostToken(
    @Body() Map<String, dynamic> body,
  );

  @GET("saas/host/token")
  Future<BaseResponse<HostTokenModel>> getHostToken(
    @Query("meeting_uid") String meetingUid,
  );

  @POST("saas/sdk/verify/key")
  Future<BaseResponse<LicenceVerifyModel>> licenceVerify(
    @Body() Map<String, dynamic> body,
  );

  @GET("saas/sdk/meeting/basic/detail")
  Future<BaseResponse<MeetingDetailsModel>> getMeetingDetails(
      @Query("meeting_uid") String meetingUid, @Header("secret") String secret);

  @POST("rtc/meeting/verify/commonPassword")
  Future<BaseResponse<EventPasswordProtectedData>> verifyCommonMeetingPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST("meeting/verify/password")
  Future<BaseResponse<EventPasswordProtectedData>> verifyMeetingPassword(
    @Body() Map<String, dynamic> body,
  );

  @GET("saas/meeting/features")
  Future<BaseResponse<FeatureData>> getFeatures(
      @Query("meeting_uid") String meetingUid);

  @POST("rtc/meeting/remove/participant")
  Future<BaseResponse> removeParticipant(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/create/cohost")
  Future<BaseResponse> makeCoHost(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/recording/start")
  Future<BaseResponse> startRecording(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/recording/stop")
  Future<BaseResponse> stopRecording(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/addParticipant/toLobby")
  Future<BaseResponse<RtcData>> addParticipantToLobby(
    @Body() Map<String, dynamic> body,
  );

  @PUT("rtc/meeting/update/participantLobbyStatus")
  Future<BaseResponse<RtcData>> acceptParticipantInLobby(
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/chat/uploadAttachment")
  @MultiPart()
  Future<BaseResponse<UploadData>> uploadFile(@Part() File file,
      {@SendProgress() ProgressCallback? onSendProgress});

  @POST("rtc/meeting/update/transcriptionLanguage")
  Future<BaseResponse> setTranscriptionLanguage(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/transcription/start")
  Future<BaseResponse> startTranscription(
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/text/translation")
  Future<BaseResponse<TranslationData>> translateText(
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/updateParticipant/name")
  Future<BaseResponse> updateParticipantName(
    @Body() Map<String, dynamic> body,
  );

  @POST("rtc/meeting/time/extend")
  Future<BaseResponse> meetingTimeExtend(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @GET("rtc/meeting/whiteboard/get")
  Future<BaseListResponse<WhiteboardData>> getWhiteBoardData(
    @Query("meeting_id") String meetingId,
  );

  @GET("rtc/meeting/invitee/participantsList")
  Future<BaseListResponse<ParticipantAttendanceData>>
      getAttendanceListForParticipant(
    @Query("meeting_uid") String meetingId,
  );

  @PUT("rtc/meeting/updateRecording/consentStatus")
  Future<BaseResponse<ConsentStatusData>> updateRecordingConsent(
    @Body() Map<String, dynamic> body,
  );
}
