import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/team/focus_team_list_entity.dart';
import 'package:sports/model/team/my_team_focus_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_left_list.dart';
import 'package:sports/widgets/common_button.dart';

class SelectFocusTeamPage extends StatefulWidget {
  const SelectFocusTeamPage({super.key});

  @override
  State<SelectFocusTeamPage> createState() => _SelectFocusTeamPageState();
}

class _SelectFocusTeamPageState extends State<SelectFocusTeamPage> {
  List<FocusTeamListEntity>? list;
  int structIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('关注球队')),
      body: list == null
          ? Container()
          : Row(
              children: [
                DataLeftList(
                    list!
                        .map((e) =>
                            e.leagueName! +
                            (e.focusCnt == 0 ? '' : '(${e.focusCnt})'))
                        .toList(),
                    structIndex, ((p0) {
                  structIndex = p0;
                  update();
                })),
                right(),
              ],
            ),
    );
  }

  Widget right() {
    List<MyTeamFocusEntity> rightList = list![structIndex].teamList!;
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => team(rightList[index]),
      itemCount: rightList.length,
    ));
  }

  Widget team(MyTeamFocusEntity data) {
    // final data = controller.teamAll![index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '5'});
        Get.toNamed(Routes.soccerTeamDetail, arguments: data.id);
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(24, 5, 16, 5),
        child: Row(children: [
          // SizedBox(width: 24),
          CachedNetworkImage(
            height: 24,
            width: 24,
            // fit: BoxFit.fitHeight,
            imageUrl: data.logo!,
            placeholder: (context, url) => Styles.placeholderIcon(),
            errorWidget: (context, url, error) => Image.asset(
              Utils.getImgPath('team_logo.png'),
              height: 24,
              width: 24,
            ),
          ),
          SizedBox(width: 10),
          Text(
            data.nameChsShort ?? '',
            // textAlign: TextAlign.center,
            style: TextStyle(color: Colours.text_color1, fontSize: 13),
          ),
          Spacer(),
          CommonButton(
            onPressed: () => onFocus(data),
            minHeight: 24,
            minWidth: 56,
            side: BorderSide(
                color:
                    data.focus == 0 ? Colours.main_color : Colours.grey_color1,
                width: 0.5),
            text: data.focus == 0 ? '关注' : '已关注',
            textStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color:
                    data.focus == 0 ? Colours.main_color : Colours.grey_color1),
          )

          // ...data.values!
          //     .map((e) => SizedBox(
          //           width: 50,
          //           child: Text(
          //             e,
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colours.text_color1, fontSize: 13),
          //           ),
          //         ))
          //     .toList(),
        ]),
      ),
    );
  }

  Future getData() async {
    List<FocusTeamListEntity>? result = await Api.teamForSelect();
    // justUnFocus = [];
    if (result != null) {
      list = result;
    }
    update();
  }

  onFocus(MyTeamFocusEntity data) async {
    if (data.focus == 1) {
      final alert = await Utils.alertQuery('确认不再关注');
      if (alert == true) {
        final result = await Api.focusTeam(data.id!, 2);
        if (result == 200) {
          data.focus = 0;
          list![structIndex].focusCnt = list![structIndex].focusCnt! - 1;
        } else {
          ToastUtils.showDismiss("取消关注失败");
        }
      }
    } else {
      Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '4'});
      final result = await Api.focusTeam(data.id!, 1);
      if (result == 200) {
        data.focus = 1;
        list![structIndex].focusCnt = list![structIndex].focusCnt! + 1;
      }
    }
    update();
  }
}
