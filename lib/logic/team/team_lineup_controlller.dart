import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/team/team_lineup_entity.dart';

class TeamLineupController extends GetxController{
  List itemList = ["主教练","前锋","中场","后场","门将"];
  bool isLoading = true;
  List<TeamLineupEntity> _data = [];

  List<TeamLineupEntity> get data => _data;

  Future requestData(int teamId) async{
    _data = await Api.getTeamLineup(teamId);
    isLoading = false;
    update();
  }
}