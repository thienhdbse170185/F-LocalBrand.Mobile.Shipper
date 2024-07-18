import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flocalbrand_mobile_shipper/features/user/dto/user_dto.dart';

class UserApiClient {
  const UserApiClient(this.dio);

  final Dio dio;

  Future<UserDto> getUserInfo(String? jwtToken) async {
    try {
      final response = await dio.get('/auth/user-info',
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $jwtToken'}));
      return UserDto.fromJson(response.data['result']['user']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDeviceId(String deviceId) async {
    try {
      await dio.put(
        '/user/update/deviceid/$deviceId',
      );
    } catch (e) {
      rethrow;
    }
  }
}
