import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class BasePage extends StatelessWidget{
  const BasePage({super.key});

  GetxController get controller;
  String? get tag => null;
  Widget buildWidget();
  void initState();
  void didUpdateWidget(){return;}
  void didChangeDependencies(){return;}
  void dispose(){return;}

  @override
  Widget build(BuildContext context) {

    return GetBuilder(
      init: controller,
      tag: tag,
      didUpdateWidget: (getBuilder,getBuilderState) => didUpdateWidget,
      didChangeDependencies: (getBuilderState) => didChangeDependencies,
      dispose: (getBuilderState) => dispose,
      initState: (state){
        initState();
      },

      builder: (controller){
        return buildWidget();
      }
    );
  }

}