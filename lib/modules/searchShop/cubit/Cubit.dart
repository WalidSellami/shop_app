
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/searchModel/SearchModel.dart';
import 'package:shop/modules/searchShop/cubit/States.dart';
import 'package:shop/shared/components/Constants.dart';
import 'package:shop/shared/network/EndPoint.dart';
import 'package:shop/shared/network/remot/DioHelper.dart';

class SearchCubit extends Cubit<SearchStates> {

  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String text){
    emit(LoadingSearchState());
    DioHelper.postData(
        url: SEARCH,
        data: {
          'text' : text,
        },
        token: token,
        ).then((value) {

          searchModel = SearchModel.fromJson(value?.data);
          emit(SuccessSearchState());

    }).catchError((error){
      print(error.toString());
      emit(ErrorSearchState(error));
    });
  }

  var controller = TextEditingController();

  changesOnField(){
    emit(ChangesOnFieldSearchState());
  }

  void listen(){
    controller.addListener(() {
      changesOnField();
    });
  }

  void clearSearch(){
    searchModel = null;
    controller.text = '';
    emit(ClearSearchState());
  }

}