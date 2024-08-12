import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors(
    this.dio,
  );
  final Dio dio;
}
