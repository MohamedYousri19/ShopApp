

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Network/Local/Cach_Helper.dart';
import '../../../Shared/Components/Components.dart';
import '../../../Shared/Components/Constants.dart';
import '../../../layout/ShopLayout/ShopLayout.dart';
import '../LoginScreen/ShopLoginScreen.dart';
import 'cubit/Cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>() ;
    var emailController = TextEditingController() ;
    var passwordController = TextEditingController() ;
    var nameController = TextEditingController() ;
    var phoneController = TextEditingController() ;
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterState>(
          builder: (context,state) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REGISTER' , style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
                          const SizedBox(height: 15.0,),
                          Text('Register now to browse our hot offers' , style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),),
                          const SizedBox(height: 20.0,),
                          default_TextField(
                            titleController: nameController,
                            hintText: 'Name',
                            valdate: (String value){
                              if(value.isEmpty){
                                return'Name must not be em` pty';
                              }
                            },
                            prefixIcon: Icons.person,
                            type: TextInputType.name,
                            isShow: false,
                          ),
                          const SizedBox(height: 20.0,),
                          default_TextField(
                            titleController: emailController,
                            hintText: 'Email Address',
                            valdate: (String value){
                              if(value.isEmpty){
                                return'email must not be empty';
                              }
                            },
                            prefixIcon: Icons.email_outlined,
                            type: TextInputType.emailAddress,
                            isShow: false,
                          ),
                          const SizedBox(height: 20.0,),
                          default_TextField(
                            titleController: passwordController,
                            hintText: 'Password',
                            valdate: (String value){
                              if(value.isEmpty){
                                return'Password is too short';
                              }
                            },
                            prefixIcon: Icons.lock_outline,
                            type: TextInputType.visiblePassword,
                            suffixIconIcon: IconButton(
                              onPressed: (){
                                ShopRegisterCubit.get(context).hidden() ;
                              },
                              icon: Icon(ShopRegisterCubit.get(context).iconPassword),
                            ),
                            submit: (value){
                              if(formKey.currentState!.validate()){
                                ShopRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text
                                );
                              }
                            },
                            isShow: ShopRegisterCubit.get(context).isShow,
                          ),
                          const SizedBox(height: 30.0,),
                          default_TextField(
                            titleController: phoneController,
                            hintText: 'Phone',
                            valdate: (String value){
                              if(value.isEmpty){
                                return'Phone must not be empty';
                              }
                            },
                            prefixIcon: Icons.phone,
                            type: TextInputType.phone,
                            isShow: false,
                          ),
                          const SizedBox(height: 20.0,),
                          ConditionalBuilder(
                              condition: true,
                              builder: (context) => defaulButton(
                                function: (){
                                  if(formKey.currentState!.validate()){
                                    ShopRegisterCubit.get(context).userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text ,
                                        phone: phoneController.text
                                    );
                                  }
                                },
                                name: 'REGISTER',
                              ),
                              fallback: (context) => const Center(child: CircularProgressIndicator(),)
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            children: [
                              const Text('Do You have an account?' ),
                              defaultTextButton(
                                  text: 'LOGIN NOW',
                                  pressed: (){
                                    NavigateAndFinish(context, const ShopLogin()) ;
                                  }
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context,state) {
            if(state is ShopRegisterSuccessState){
              if(state.loginModel.status == true){
                print(state.loginModel.message) ;
                print(state.loginModel.data?.token) ;

                ShowToast(
                  text: '${state.loginModel.message}',
                  backgroundColor: Colors.green,
                );
                CachHelper.saveData(key: 'token', value: state.loginModel.data!.token ).then(
                        (value) => {
                      token = state.loginModel.data!.token ,
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                          builder: (context) => ShopLayOut()),
                              (route) => false)
                    }
                );
              }else{
                print('state.loginModel.message') ;
                print(state.loginModel.message) ;
                print(state.loginModel.status) ;

                ShowToast(
                  text: '${state.loginModel.message}',
                  backgroundColor: Colors.red,
                );
              }
            }
            if(state is ShopRegisterErrorState){
              if(state.loginModel.status == false){
                print(state.loginModel.message) ;
                Fluttertoast.showToast(
                    msg: '${state.loginModel.message}',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              }
            }
          }
      )
    );
  }
}
