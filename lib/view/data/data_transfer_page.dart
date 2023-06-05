import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/data_transfer_controller.dart';
import 'package:sports/model/data_transfer_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_left_list.dart';
import 'package:sports/view/data/data_transfer_card.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DataTransferPage extends StatefulWidget {
  DataTransferPage(this.leagueId, {Key? key, required this.tag})
      : super(key: key);

  int leagueId;
  final String tag;

  @override
  State<DataTransferPage> createState() => _DataTransferPageState();
}

class _DataTransferPageState extends State<DataTransferPage>
    with AutomaticKeepAliveClientMixin {
  late DataTransferController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataTransferController>(
      tag: widget.tag,
      initState: (state) {
        controller = Get.put(
            DataTransferController(widget.leagueId, widget.tag),
            tag: widget.tag);
      },
      didUpdateWidget: (oldWidget, state) {
        if (controller.visible) {
          controller = Get.put(
              DataTransferController(widget.leagueId, widget.tag),
              tag: widget.tag);
          controller.getData();
        }
      },
      builder: (_) {
        return VisibilityDetector(
          key: Key(widget.tag),
          onVisibilityChanged: (VisibilityInfo info) {
            controller.visible = !info.visibleBounds.isEmpty;
          },
          child: controller.left == null
              ? Container()
              : Row(
                  children: [
                    DataLeftList(controller.left!, controller.structIndex,
                        ((p0) {
                      if (p0 == 0) {
                        Utils.onEvent('sjpd_zh/jf',
                            params: {'sjpd_zh/jf': '0'});
                      } else if (p0 == 1) {
                        Utils.onEvent('sjpd_zh/jf',
                            params: {'sjpd_zh/jf': '1'});
                      }
                      controller.onSelectStruct(p0);
                    })),
                    right(),
                  ],
                ),
        );
      },
    );
  }

  Widget right() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: Row(
              children: [
                SizedBox(
                    width: 34,
                    child: Text(
                      '球员',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colours.grey_color, fontSize: 13),
                    )),
                Spacer(),
                SizedBox(
                  width: 55,
                  child: Text(
                    '原球队',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colours.grey_color, fontSize: 13),
                  ),
                ),
                SizedBox(width: 29),
                SizedBox(
                  width: 55,
                  child: Text(
                    '新球队',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colours.grey_color, fontSize: 13),
                  ),
                )
              ],
            ),
          ),
          controller.showTransfer!.length == 0
              ? NoDataWidget()
              : Expanded(
                  child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemBuilder: (context, index) => player(index),
                    itemCount: controller.showTransfer!.length,
                  ),
                ))
        ],
      ),
    ));
  }

  Widget player(int index) {
    Transfers transfer = controller.showTransfer![index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Utils.onEvent('sjpd_zh/jf', params: {'sjpd_zh/jf': '2'});
        DataTransferCard.show(transfer);
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          CachedNetworkImage(
            height: 32,
            width: 24,
            fit: BoxFit.cover,
            imageUrl: transfer.photo ?? '',
            placeholder: (context, url) => Styles.placeholderIcon(),
            errorWidget: (context, url, error) => Image.asset(
              Utils.getImgPath('team_logo.png'),
              height: 32,
              width: 24,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (transfer.nameChs ?? transfer.nameEn) ?? '',
                  // textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colours.text_color1, fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  transfer.transferTypeCn ?? '',
                  style: TextStyle(color: Colours.grey_color, fontSize: 11),
                )
              ],
            ),
          ),
          SizedBox(
            width: 55,
            child: Text(
              transfer.fromTeamCn ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colours.text_color1, fontSize: 11),
            ),
          ),
          SizedBox(width: 8),
          Image.asset(
            Utils.getImgPath('data_transfer.png'),
            width: 13,
            height: 11,
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 55,
            child: Text(
              transfer.toTeamCn ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colours.text_color1, fontSize: 11),
            ),
          )
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
