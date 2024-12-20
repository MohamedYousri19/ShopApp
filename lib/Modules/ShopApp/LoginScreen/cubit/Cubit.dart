import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/ShopApp/LoginScreen/cubit/states.dart';
import '../../../../Models/ShopApp/login_model.dart';
import '../../../../Network/Remote/dio_helper.dart';
import '../../../../Network/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginState>
{
  ShopLoginCubit() : super (ShopLoginInitialState()) ;
  static ShopLoginCubit get(context) => BlocProvider.of(context) ;
  ShopLoginModel? loginModel ;
  void userLogin({
    required String email,
    required String password,
}){
    emit(ShopLoginLoadingState()) ;
    DioHelper.postData(url: LOGIN, data:{
      'email':email,
      'password':password,
    }).then((value) => {
      loginModel = ShopLoginModel.fromJson(value.data) ,
      print('loginModel!.status') ,
      print(loginModel!.status) ,
      print(loginModel!.message) ,
      print(loginModel!.data!.token) ,
      emit(ShopLoginSuccessState(loginModel!)),
    }).catchError((error){
      emit(ShopLoginErrorState(error.toString(),loginModel!));
    }) ;
  }
  var isShow = true ;
  IconData IconPassword = Icons.visibility ;
  void hidden(){
    isShow = !isShow ;
    if(isShow == true){
      IconPassword = Icons.visibility ;
    }else{
      IconPassword = Icons.visibility_off ;
    }
    emit(ShopLoginChangeState()) ;
  }
}