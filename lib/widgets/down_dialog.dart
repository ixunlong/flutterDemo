import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:sports/util/local_settings.dart';
import 'package:sports/util/utils.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';


class DownTask {
  
  static final Map<String,DownTask> _tasks = {};

  DownTask(this.url,this.path);

  final String url;
  final String path;

  static DownTask getTask(String url,String path) {
    final key = "$url->$path";
    final t = _tasks[key] ?? DownTask(url, path);
    _tasks[key] = t;
    File(path).stat().then((value){
      if (value.size > 0) {  
        t._len = value.size;
      } else {
        t._len = 0;
      }
    });
    return t;
  } 

  void Function(int)? onDownProccess;
  void Function()? onDone;

  bool get isResuming => _isResuming;
  bool _isResuming = false;
  CancelToken? _token;
  int _len = 0;
  StreamSubscription? _sub;
  RandomAccessFile? _raf;
  int get len => _len;

  _done() {
    _raf?.close();
    _raf = null;
    _token = null;
    _isResuming = false;
    _sub?.cancel();
    _sub = null;
    onDone?.call();
  }

  resume() async {
    if (_isResuming) { return; }
    _isResuming = true;
    _token = CancelToken();
    final file = File(path);
    if (!file.existsSync()) { file.createSync(recursive: true); }
    _len = file.statSync().size;
    RandomAccessFile raf = await file.open(mode: FileMode.append);
    _raf = raf;
    final r = await Dio(BaseOptions(

    )).get(url,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          "range":"bytes=$_len-"
        }
      ),
      cancelToken: _token);
    Stream<Uint8List> stream = r.data!.stream;
    _sub = stream.listen((event) { 
      raf.writeFromSync(event);
      _len += event.length;
      log("download len ${event.length} received = ${len}");
      onDownProccess?.call(_len);
    },onDone: () {
      _done();
    },onError: (err) {
      _done();
    });
  }

  cancel() {
    _token?.cancel();
  }

}

class DownFileInfo {

  DownFileInfo(this.url,this.vmd5,this.total,this.filename,this.filepath);

  final String url;

  final String vmd5;
  final int total;
  
  final String filename;
  final String filepath;

  bool isComplete = false;

  

  int get size => File(filepath).statSync().size;

  DownTask get task => DownTask.getTask(url,filepath);

  // showDialog(bool autoStart) async => 
    //  await Get.dialog(DownDialog(url: url, downinfo: this,autoStart: autoStart,));
  
  StreamSubscription? _sub1;
  Timer? _autoDownTimer;
  bool _isWifiNow = false;

  _setAutoTimer() {
    _autoDownTimer?.cancel();
    _autoDownTimer = Timer.periodic(Duration(seconds: 20), (timer) { _timerRunOnce(); });
  }
  _timerRunOnce() async {
    log("auto down timer is wifi $_isWifiNow spwlandown ${LocalSettings.wlanDown} complete ${await isFileComplete()}");
    if (!_isWifiNow) { return; }
    if (!LocalSettings.wlanDown || await isFileComplete()) {
      _autoDownTimer?.cancel();
    } else {
      task.resume();
    }
  }

  _setConnectivitySub() {
    _sub1?.cancel();
    _sub1 = Connectivity().onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.wifi) {
        task.cancel();
        _autoDownTimer?.cancel();
        _isWifiNow = false;
        return;
      } 
      _isWifiNow = true;
      _setAutoTimer();
    });
  }

  runWlanDownTask() {
    _sub1?.cancel();
    _autoDownTimer?.cancel();
    Connectivity().checkConnectivity().then((value){
      _isWifiNow = value == ConnectivityResult.wifi;
    });
    _setConnectivitySub();
    _setAutoTimer();
  }

  cancelWlanDownTask() {
    _sub1?.cancel();
    _autoDownTimer?.cancel();
    task.cancel();
  }
  

  Future<String?> fileMd5() async {
    final f = File(filepath);
    if(!f.existsSync()) { return null; }
    final fmd5 = await md5.bind(f.openRead()).first;
    return fmd5.toString();
  }

  Future<bool> _isFileComplete() async {
    final f = File(filepath);
    if(!f.existsSync()) { return false; }
    if(f.statSync().size != total) { return false; }
    if ((await fileMd5())?.toLowerCase() != vmd5.toLowerCase()) { return false;}
    return true;
  }

  Future<bool> isFileComplete() async {
    final b = await _isFileComplete();
    isComplete = b;
    return b;
  }

  static DownFileInfo? last;

  static Future<DownFileInfo?> getFromUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final filename = uri.pathSegments.last;
      final dir = (await pp.getExternalStorageDirectories(type: pp.StorageDirectory.downloads))!.first;
      final filepath = dir.uri.resolve(filename).path;

      final r = await Dio().head(url,options: Options(
        headers: {
          "range":"bytes=0-"
        }
      ));
      log("head info = ${r.headers}");
      final vmd5 = (r.headers.value("etag") ?? "").replaceAll("\"", "");
      final total = int.tryParse(r.headers.value("content-length") ?? "") ?? 0;

      if (last?.url == url && last?.vmd5 == vmd5) { return last; }

      if (vmd5.isEmpty || !filename.endsWith(".apk")) {
        return null;
      }

      final info = DownFileInfo(url, vmd5, total, filename, filepath);
      last = info;
      return info;

    }catch (err) {
      log("down file $url get err $err");
      return null;
    }
  }
}

// class DownRange {
//   int begin;
//   int end;
//   int total;
//   int current;
//   DownRange({required this.begin,required this.end, required this.total, required this.current});
// }

// class DownDialog extends StatefulWidget {

//   DownDialog({super.key,required this.url,this.downinfo,this.autoStart = false});

//   bool autoStart;
//   final String url;
//   final DownFileInfo? downinfo;

//   @override
//   State<DownDialog> createState() => _DownDialogState();

// }

// class _DownDialogState extends State<DownDialog> {
  
//   String get url => widget.url;
//   // DownRange? range;
//   late DownTask task;

//   bool isReady = false;
//   bool isFileDownloaded = false;
//   DownFileInfo? info;
//   int curLen = 0;
//   int totalLen = 1;

//   @override
//   initState() {
//     super.initState();
//     init();
//   }

//   init() async {

//     final info = widget.downinfo ?? await getFileInfo();

//     if (info == null) {
//       Get.back();
//       return;
//     }

//     this.info = info;
//     totalLen = info.total;

//     task = info.task;

//     task.onDownProccess =(p0) {
//       curLen = task.len;
//       update();
//     };
//     task.onDone =() {
//       verifyFileComplete();
//     };

//     await verifyFileComplete();

//     if (!isFileDownloaded && widget.autoStart) {
//       task.resume();
//     }

//     isReady = true;
//     update();
//   }

//   Future<String> getFileMd5(String path) async {
//     final file = File(path);
//     if (!file.existsSync()) { return ""; }
//     return (await md5.bind(File(path).openRead()).first).toString();
//   }

//   verifyFileComplete() async {
//     final info = this.info;
//     if (info == null) { return; }
//     isFileDownloaded = await info.isFileComplete();
//     log("file downloaded = $isFileDownloaded");
//     update();
//   }

//   // Future<bool> isFileComplete(int total,String vmd5) async {
//   //   final f = File(downFilePath);
//   //   if (!f.existsSync()) { return false; }
//   //   if (f.statSync().size != total) { return false; }
//   //   if((await getFileMd5(downFilePath)) != vmd5.toLowerCase()) { return false; }
//   //   return true;
//   // }

//   Future<DownFileInfo?> getFileInfo() async {
//     return await DownFileInfo.getFromUrl(url);
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     if (!isReady) {
//       return Dialog(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Text("获取信息中..."),
//         ),
//       );
//     }

//     return Dialog(
//       child: isFileDownloaded ? 
//         Container(
//           height: 200,
//           child: Column(
//             children: [
//               OutlinedButton(onPressed: () async {
//                 final info = this.info;
//                 if (info == null) { return; }
//                 log("path = ${info.filepath}");
//                 InstallPlugin.installApk(info.filepath, "com.huachao.qiuxiangbiao");
//               }, child: Text("安装")),
//               OutlinedButton(onPressed: (){
//                 final info = this.info;
//                 if (info == null) { return; }
//                 File(info.filepath).deleteSync();
//                 curLen = info.size;
//                 verifyFileComplete();
//               }, child: Text("删除"))
//             ],
//           ),
//         ) : 
//         _downloadWidget()
//     );
//   }

//   Widget _downloadWidget() {
//     return Container(
//       height: 200,
//       padding: EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           LinearProgressIndicator(
//             value: curLen / totalLen,
//           ),
//           OutlinedButton(onPressed: (){
//             task.isResuming ? task.cancel() : task.resume();
//             update();
//           }, child: Text( task.isResuming ? "暂停" : "下载")),
//         ],
//       ),
//     );
//   }

// }