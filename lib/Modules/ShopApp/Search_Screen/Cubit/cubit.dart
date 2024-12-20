import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/ShopApp/Search_Screen/Cubit/states.dart';

import '../../../../Models/ShopApp/SearchModel.dart';
import '../../../../Network/Remote/dio_helper.dart';
import '../../../../Network/end_points.dart';
import '../../../../Shared/Components/Constants.dart';



class SearchCubit extends Cubit<searchStates> {
  SearchCubit() : super(SearchIintialState()) ;
  static SearchCubit get(context) => BlocProvider.of(context) ;
  SearchModel? model ;
  Map<int?,bool?> favorites = {} ;
  void search(String text){
    emit(SearchLoadingState()) ;
    DioHelper.postData(url: SEARCH, token: token ,data: {
      'text' : text ,
    }).then((value) => {
      model = SearchModel.fromJson(value.data),
      model!.data!.data!.forEach((element) {
        favorites.addAll({
          element.id : element.in_favorites
        });
      }),
      emit(SearchSuccessState()),
    }).catchError((error){
      print(error) ;
      emit(SearchErrorState());
    });
  }
}