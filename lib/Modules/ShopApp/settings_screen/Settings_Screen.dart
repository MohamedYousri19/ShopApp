import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../LayOut/ShopLayout/cubit/cubit.dart';
import '../../../LayOut/ShopLayout/cubit/states.dart';
import '../../../Shared/Components/Components.dart';
import '../../../Shared/Components/Constants.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>() ;
    return  BlocConsumer<ShopCubit,ShopStates>(
      builder: (BuildContext context, state) {
        var nameController = TextEditingController() ;
        var emailController = TextEditingController() ;
        var phoneController  = TextEditingController() ;
        var cubit = ShopCubit.get(context) ;
        if(cubit.userModel != null){
          nameController.text =  cubit.userModel!.data!.name! ;
          emailController.text = cubit.userModel!.data!.email! ;
          phoneController.text = cubit.userModel!.data!.phone! ;
        }else{}
        return ConditionalBuilder(
            condition: cubit.userModel != null ,
            builder: (context)=> SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingGetUserState)
                      const LinearProgressIndicator(),
                      const SizedBox(height: 20.0,),
                      default_TextField(
                          titleController: nameController,
                          labelText: 'Name',
                          valdate: (String value){
                            if(value.isEmpty){
                              return 'Name Must Not be Empty' ;
                            }
                          },
                          prefixIcon: Icons.person,
                          isShow: false,
                          type: TextInputType.name
                      ),
                      const SizedBox(height: 20.0,),
                      default_TextField(
                          titleController: emailController,
                          labelText: 'Email',
                          valdate: (String value){
                            if(value.isEmpty){
                              return 'Email Must Not be Empty' ;
                            }
                          },
                          prefixIcon: Icons.email_rounded,
                          isShow: false,
                          type: TextInputType.emailAddress
                      ),
                      const SizedBox(height: 20.0,),
                      default_TextField(
                          titleController: phoneController,
                          labelText: 'Phone',
                          valdate: (String value){
                            if(value.isEmpty){
                              return 'Phone Must Not be Empty' ;
                            }
                          },
                          prefixIcon: Icons.phone,
                          isShow: false,
                          type: TextInputType.phone
                      ),
                      const SizedBox(height: 20.0,),
                      defaulButton(
                          function: (){
                            if(formKey.currentState!.validate()){
                              ShopCubit.get(context).updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          name: 'UPDATE'
                      ),
                      const SizedBox(height: 20.0,),
                      defaulButton(
                          function: (){
                            SignOut(context);
                          },
                          name: 'LOGOUT'
                      )
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context)=> const Center(child: CircularProgressIndicator()),
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}