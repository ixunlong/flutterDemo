import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/app_update_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/local_settings.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports/widgets/down_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

final html = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UPDATE</title>
</head>
<body>
    <style>
        html,body{
            font-size: 14px;
            padding: 0;
            margin: 0;
        }
    </style>
    {}
</body>
</html>
''';

class UpdateCheckDialog extends StatefulWidget {
  // const UpdateCheckDialog({super.key});

  const UpdateCheckDialog(
      {super.key,
      required this.updateinfo,
      required this.version,
      this.downinfo});

  final AppUpdateEntity updateinfo;
  final String version;
  final DownFileInfo? downinfo;

  static checkUpdate({bool noignre = false, bool alert = false}) async {
    final lastInfo = SpUtils.appUpdateInfo;

    final info = await PackageInfo.fromPlatform();

    final updateinfo = await Api.checkUpdate(info.version);
    if (updateinfo == null) {
      return;
    }
    // 检查是否需要升级
    if (lastInfo != null && !updateinfo.getForce) {
      if (noignre) {
      } else if ((lastInfo.latestVersion == updateinfo.latestVersion) &&
          lastInfo.getIgnore) {
        log("ignore version ${updateinfo.toJson()} \n old verversion = ${lastInfo.toJson()}");
        return;
      }
    }
    if (!updateinfo.getNeedUpdate) {
      if (alert) {
        ToastUtils.show("当前已是最新版本");
      }
      return;
    }
    final url = updateinfo.apkUrl ?? "";
    DownFileInfo? downinfo = null;
    if (Platform.isAndroid) {
      downinfo = await DownFileInfo.getFromUrl(url);
      if (downinfo == null) {
      } else if (await downinfo.isFileComplete()) {
      } else if (!alert && !updateinfo.getForce) {
        if (LocalSettings.wlanDown) {
          downinfo.runWlanDownTask();
          return;
        }
      }
    }

    Get.dialog(
        barrierDismissible: false,
        UpdateCheckDialog(
          updateinfo: updateinfo,
          version: info.version,
          downinfo: downinfo,
        ));
    SpUtils.appUpdateInfo = updateinfo;
  }

  @override
  State<UpdateCheckDialog> createState() => _UpdateCheckDialogState();
}

class _UpdateCheckDialogState extends State<UpdateCheckDialog> {
  AppUpdateEntity get updateinfo => widget.updateinfo;
  String get version => widget.version;
  DownFileInfo? get downinfo => widget.downinfo;
  bool updateclicked = false;

  doUpdate() async {
    final uri = Uri.tryParse(updateinfo.apkUrl ?? "");
    if (uri == null) {
      return;
    }

    // final downinfo = await DownFileInfo.getFromUrl(updateinfo.apkUrl ?? "");
    // log("downinfo = ${downinfo}");
    // if (Platform.isAndroid && downinfo != null) {
    //   return;
    // }
    updateclicked = true;
    final di = downinfo;
    if (Platform.isAndroid && di != null) {
      if (await di.isFileComplete()) {
        final s = !AppConfig.config.isDebug
            ? 0
            : await Utils.sheetSelect(["安装", "删除"]);
        if (s == 0) {
          InstallPlugin.installApk(di.filepath, "com.jykj.hqh");
        } else if (s == 1) {
          File(di.filepath).deleteSync();
          di.isComplete = false;
          updateclicked = false;
        }
        update();
      } else if (di.task.isResuming) {
        di.task.cancel();
      } else {
        di.task.resume();
      }
      return;
    }

    if (!await canLaunchUrl(uri)) {
      return null;
    }
    launchUrl(uri);
  }

  @override
  initState() {
    Get.find<ConfigService>().tipEnable = false;
    super.initState();
    downinfo?.task.onDownProccess = (len) {
      update();
    };
    downinfo?.task.onDone = () {
      downinfo?.isFileComplete().then((value) {
        update();
      });
    };
  }

  @override
  dispose() {
    Get.find<ConfigService>().tipEnable = true;
    super.dispose();
  }

  _descCell(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).sized(height: 30);
  }

  @override
  Widget build(BuildContext context) {
    final c = Container(
        width: 331,
        height: 427,
        decoration: BoxDecoration(
            image: DecorationImage(
                // fit: BoxFit.cover,
                image: AssetImage(Utils.getImgPath("update_bg.png")))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 54),
              Row(
                children: [
                  const Text("发现新版本",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5),
                  Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      width: 36,
                      height: 12,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("v${updateinfo.latestVersion}",
                          style: TextStyle(color: Colors.red, fontSize: 10)))
                ],
              ),
              Text("当前版本v$version",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              const SizedBox(height: 61),
              Text("更新内容：",
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              SizedBox(
                  height: 109,
                  child: SingleChildScrollView(
                    child: Html(
                      data: updateinfo.updateDesc,
                      style: {
                        "body": Style(
                            padding: EdgeInsets.zero, margin: Margins.zero)
                      },
                    ),
                  )),
              SizedBox(height: 39),
              updateinfo.getForce
                  ? _forceUpdateRow()
                  : Row(
                      children: [
                        Expanded(
                            child:
                                Container(height: 44, child: _updateButton()))
                      ],
                    )
            ],
          ),
        ));

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [c, updateinfo.getForce ? Container() : _bottomQuitX()],
      ),
    );
  }

  Widget _updateButton() {
    final di = downinfo;
    String title = "立即下载";
    double percent = 1;
    if (di != null) {
      if (di.isComplete) {
        title = "立即升级";
      } else if (updateclicked) {
        percent = di.task.len / di.total;
        title =
            "${((di.task.len / di.total) * 100).toStringAsFixed(1)}%  ${di.task.isResuming ? "暂停下载" : "继续下载"}";
      }
    }
    // downinfo?.task.len / downinfo?.total
    //  (downinfo?.isComplete ?? false) ? "立即升级" :(downinfo?.task.isResuming ?? false ? "123" : "立即下载");
    return LayoutBuilder(builder: (p0, p1) {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: p1.maxWidth * (1 - percent),
                child: Container(
                  color: Colours.main_color,
                )),
            Positioned.fill(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red.withAlpha(0x80),
                      foregroundColor: Colors.white),
                  child: Text(title, style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Utils.onEvent('sjtk', params: {'sjtk': '0'});
                    doUpdate();
                  }),
            ),
          ],
        ),
      );
    });
  }

  _bottomQuitX() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: TextButton(
        onPressed: () {
          // final info = SpUtils.appUpdateInfo;
          // info?.ignore = true;
          // SpUtils.appUpdateInfo = info;
          Get.back();
        },
        child: Container(
          child: Image.asset(Utils.getImgPath("close_icon_circle.png")),
          width: 32,
          height: 32,
        ),
      ),
    );
  }

  _forceUpdateRow() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                Utils.onEvent('sjtk', params: {'sjtk': '1'});
                exit(0);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(
                      width: 1, color: Colors.red, style: BorderStyle.solid)),
              child: Text("退出应用"),
            ),
          ),
        ),
        // const Spacer(),
        const SizedBox(
          width: 16,
        ),
        Expanded(child: SizedBox(height: 44, child: _updateButton())),
      ],
    );
  }
}

// class UpdateCheckDialog extends StatelessWidget {
  
// }
