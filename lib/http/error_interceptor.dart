import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:queue/queue.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:get/get.dart' as G;
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_dialog.dart';

class ErrorInterceptor extends Interceptor {
  Queue queue = Queue();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    EasyLoading.dismiss();
    if (err.type == DioErrorType.response) {
      if (err.response?.statusCode == ErrorCode.success) {
      } else if (err.response?.statusCode == ErrorCode.imageOversize) {
        ToastUtils.show('图片过大');
      } else {
        log("response err code = ${err.response?.statusCode}");
        log("response err content = ${err.response?.data}");
        // ToastUtils.show('服务器繁忙');
      }
    } else if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.receiveTimeout) {
      // ToastUtils.show('请求超时');
    } else {
      // ToastUtils.show('服务器繁忙');
    }
    super.onError(err, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // try {
    if (kDebugMode) {
      final dataString = response.data.toString();
      log('${DateTime.now()} Dio response for ${response.requestOptions.uri}\n data: ${dataString.length > 1000 ? dataString.substring(0, 1000) : dataString}');
    }

    final code = response.data['c'];

    if (code == 401) {
      bool success = await queue.add(() async {
        var requestToken = response.requestOptions.headers['Authorization'];
        var globalToken = User.auth?.token;

        // token一致表示需要更新token，不一致则表示token已经在其它请求中更新了
        if (requestToken == globalToken) {
          return await refreshToken();
        }
        return true;
      });
      if (success) {
        RequestOptions options = response.requestOptions;
        return await DioUtils.post(options.path,
            params: options.data, needEncrypt: false);
      } else {
        User.doLogin();
      }

      // if (SpUtils.loginAuth != null) {
      //   Api.refreshLogin().then((value) {
      //     if (value == null) {
      //       return;
      //     }
      //     User.fetchUserInfos();
      //   });
      // } else {
      //   User.doLogin();
      // }
    }
    // } catch (err) {}
    if (code == 1003) {
      G.Get.dialog(
              CommonDialog.alert(
                "实名认证",
                content: "根据《互联网信息服务管理办法》，发布评论需要实名认证哦",
                confirmText: "立即认证"
              ),
              barrierDismissible: false)
          .then((value) {
        if (value is bool && value) {
          G.Get.toNamed(Routes.accountVerify);
        }
      });
    }

    return super.onResponse(response, handler);
  }

  Future<bool> refreshToken() async {
    if (SpUtils.loginAuth == null) {
      return false;
    }
    Dio dio = Dio(DioUtils.options);
    Map<String, dynamic> data = {
      'phone': SpUtils.loginAuth?.phone ?? '',
      'accessCode': SpUtils.loginAuth?.accessCode ?? '',
    };
    data = DioUtils.wrapParams(data);
    log('Dio refresh token');
    final result = await dio.post('/user/usr-do/login', data: data);
    // final result = await DioUtils.post('/user/usr-do/login', params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      log('${DateTime.now()} Dio response for ${result.requestOptions.uri}\n data: ${result.data}');

      final data = AuthEntity.fromJson(result.data['d']);
      AuthEntity? auth = SpUtils.loginAuth;
      auth?.token = data.token;
      SpUtils.loginAuth = auth;
      return true;
    } else {
      log('Dio refresh failed');
      // queue.cancel();
      User.doLogout();
      return false;
    }
  }
}

class ErrorCode {
  static const int success = 200;
  // static const int success_not_content = 204;
  // static const int not_modified = 304;
  static const int unauthorized = 401;
  static const int imageOversize = 513;
  static const int accessTokenExpired = 1001;
  // static const int not_found = 404;
  // static const int connect_refused = 503;

  // static const int net_error = 1000;

  // static final Map<int, String> _errorMap = <int, String>{
  //   net_error: '网络异常，请检查你的网络！',
  // };
}
