import 'dart:async';
import 'dart:math' as math;
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:flutter_animate/animate.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/app_news_float_widget.dart';
import 'package:sports/widgets/common_dialog.dart';

class AppNewsFloat2Widget extends StatefulWidget {
  const AppNewsFloat2Widget({super.key});

  static final List<HomeNewsEntity> _news = [];
  static void Function()? _update;
  static Future<bool> addNews(HomeNewsEntity? n) async {
    if (n == null) { return false; }
    final idx = _news.indexWhere((element) => element.id == n.id);
    if (idx >=0 && idx < _news.length) { 
      await Future.delayed(100.ms);
      await Utils.alertQuery("已存在于浮窗中");
      return false;}
    if (_news.length >= 5) {
      await Future.delayed(100.ms);
      // await Utils.alertQuery("浮窗数量已达最大，请清理后再添加");
      await Get.dialog(CommonDialog.hint("当前浮窗已满，管理后可继续添加",confirmText: "我知道了"));
      // await showDialog(context: Get.context!, builder: (context) => CommonDialog.hint("浮窗数量已达最大，请清理后再添加"));
      return false;
    }
    
    _news.add(n);
    _update?.call();
    return true;
  }

  static bool existNews(int id) {
    final idx = _news.indexWhere((element) => element.id == id);
    if (idx >= 0 && idx < _news.length) {
      return true;
    }
    return false;
  }

  static delNews(int? id) {
    final idx = _news.indexWhere((element) => element.id == id);
    if (idx >= 0 && idx < _news.length) {
      _news.removeAt(idx);
      _update?.call();
    }
  }

  @override
  State<AppNewsFloat2Widget> createState() => _AppNewsFloat2WidgetState();
}

class _AppNewsFloat2WidgetState extends State<AppNewsFloat2Widget> {
  
  static const purple = Color(0xFFB255DE);
  static const red = Colours.main;
  static const orange = Color(0xFFF5AC3F);
  static const green = Color(0xFF63DB39);
  static const blue = Color(0xFF4FA2EF);
  
  final List<Color> colors = [purple,red,orange,green,blue];
  final double width = 60;
  bool expand = false;
  int? deleteI;

  late Offset _p = MediaQuery.of(context).size.centerRight(Offset(-width,-MediaQuery.of(context).size.height / 6));
  Offset get p => _p;
  set p(Offset n) {
    double dx = n.dx;
    double dy = n.dy;
    if (dx > maxDx - 20) { dx = maxDx; }
    else if (dx < minDx + 20) { dx = minDx; }
    if (dy > maxDy) { dy = maxDy; }
    else if (dy < minDy ) { dy = minDy; }
    _p = Offset(dx, dy);
  }

  late final maxDx = MediaQuery.of(context).size.width - width;
  late final maxDy = MediaQuery.of(context).size.height - width;
  late final double minDx = 0;
  late final minDy = MediaQuery.of(context).padding.top;
  Offset startPosition = Offset.zero;
  bool get atLeftEdge => p.dx == minDx;
  bool get atRightEdge => p.dx == maxDx;
  bool get atEdge => p.dx == maxDx || p.dx == 0;
  bool animateToEdge = false;

  List<HomeNewsEntity> get news => AppNewsFloat2Widget._news;
  final _sc = StreamController.broadcast();

  @override
  void initState() {
    AppNewsFloat2Widget._update =() {
      expand = false;
      _sc.add(null);
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _sc.stream,
      builder: (context, snapshot) {
      
      if (news.isEmpty) { 
        expand = false;
        return Positioned(child: Container()); }
      return expand ? expandedWidget() : closedWidget();   

    });
    
  }

  Widget closedWidget() {
    final count = news.length;
    final r = 1 / count;
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        expand = true;
        update();
      },
      onPanStart: (details) {
        startPosition = p - details.localPosition;
      },
      onPanUpdate: (details) {
        animateToEdge = false;
        p = startPosition + details.localPosition;
        update();
      },
      onPanEnd: (details) {
        animateToEdge = true;
        update();
        Future.delayed(10.ms).then((value) {
          if (p.dx > MediaQuery.of(context).size.width/2) {
            p = Offset(maxDx, p.dy);
          } else {
            p = Offset(minDx, p.dy);
          }
          update();
        });
      },
      child: Container(
        width: 61,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colours.grey99,blurRadius: 2)],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular( atLeftEdge ? 0 : 30),bottomLeft: Radius.circular(atLeftEdge ? 0 : 30),
            topRight: Radius.circular(atRightEdge ? 0 : 30),bottomRight: Radius.circular( atRightEdge ? 0 : 30)
          )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (count == 1)
            _circle(news.first.title ?? "", colors[0]).animate().scale(duration: 300.ms,begin: 1,end: 1.3,curve: Curves.bounceOut),
            if (count > 1)
            ...List.generate(count,(idx) => _circle(news[idx].title ?? "${idx + 1}", colors[idx]).animate(key: ValueKey("${news.length}-$idx"))
              .rotate(curve: Curves.bounceOut ,duration: 1000.ms,begin: 0,end: -r * idx)
              .move(curve: Curves.bounceOut ,begin: Offset.zero,end: Offset(0,-13))
              .rotate(curve: Curves.bounceOut ,begin: 0,end: r * idx))
          ],
        ),
      ),
    );
    return animateToEdge ? 
      AnimatedPositioned(
        left: p.dx,
        top: p.dy,
        duration: 100.ms,
        onEnd: () {
          animateToEdge = false;
          update(); 
        },
        child: child, ) :
      Positioned(
      left: p.dx,
      top: p.dy,
      child: child
    );
  }

  Widget expandedWidget() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          expand = false;
          update();
        },
        child: Container(
          color: Colors.white.withOpacity(0.2),
          child: Stack(children: [
            ...List.generate(news.length,(i) {
              return Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height / 5 + (80 * i),
                child: _expandedCell(news[i],colors[i]))
                  // .animate(key: ValueKey(i))
                  // .move(duration: 0.ms,curve: Curves.bounceOut, begin: Offset(0, -60),end: Offset(0, (80 * i).toDouble()))
                  ;
            })
          ],),
        ),
      )
    );
  }

  Widget _expandedCell(HomeNewsEntity e,Color color) {
    final c = Container(
      width: 270,
      height: 60,
      padding: const EdgeInsets.only(left: 16),
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colours.greyEE,width: 0.5),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colours.grey66.withOpacity(0.5),blurRadius: 2)]
      ),
      child: Row(children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Text( e.title?.characters.first ?? "",style: TextStyle(color: Colors.white),),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(e.title ?? "",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colours.grey66,fontSize: 14),)),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(Utils.getImgPath("comment_close.png"))
        ).tap(() {
            deleteI = e.id;
            update();
        }),
      ],),
    ).tap(() {
      // news.removeWhere((element) => element.id == e.id);
      expand = false;
      if(e.imgStyle == 4) {
        Get.toNamed(Routes.homeVideoNews,parameters: {'id':"${e.id}","classId":"${e.classId}"});
      } else {
        Get.toNamed(Routes.homenews,parameters: {'id':"${e.id}","classId":"${e.classId}"});
      }
      update();
    });
    return deleteI != e.id ? c : c.animate(
      onComplete: (controller) {
        news.removeWhere((element) => element.id == deleteI);
        deleteI = null;
        update();
      },
    ).slide(duration: 200.ms,begin: Offset.zero,end: const Offset(1, 0));
  }

  Widget _circle(String name,Color color) {
    return Container(
      alignment: Alignment.center,
      width: 21,
      height: 21,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color
      ),
      child: Text(name.characters.first,style: const TextStyle(color: Colors.white,fontSize: 10),),
    );
  }

}