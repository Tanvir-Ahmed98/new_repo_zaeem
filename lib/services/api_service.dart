import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/app_platforms.dart';

enum Port {
  port1400("http://software.abairtechsolution.com:1400/ords/mobile/parent"),
  port1500(
      "http://software.abairtechsolution.com:1500/jasperserver/flow.html?_flowId=viewReportFlow&reportUnit=/reports/SOFT");

  final String url;
  const Port(this.url);
}

class ApiService {
  final Dio _dio = Dio();
  final String username = "api";
  final String password = "apitest";

  Map<String, String> _createHeaders() {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': basicAuth,
    };
  }

  Future<Map<String, dynamic>> get(String endpoint,
      {Port port = Port.port1400, Map<String, String>? headers}) async {
    final stopwatch = Stopwatch()..start();
    var response = await _dio.get('${port.url}$endpoint',
        options: Options(headers: headers ?? _createHeaders()));
    stopwatch.stop();
    log('APi: ${port.url}$endpoint and GET request took: ${stopwatch.elapsedMilliseconds} ms'); // Log elapsed time
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String?> download(
    String downloadUrl, {
    Port port = Port.port1500,
    Map<String, String>? headers,
    required String saveFilePath,
    Function(int)? onProgress,
  }) async {
    String? filePath;

    if (getPlatform() == AppPlatform.android) {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();

      AndroidDeviceInfo android = await plugin.androidInfo;
      if (android.version.sdkInt < 33) {
        await Permission.storage.request().then((value) async {
          if (value.isGranted) {
            filePath = '/storage/emulated/0/Download/$saveFilePath';
          } else if (await Permission.storage.isPermanentlyDenied) {
            await openAppSettings();
          } else if (await Permission.storage.isDenied) {
            await openAppSettings();
          }
        });
      } else {
        filePath = '/storage/emulated/0/Download/$saveFilePath';
      }
    } else if (getPlatform() == AppPlatform.ios) {
      Directory documentsDir = await getApplicationDocumentsDirectory();

      filePath = '${documentsDir.path}/$saveFilePath';
    }

    final response = await _dio.download(
      '${port.url}$downloadUrl',
      filePath,
      onReceiveProgress: (count, total) {
        if (total != -1) {
          int progress = (count / total * 100).toInt();
          if (onProgress != null) {
            // log("Check---$progress");
            onProgress(progress);
          }
        }
      },
    );
    if (response.statusCode == 200) {
      return filePath!;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      {Port port = Port.port1400, Map<String, String>? headers}) async {
    log("url: ${port.url}$endpoint ${_createHeaders()} $data");
    final response = await _dio.post(
      '${port.url}$endpoint',
      options: Options(headers: headers ?? _createHeaders()),
      data: data,
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data,
      {Port port = Port.port1400, Map<String, String>? headers}) async {
    final response = await _dio.put(
      '${port.url}$endpoint',
      options: Options(headers: headers ?? _createHeaders()),
      data: data,
    );
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> delete(
      String endpoint, Map<String, dynamic> data,
      {Port port = Port.port1400, Map<String, String>? headers}) async {
    final response = await _dio.delete(
      '${port.url}$endpoint',
      options: Options(headers: headers ?? _createHeaders()),
      data: data,
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to post data');
    }
  }
}
