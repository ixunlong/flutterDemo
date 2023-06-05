import 'package:dio/dio.dart';
import 'package:sports/http/dio_utils.dart';

class NewsComments {
  //评论 回复
  static Future<Response> add(int newsId,String comment,{int? fromId,int? originId}) => DioUtils.post('/info/info-news-comment-do/add',params: {
    'comment':comment,'newsId':newsId,'fromId':fromId,'originId':originId
  });

  //评论列表 
  static Future<Response> list(int newsId,{int? originId,int? type,int page = 1,int size = 20}) => DioUtils.post("/info/info-news-comment-do/list",params: {
    "data": {
      "newsId":newsId,
      "originId":originId,
      "type":type
    },
    "page":page,
    "pageSize":size 
  });

  //删除评论
  static Future<Response> delete(int id) => DioUtils.post("/info/info-news-comment-do/delete",params: {
    "id":id 
  });

  //咨询 1:已读  2:点赞  3:转发  4取消点赞
  static Future<Response> newsSupport(int id,{required int type}) => DioUtils.post("/info/info-news-comment-do/news/support",params: {
    "newsId":id, "type":type
  });

  //评论 1.点赞 2.举报 3.取消点赞
  static Future<Response> support(int id, {required int type,required int newsId,String? comment}) => DioUtils.post("/info/info-news-comment-do/support",params: {
    "id":id,
    "newsId":newsId,
    "comment":comment,
    "type":type
  });
}