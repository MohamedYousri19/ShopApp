import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/LayOut/ShopLayout/cubit/cubit.dart';
import 'package:shop_app/LayOut/ShopLayout/cubit/states.dart';

import '../../Modules/ShopApp/Search_Screen/Search_screen.dart';




class ShopLayOut extends StatelessWidget {
  const ShopLayOut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      builder: (context, state) {
        var cubit = ShopCubit.get(context) ;
       return Scaffold(
          appBar: AppBar(
            title: const Text('Salla' , style: TextStyle(fontSize: 30),),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Search_Screen1()));
                  },
                  icon: const Icon(Icons.search)
              ),
              IconButton(
                  onPressed: (){
                    ShopCubit.get(context).changeAppMode() ;
                  },
                  icon: const Icon(Icons.brightness_4_outlined))
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
         bottomNavigationBar: BottomNavigationBar(
           onTap: (index){
             cubit.changeBottom(index) ;
           },
             currentIndex: cubit.currentIndex,
             items: const [
               BottomNavigationBarItem(
                   icon:  Icon(CupertinoIcons.home),
                   label: 'Home'
               ),
               BottomNavigationBarItem(
                   icon:  Icon(CupertinoIcons.circle_grid_hex_fill),
                   label: 'Categories'
               ),
               BottomNavigationBarItem(
                   icon:  Icon(CupertinoIcons.heart_fill),
                   label: 'Favorites'
               ),
               BottomNavigationBarItem(
                   icon:  Icon(CupertinoIcons.settings),
                   label: 'Settings'
               ),

             ]
         ),
        );
      },
      listener: (context,  state) {},
    );
  }
}
