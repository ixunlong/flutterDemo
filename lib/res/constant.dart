class Constant {
  static const String agreePrivacy = 'agreePrivacy';

  //注销协议
  static const accountCancellationUrl =
      "https://api.qiuxiangbiao.com/mp/h5/accountCancellation.html";
  //服务协议
  static const serviceAgreementUrl =
      "https://api.qiuxiangbiao.com/mp/h5/serviceAgreement.html";
  // "http://121.199.40.181/mgr/serviceAgreement.html";
  //隐私协议
  static const privacyPolicyUrl =
      "https://api.qiuxiangbiao.com/mp/h5/privacyPolicy.html";
  //自媒体协议
  static const selfmediaPolicyUrl =
      "https://api.qiuxiangbiao.com/mp/h5/selfmediaPolicy.html";
  //未成年协议
  static const less18PolicyUrl =
      "https://api.qiuxiangbiao.com/mp/h5/less18Policy.html";
  //交易协议
  static const payPolicyUrl =
      "https://api.qiuxiangbiao.com/mp/h5/payPolicy.html";

  //暂无 使用隐私协议暂代
  static String get contentTradeAgreementUrl => privacyPolicyUrl;

  static const wxCorpId = "wwdcd535ec00a4b23a";
  static const wxServUrl =
      "https://work.weixin.qq.com/kfid/kfc2e78be0c7040ec65";
  static const String matchFilterTagAll = 'matchFilterTagAll';
  static const String matchFilterTagBegin = 'matchFilterTagBegin';
  static const String matchFilterTagSchedule = 'matchFilterTagSchedule';
  static const String matchFilterTagResult = 'matchFilterTagResult';
  static const String matchFilterTagFocus = 'matchFilterTagFocus';

  static const devBaseUrl = 'http://dev.qiuxiangbiao.com/api';
  static const testBaseUrl = "http://test.qiuxiangbiao.com/api";
  // static const prodBaseUrl = "https://api.qiuxiangbiao.com";
  static const prodBaseUrl = "http://121.41.97.74";
  static const red_testBaseUrl = "http://121.40.82.52:8001";
  static const red_prodBaseUrl = "https://api.hongqiuhui.com";

  static const String saikuang = '直播';
  static const String zhenrong = '阵容';
  static const String shangjin = '伤禁';
  static const String tongji = '统计';
  static const String shuju = '数据';
  static const String guandian = '方案';
  static const String qingbao = '情报';
  static const String zhishu = '指数';
}
