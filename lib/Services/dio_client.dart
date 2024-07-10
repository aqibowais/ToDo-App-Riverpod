import 'package:dio/dio.dart';
import 'package:todo_riverpod/constants/env.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: todoApi,
      responseType: ResponseType.json,
    );
  }

  Dio get dio => _dio;
}
