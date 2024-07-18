import 'package:dio/dio.dart';
import 'package:flocalbrand_mobile_shipper/config/interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio(BaseOptions(baseUrl: '${dotenv.env['API_URL']}'))
  ..interceptors.add(DioInterceptor());
