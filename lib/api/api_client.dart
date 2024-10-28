
import 'package:daakia_vc_flutter_sdk/model/feature_data.dart';
import 'package:daakia_vc_flutter_sdk/model/licence_verify_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/HostTokenModel.dart';
import '../model/base_response.dart';
import '../model/livekit_data.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://stag-api.daakia.co.in/v2.0/')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET("meeting/list")
  Future<dynamic> getMeetingList(
    @Header("Device-Id") String? deviceId,
    @Header("Authorization") String? token,
    @Query("time_zone") String? timeZone,
    @Query("meeting_list_type") String? meetingType,
  );

  @POST("rtc/meeting/join")
  Future<BaseResponse<LiveKitData>> getMeetingJoinDetail(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> body,
      );

  @POST("meeting/verifyHost")
  Future<BaseResponse<HostTokenModel>> verifyHostToken(
      @Body() Map<String, dynamic> body,
      );

  @POST("saas/sdk/verify/key")
  Future<BaseResponse<LicenceVerifyModel>> licenceVerify(
      @Body() Map<String, dynamic> body,
      );
  
  @GET("saas/meeting/features")
  Future<BaseResponse<FeatureData>> getFeatures(
      @Query("meeting_uid") String meeting_uid
      );

}
