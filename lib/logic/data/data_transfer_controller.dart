import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/data/data_season_controller.dart';
import 'package:sports/model/data_transfer_entity.dart';

class DataTransferController extends GetxController {
  final String? seasonTag;
  DataTransferController(this.leagueId, this.seasonTag);

  bool visible = false;
  int leagueId;
  late DataSeasonController seasonC;

  DataTransferEntity? resultData;
  List<String>? left;
  List<Transfers>? transferList;
  List<Transfers>? showTransfer;

  int structIndex = 0;

  @override
  void onInit() {
    super.onInit();
    seasonC = Get.find<DataSeasonController>(tag: seasonTag);
    var currentSeason = seasonC.currentSeason;
    seasonC.addListener(() {
      if (currentSeason != seasonC.currentSeason) {
        getData();
        currentSeason = seasonC.currentSeason;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    getData();
  }

  getData() async {
    // final result = await Api.getDataTransfer(leagueId, seasonC.currentSeason);
    final result = await Api.getDataTransfer(leagueId, seasonC.currentSeason);
    if (result != null) {
      resultData = result;
      left = [];
      left!.addAll(result.periods!.map((e) => e.value!).toList());
      left!.addAll(result.teams!.map((e) => e.nameChs!).toList());
      transferList = result.transfers;
      getPlayer();
    }
  }

  onSelectStruct(int index) {
    if (structIndex != index) {
      structIndex = index;
      update();
      getPlayer();
    }
  }

  getPlayer() {
    showTransfer = [];
    if (structIndex < resultData!.periods!.length) {
      for (final transfer in transferList!) {
        if (transfer.transferPeriod ==
            resultData!.periods![structIndex].key.toString()) {
          showTransfer!.add(transfer);
        }
      }
    } else {
      for (final transfer in transferList!) {
        int? teamId = resultData!
            .teams![structIndex - resultData!.periods!.length].teamId;
        if (transfer.toTeamId == teamId || transfer.fromTeamId == teamId) {
          showTransfer!.add(transfer);
        }
      }
    }
    showTransfer?.sort((a, b) {
      final moneya = double.tryParse(a.money ?? "") ?? 0;
      final moneyb = double.tryParse(b.money ?? "") ?? 0;
      final r1 = moneyb.compareTo(moneya);
      if (r1 != 0) { return r1; }
      final timea = DateTime.tryParse(a.transferTime ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
      final timeb = DateTime.tryParse(b.transferTime ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
      return timeb.compareTo(timea);
    });
    // log("${showTransfer?.map((e) => e.toJson())}");
    update();
  }
}
