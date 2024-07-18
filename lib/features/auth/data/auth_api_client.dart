import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flocalbrand_mobile_shipper/features/auth/dto/login_dto.dart';

import '../dto/login_success.dart';

class AuthApiClient {
  AuthApiClient(this.dio);

  final Dio dio;

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: loginDto.toJson(),
      );
      return LoginSuccessDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['result']['message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
