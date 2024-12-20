import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/ShopApp/FavoritesModele.dart';
import '../../../LayOut/ShopLayout/cubit/cubit.dart';
import '../../../LayOut/ShopLayout/cubit/states.dart';
import '../../../Shared/Components/Components.dart';
import '../../../Shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      builder: (BuildContext context, state) {
        return ConditionalBuilder(
          condition:  ShopCubit.get(context).favoritesModel != null && ShopCubit.get(context).favorites[ShopCubit.get(context).favoritesModel!.data!.data?[0].product!.id] != null ,
          builder: (context) => ListView.separated(
              itemBuilder: (context,index) => favoritesItem(ShopCubit.get(context).favoritesModel!.data!.data![index],context),
              separatorBuilder: (context , index) =>line(),
              itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length
          ),
          fallback: (context)  => const Center(child:  CircularProgressIndicator()),
        ) ;
      },
      listener: (BuildContext context, Object? state) {},
    ) ;
  }
  Widget favoritesItem(DataModel model , context) =>  Padding(
    padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            height: 140.0,
            width: 140.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                     Image(
                      image: NetworkImage('${model.product!.image}'),
                      width:120.0,
                      height: 120.0,
                    ),
                    if(model.product!.discount != 0)
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(5.0) , bottomEnd: Radius.circular(5.0)),
                          color: Colors.red,
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0 ),
                        child: const Text('Discount' , style: TextStyle(fontSize: 12.0 , color: Colors.white),),
                      )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model.product!.name}',style: const TextStyle(
                  height: 1.3,
                ),maxLines: 2, overflow: TextOverflow.ellipsis,),
                Row(children: [
                  Text('${model.product!.price.round()}',style: const TextStyle(
                    color: defaultColor,
                  ),maxLines: 2, overflow: TextOverflow.ellipsis,),
                  const SizedBox(width: 10.0,),
                  model.product!.discount != 0 ? Text('${model.product!.old_price.round()}',style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),maxLines: 2, overflow: TextOverflow.ellipsis,):
                  Container(),
                  const Spacer(),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        ShopCubit.get(context).changeFavorites(model.product!.id!) ;
                      },
                      icon:  Icon(
                        Icons.favorite,
                        size: 20.0,
                        color: ShopCubit.get(context).favorites[model.product!.id]! ? Colors.red : Colors.grey ,
                      )
                  )
                ],
                ),
              ],
            ),
          )
        ],
      ),
  );
}