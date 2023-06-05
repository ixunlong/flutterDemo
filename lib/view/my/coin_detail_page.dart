import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import '../../res/styles.dart';
import 'package:sports/model/mine/coin_detail_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/date_utils_extension.dart';

class CoinDetailPage extends StatefulWidget {
  const CoinDetailPage({super.key});

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  late String goldOrderId;
  CoinDetailEntity? data;
  @override
  void initState() {
    super.initState();
    goldOrderId = Get.arguments as String;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: const Text("订单详情"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(children: [
            _header(),
            Container(
              height: 0.5,
              color: Colours.greyEE,
            ),
            SizedBox(height: 30),
            _item('当前状态', data?.status ?? '-'),
            _item('交易种类', data?.memo ?? '-'),
            _item(
                '交易时间',
                data?.createTime == null
                    ? '-'
                    : DateUtilsExtension.formatDateString(
                        data!.createTime!, 'yyyy-MM-dd HH:mm:ss')),
            _item('交易方式', data?.payType ?? '-'),
            _item('交易单号', data?.goldId ?? '-'),
            _item('红钻余额', data?.goldAfter ?? '-'),
            if (data?.description != null)
              _item('备注信息', data?.description ?? '-'),
          ]),
        ),
      ),
    );
  }

  _header() {
    return Container(
      height: 153,
      padding: EdgeInsets.only(top: 30),
      child: Column(children: [
        Text(data?.title ?? '-',
            style: TextStyle(color: Colours.text_color1, fontSize: 16)),
        SizedBox(
          height: 23,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          // textBaseline: TextBaseline.alphabetic,
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(data?.goldChange ?? '-',
                style: TextStyle(
                    color: Colours.text_color1,
                    fontSize: 36,
                    fontWeight: FontWeight.w500)),
            SizedBox(width: 3),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('红钻',
                  style: TextStyle(
                      color: Colours.text_color1,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ),
        // Expanded(
        //   child: RichText(
        //       text: TextSpan(children: [
        //     TextSpan(
        //         text: data?.goldChange ?? '-',
        //         style: TextStyle(
        //             color: Colours.text_color1,
        //             fontSize: 36,
        //             fontWeight: FontWeight.w500)),
        //     TextSpan(
        //         text: ' 红钻',
        //         style: TextStyle(
        //             color: Colours.text_color1,
        //             fontSize: 20,
        //             fontWeight: FontWeight.w500)),
        // ])),
        // )
        // Text('+1.88红钻'),
      ]),
    );
  }

  _item(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

  getData() async {
    final result = await Api.coinDetail(goldOrderId);
    if (result != null) {
      setState(() {
        data = result;
      });
    }
  }
}
