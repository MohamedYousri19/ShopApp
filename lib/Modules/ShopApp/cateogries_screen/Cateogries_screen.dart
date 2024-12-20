import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../LayOut/ShopLayout/cubit/cubit.dart';
import '../../../LayOut/ShopLayout/cubit/states.dart';
import '../../../Models/ShopApp/Categories.dart';
import '../../../Shared/Components/Components.dart';

class CateogriesScreen extends StatelessWidget {
  const CateogriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      builder: (BuildContext context, ShopStates state) {
        var cubit = ShopCubit.get(context) ;
        return ListView.separated(
            itemBuilder: (context,index) => buildCatItem(cubit.categoriesModel!.data!.data![index]),
            separatorBuilder: (context,index) => Column(
              children: [
                const SizedBox(height: 20.0,),
                line(),
                const SizedBox(height: 20.0 ,)
              ],
            ),
            itemCount: cubit.categoriesModel!.data!.data!.length
        ) ;
      },
      listener: (BuildContext context, ShopStates state) { },
    ) ;
  }
  Widget buildCatItem(DataModel model) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(image: NetworkImage('${model.image}'), fit: BoxFit.cover , height: 80.0 , width: 80.0,),
        const SizedBox(width: 10.0,),
        Text('${model.name}' , style: const TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),),
        const Spacer(),
        IconButton(
          onPressed: (){},
          icon: const Icon(
              Icons.keyboard_arrow_right,
            size: 30.0,
          ),
        )
      ],
    ),
  );
}