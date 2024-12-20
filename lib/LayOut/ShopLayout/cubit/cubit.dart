import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/LayOut/ShopLayout/cubit/states.dart';

import '../../../Models/ShopApp/Categories.dart';
import '../../../Models/ShopApp/ChangeFavoritesModel.dart';
import '../../../Models/ShopApp/FavoritesModele.dart';
import '../../../Models/ShopApp/HomeModele.dart';
import '../../../Models/ShopApp/UserModel.dart';
import '../../../Modules/ShopApp/Products_screen/Products_screen.dart';
import '../../../Modules/ShopApp/cateogries_screen/Cateogries_screen.dart';
import '../../../Modules/ShopApp/favorites_screen/Favorite_screen.dart';
import '../../../Modules/ShopApp/settings_screen/Settings_Screen.dart';
import '../../../Network/Local/Cach_Helper.dart';
import '../../../Network/Remote/dio_helper.dart';
import '../../../Network/end_points.dart';
import '../../../Shared/Components/Constants.dart';




class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super (ShopInitialStates());

  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CateogriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    if (currentIndex == 2) getFavoritesData();
    if (currentIndex == 3) getUserData();
    emit(ShopChangeBottomNavStates());
  }

  HomeModel? homeModel;

  Map<int?, bool?> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) =>
    {
      homeModel = HomeModel.fromJson(value.data),
      printFullText(homeModel!.data!.banners[0].image.toString()),
      print(homeModel?.status),
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites
        });
      }),
      print(favorites),
      emit(ShopSuccessHomeDataState()),
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(url: GET_CATEGORIES, token: token).then((value) =>
    {
      categoriesModel = CategoriesModel.fromJson(value.data),
      emit(ShopSuccessCategoriesState()),
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id': productId
        },
        token: token
    ).then((value) =>
    {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data),

      if(!changeFavoritesModel!.status!){
        favorites[productId] = !favorites[productId]!
      } else
        {
          getFavoritesData()
        },
      print(changeFavoritesModel!.status),
      print(changeFavoritesModel!.message),
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!)),
    }).catchError((error) {
      print(error);
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    DioHelper.getData(url: FAVORITES, token: token).then((value) =>
    {
      favoritesModel = FavoritesModel.fromJson(value.data),
      print(favoritesModel!.data!.data),
      emit(ShopSuccessGetFavoritesState()),
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  UserModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetUserState());
    DioHelper.getData(url: PROFILE, token: token).then((value) =>
    {
      userModel = UserModel.fromJson(value.data),
      emit(ShopSuccessGetUserState()),
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserState());
    });
  }


  void updateUserData({
    String? name,
    String? email,
    String? phone,
  }) {
    emit(ShopLoadingGetUserState());
    DioHelper.putData(url: UPDATEPROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) =>
    {
      userModel = UserModel.fromJson(value.data),
      emit(ShopSuccessGetUserState()),
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserState());
    });
  }

    bool isDark = true;
    void changeAppMode({bool? fromShared}){
      if(fromShared != null ){
        isDark = fromShared ;
      }else{
        isDark = !isDark ;
      }
      print(isDark) ;
      CachHelper.putBoolean(key: 'isDark', value: isDark).then((value) => {
      emit(AppChangeMode()),
      }) ;
    }
}