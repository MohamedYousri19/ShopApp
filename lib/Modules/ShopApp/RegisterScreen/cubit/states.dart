
import '../../../../Models/ShopApp/login_model.dart';

abstract class ShopRegisterState {}

class ShopRegisterInitialState extends ShopRegisterState {}

class ShopRegisterLoadingState extends ShopRegisterState {}
class ShopRegisterSuccessState extends ShopRegisterState {
  final ShopLoginModel loginModel ;
  ShopRegisterSuccessState(this.loginModel);
}
class ShopRegisterErrorState extends ShopRegisterState {
  final String error ;
  final ShopLoginModel loginModel ;
  ShopRegisterErrorState(this.error, this.loginModel);
}

class ShopRegisterChangeState extends ShopRegisterState {}
