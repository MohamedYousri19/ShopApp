
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../LayOut/ShopLayout/cubit/cubit.dart';
import '../../../LayOut/ShopLayout/cubit/states.dart';
import '../../../Models/ShopApp/Categories.dart';
import '../../../Models/ShopApp/HomeModele.dart';
import '../../../Shared/Components/Components.dart';
import '../../../Shared/styles/colors.dart';


class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return  BlocConsumer<ShopCubit,ShopStates>(
          listener: (context,state){
            if(state is ShopSuccessChangeFavoritesState){
              if(!state.model.status!){
                ShowToast(text: state.model.message!, backgroundColor: Colors.red) ;
              }
            }
          },
          builder: (context , state) {
           var cubit = ShopCubit.get(context) ;
            return ConditionalBuilder(
                condition: cubit.homeModel != null && cubit.categoriesModel != null  ,
                builder:  (context) => productsBuilder(cubit.homeModel , cubit.categoriesModel , context),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
            );
          }
      );
  }

  Widget productsBuilder(HomeModel? model , CategoriesModel? categoriesModel , context) => RefreshIndicator(
    onRefresh: () async {
      ShopCubit.get(context).getHomeData() ;
      ShopCubit.get(context).getCategoriesData() ;
    },
    backgroundColor: Colors.white,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CarouselSlider(
            items: model?.data?.banners.map((e) => Image(
              image: NetworkImage('${e.image}'),
              width: double.infinity,
              fit: BoxFit.cover,
            )).toList(),
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds:3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,

            ),
          ),
          const SizedBox(height: 5.0,),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories' , style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 25.0, fontWeight: FontWeight.w800 ,)),
                const SizedBox(height: 10.0,),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoriesItem(categoriesModel.data!.data![index] ) ,
                      separatorBuilder: (context, index) => const SizedBox(width: 10.0,),
                      itemCount: categoriesModel!.data!.data!.length,
                  ),
                ),
                const SizedBox(height: 20.0,),
                 Text('New Products' , style:Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800,fontSize: 25.0 , color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0 , vertical: 10.0),
            color: Theme.of(context).primaryColorDark,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 1 / 1.9,
              children: List.generate(
                  model!.data!.products.length,
                      (index) => gridBuilder(model.data!.products[index]
                          , context)
              ),
            ),
          )
        ],
      ),
    ),
  );
  Widget buildCategoriesItem(DataModel model) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Image(image: NetworkImage('${model.image}'),
          fit: BoxFit.cover,
          height: 100.0,
          width: 100.0,
        ),
      ),
      Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: const BorderRadiusDirectional.only(bottomEnd: Radius.circular(15.0), bottomStart: Radius.circular(15.0))
          ),
          width: 100,
          child: Text(
            '${model.name}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,


          )
      ),
    ],
  );

  Widget gridBuilder(ProductModel model , context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Theme.of(context).primaryColorLight,
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
           Stack(
             alignment: AlignmentDirectional.bottomStart,
             children: [
               Image(
                 image: NetworkImage(model.image.toString()),
                 width: double.infinity,
                 height: 200.0,
               ),
               if(model.discount != 0)
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
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(model.name.toString(),style: Theme.of(context).textTheme.bodyMedium,maxLines: 2, overflow: TextOverflow.ellipsis,),
                 Row(children: [
                   Text('${model.price.round()}',style: const TextStyle(
                     color: defaultColor,
                   ),maxLines: 2, overflow: TextOverflow.ellipsis,),
                   const SizedBox(width: 10.0,),
                   model.discount != 0 ? Text('${model.oldPrice.round()}',style: const TextStyle(
                     color: Colors.grey,
                     decoration: TextDecoration.lineThrough,
                   ),maxLines: 2, overflow: TextOverflow.ellipsis,):
                       Container(),
                   const Spacer(),
                   IconButton(
                     padding: EdgeInsets.zero,
                       onPressed: (){
                       ShopCubit.get(context).changeFavorites(model.id!) ;
                       },
                       icon:  Icon(
                           Icons.favorite,
                         size: 20.0,
                         color: ShopCubit.get(context).favorites[model.id]! ? Colors.red : Colors.grey ,
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
