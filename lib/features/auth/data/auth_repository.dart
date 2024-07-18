import 'dart:developer';

import 'package:flocalbrand_mobile_shipper/features/auth/data/auth_api_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flocalbrand_mobile_shipper/features/user/data/user_api_client.dart';
import 'package:flocalbrand_mobile_shipper/service/notification_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../result_type.dart';
import '../dto/login_dto.dart';
import 'auth_local_data_source.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserApiClient userApiClient;

  AuthRepository(
      {required this.authApiClient,
      required this.authLocalDataSource,
      required this.userApiClient,
      firebase_auth.FirebaseAuth? firebaseAuth,
      GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<Result<void>> login({
    required String username,
    required String password,
  }) async {
    try {
      final loginSuccessDto = await authApiClient.login(
        LoginDto(username: username, password: password),
      );
      String token = await PushNotifications.getDeviceToken();
      await userApiClient.updateDeviceId(token);
      await authLocalDataSource.saveToken(loginSuccessDto.accessToken);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
    return Success(null);
  }

  Future<Result<String?>> getToken() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return Success(null);
      }
      return Success(token);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      await authLocalDataSource.deleteToken();
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
