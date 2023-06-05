
import 'package:sports/http/dio_utils.dart';

class BasketballApi {
  static matchDetail(int id) => DioUtils.post("/basketball/app-basketball-match-do/detail",params: {
    "matchQxbId":id
  });
  static matchDetailHead(int id) => DioUtils.post('/basketball/app-basketball-match-do/head',params: {
    "matchQxbId":id
  });
}