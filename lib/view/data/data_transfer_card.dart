import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/model/data_transfer_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_bottomsheet.dart';

class DataTransferCard extends StatelessWidget {
  Transfers transfer;
  DataTransferCard(this.transfer, {super.key});

  static show(Transfers transfer) {
    Get.bottomSheet(CommonBottomSheet(child: DataTransferCard(transfer)),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    List<String> info = [];
    if (transfer.countryCn.valuable) {
      info.add(transfer.countryCn!);
    }
    if (transfer.positionCn.valuable) {
      info.add(transfer.positionCn!);
    }
    if (transfer.age != null || transfer.age != 0) {
      info.add('${transfer.age!.toString()}岁');
    }
    if (transfer.height!.valuable) {
      info.add('${(double.parse(transfer.height!) / 100).toStringAsFixed(2)}米');
    }
    if (transfer.weight!.valuable) {
      info.add('${transfer.weight!}公斤');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          height: 50,
          width: 50,
          fit: BoxFit.fitWidth,
          imageUrl: transfer.photo ?? '',
          placeholder: (context, url) => Styles.placeholderIcon(),
          errorWidget: (context, url, error) => Image.asset(
            Utils.getImgPath('team_logo.png'),
            // height: 24,
            // width: 24,
          ),
        ),
        SizedBox(height: 14),
        Text(
          transfer.nameChs ?? '',
          style: TextStyle(
              fontSize: 15,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4),
        Text(
          transfer.nameEn ?? '',
          style: TextStyle(fontSize: 12, color: Colours.grey_color),
        ),
        SizedBox(height: 4),
        Text(
          info.join('/'),
          style: TextStyle(fontSize: 12, color: Colours.grey_color),
        ),
        SizedBox(height: 30),
        _item(
            '转会时间',
            DateUtilsExtension.formatDateString(
                transfer.transferTime!, 'yyyy-MM-dd')),
        _item('转会类型', transfer.transferTypeCn ?? '不详'),
        _item('转会价格', transfer.money.valuable ? '${transfer.money}万英镑' : '不详'),
        _item('转会球队', '由${transfer.fromTeamCn}转会至${transfer.toTeamCn}'),
        if (transfer.endTime.valuable)
          _item(
              '合同到期',
              DateUtilsExtension.formatDateString(
                  transfer.endTime!, 'yyyy-MM-dd')),
        SizedBox(height: 50),
      ],
    );
  }

  _item(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 14),
      child: Row(children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, color: Colours.greyA9),
        ),
        SizedBox(
          width: 28,
        ),
        Expanded(
            child: Text(
          detail,
          style: TextStyle(fontSize: 15, color: Colours.text_color1),
        ))
      ]),
    );
  }
}
