
import '../../../../Models/ShopApp/login_model.dart';

abstract class ShopLoginState {}

class ShopLoginInitialState extends ShopLoginState {}

class ShopLoginLoadingState extends ShopLoginState {}
class ShopLoginSuccessState extends ShopLoginState {
  final ShopLoginModel loginModel ;
  ShopLoginSuccessState(this.loginModel);
}
class ShopLoginErrorState extends ShopLoginState {
  final String error ;
  final ShopLoginModel loginModel ;
  ShopLoginErrorState(this.error, this.loginModel);
}

class ShopLoginChangeState extends ShopLoginState {}
