import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/LayOut/ShopLayout/cubit/cubit.dart';
import '../../../Models/ShopApp/SearchModel.dart';
import '../../../Shared/styles/colors.dart';
import '../../../Shared/Components/Components.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';

class Search_Screen1 extends StatelessWidget {
  const Search_Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController() ;
    var formKey = GlobalKey<FormState>() ;
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,searchStates>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Search'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value){
                        SearchCubit.get(context).search(value) ;
                      },
                    ),
                    const SizedBox(height: 20.0,),
                    // defaulButton(
                    //     function: (){
                    //       if(formKey.currentState!.validate()){
                    //         SearchCubit.get(context).search(textController.text) ;
                    //       }
                    //     },
                    //     name: 'Search'
                    // ),
                    SizedBox(height: 10,),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),
                    SizedBox( height: 30.0),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context,index) => buildSearchItem(context, SearchCubit.get(context).model!.data!.data![index] as Product),
                          separatorBuilder: (context,index) => Column(
                            children: [
                              SizedBox(height: 10.0,),
                              line(),
                              SizedBox(height: 10.0,)
                            ],
                          ) ,
                          itemCount: SearchCubit.get(context).model!.data!.data!.length
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
  Widget buildSearchItem(context , Product model) =>  Row(
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
            Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${model.image}'),
                    width:120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  if(model.discount != null)
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
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0)
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 20.0,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${model.name}',style: const TextStyle(
              height: 1.3,
            ),maxLines: 2, overflow: TextOverflow.ellipsis,),
            Row(children: [
              Text('${model.price.round()}',style: const TextStyle(
                color: defaultColor,
              ),maxLines: 2, overflow: TextOverflow.ellipsis,),
              const SizedBox(width: 10.0,),
              model.old_price != null ? Text('${model.old_price.round()}',style: const TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),maxLines: 2, overflow: TextOverflow.ellipsis,):
              Container(),
              const Spacer(),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  icon:  Icon(
                    Icons.favorite,
                    size: 20.0,
                    color: ShopCubit.get(context).favorites[model.id]!  ? Colors.red : Colors.grey   ,
                  )
              )
            ],
            ),
          ],
        ),
      )
    ],
  );
}
