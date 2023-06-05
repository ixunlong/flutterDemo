import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sports/view/expert/expert_list_item.dart';

import '../res/colours.dart';
import '../view/loading/loading_expert_list.dart';
import 'no_data_widget.dart';

class LoadingCheckWidget<T> extends StatelessWidget{
  const LoadingCheckWidget({
    super.key,
    required this.isLoading,
    required this.child,
    required this.data,
    this.noData = const NoDataWidget(),
    this.loading = const LoadingExpertWidget()
  });

  final dynamic data;
  final Widget noData;
  final Widget loading;
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return SingleChildScrollView(child: loading);
    }else{
      if(data != "escape"){
        if(T == String){
          if(data == null || data == ''){
            return noData;
          }else{
            return child;
          }
        }else if(T == int){
          if(data == null || data == 0){
            return noData;
          }else{
            return child;
          }
        }else if(T == bool){
          if(data) {
            return noData;
          }else{
            return child;
          }
        }
      }
      return child;
    }
  }
}