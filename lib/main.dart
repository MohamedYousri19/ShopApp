import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/LayOut/ShopLayout/ShopLayout.dart';
import 'package:shop_app/LayOut/ShopLayout/cubit/states.dart';
import 'package:shop_app/Modules/ShopApp/LoginScreen/ShopLoginScreen.dart';
import 'package:shop_app/Modules/ShopApp/OnBoardingScreen/OnBoardingScreen.dart';
import 'package:shop_app/Shared/styles/Themes.dart';
import 'LayOut/ShopLayout/cubit/cubit.dart';
import 'Network/Local/Cach_Helper.dart';
import 'Network/Remote/dio_helper.dart';
import 'Shared/Components/Constants.dart';
import 'Shared/bolck_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();
  Widget? widget ;
  token = CachHelper.getData(key: 'token');
  dynamic onBoarding = CachHelper.getData(key: 'onBoarding');
  if(onBoarding != null){
    if(token != null){
      widget = const ShopLayOut() ;
    }else{
      widget = const ShopLogin();
    }
  }else{
    widget = const OnBoardingScreen() ;
  }

  runApp( MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget ;
  const MyApp({super.key, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getHomeData()..getCategoriesData(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:lightTheme,
            darkTheme: darkTheme ,
            themeMode: ShopCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark  ,
            home: startWidget ,
          );
        },
        listener: (BuildContext context, Object? state) {},
      ),
    );
  }
}

