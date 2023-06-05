class BbUtils {

  static String? periodOf(int n,{int t = 4}) {
    final periods = t == 4 ? {
      1:'第一节',
      2:'第二节',
      3:'第三节',
      4:'第四节'
    }: {
      1:'上半场',
      2:'下半场'
    };
    return periods[n];
  }


}