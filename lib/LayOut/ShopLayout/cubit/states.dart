import '../../../Models/ShopApp/ChangeFavoritesModel.dart';
import '../../../Models/ShopApp/login_model.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates {}

class ShopChangeBottomNavStates extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState  extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState  extends ShopStates{}

class ShopChangeFavoritesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel model ;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState  extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState  extends ShopStates{}

class ShopLoadingGetUserState extends ShopStates{}

class ShopSuccessGetUserState extends ShopStates{}

class ShopErrorGetUserState  extends ShopStates{}

class ShopUpdateState extends ShopStates {}

class AppChangeMode extends ShopStates {}

class ShopUpdateSuccessState extends ShopStates {
  final ShopLoginModel loginModel ;
  ShopUpdateSuccessState(this.loginModel);
}
class ShopUpdateErrorState extends ShopStates {
  final String error ;
  final ShopLoginModel loginModel ;
  ShopUpdateErrorState(this.error, this.loginModel);
}



