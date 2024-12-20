import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/ShopApp/RegisterScreen/cubit/states.dart';

import '../../../../Models/ShopApp/login_model.dart';
import '../../../../Network/Remote/dio_helper.dart';
import '../../../../Network/end_points.dart';


class ShopRegisterCubit extends Cubit<ShopRegisterState>
{
  ShopRegisterCubit() : super (ShopRegisterInitialState()) ;
  static ShopRegisterCubit get(context) => BlocProvider.of(context) ;
  ShopLoginModel? loginModel ;
  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
}){
    emit(ShopRegisterLoadingState()) ;
    DioHelper.postData(url: REGISTER, data:{
      'email':email,
      'password':password,
      'name':name,
      'phone':phone,
    }).then((value) => {
      loginModel = ShopLoginModel.fromJson(value.data) ,
      print('loginModel!.status') ,
      print(loginModel!.status) ,
      print(loginModel!.message) ,
      print(loginModel!.data!.token) ,
      emit(ShopRegisterSuccessState(loginModel!)),
    }).catchError((error){
      emit(ShopRegisterErrorState(error.toString(),loginModel!));
    }) ;
  }
  var isShow = true ;
  IconData iconPassword = Icons.visibility ;
  void hidden(){
    isShow = !isShow ;
    if(isShow == true){
      iconPassword = Icons.visibility ;
    }else{
      iconPassword = Icons.visibility_off ;
    }
    emit(ShopRegisterChangeState()) ;
  }
}