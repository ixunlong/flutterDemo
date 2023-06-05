import '../../model/expert/expert_views_entity.dart';

class ExpertLoadItems{
  List<Rows> items;
  int total;
  int page;
  int pageSize;

  ExpertLoadItems(
      this.items,
      this.total,
      this.page,
      this.pageSize
      );

}