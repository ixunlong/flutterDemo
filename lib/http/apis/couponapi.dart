import 'dart:developer';

import 'package:sports/http/dio_utils.dart';
import 'package:sports/model/mine/my_coupon_entity.dart';
import 'package:sports/model/use1_coupon_entity.dart';
import 'package:sports/util/user.dart';

class CouponApi {
  //status 
  //0 表示 已过期 或 已使用 的券
  //1 表示 可使用 或 待生效 的券
  Future<List<MyCouponEntity>?> myCoupons({int status = 1}) async {
    try {
      final response = await DioUtils.post(
        "/user/usr-coupon-do/myCouponList",
        params: {
          "status":status,
          "userId":User.auth?.userId
        });
      return (response.data['d'] as List).map((e) => MyCouponEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  //gold 优惠前价格
  //scene 1 购买方案
  //otherId 购买方案传专家id
  Future<List<Use1CouponEntity>?> use1Coupons({required double gold,required String otherId, int scene = 1}) async {
    try {
      final response = await DioUtils.post(
        "/user/usr-coupon-do/canUseCouponList",
        params:  {
          "gold":gold,
          "otherId":otherId,
          "scene":scene,
          "userId":User.auth?.userId
        }
      );
      return (response.data['d'] as List).map((e) => Use1CouponEntity.fromJson(e)).toList();
    } catch (err) {
      log("use1 coupon err $err");
    }
  }

}