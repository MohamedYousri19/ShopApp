import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Modules/ShopApp/LoginScreen/cubit/Cubit.dart';
import 'package:shop_app/Modules/ShopApp/LoginScreen/cubit/states.dart';

import '../../../LayOut/ShopLayout/ShopLayout.dart';
import '../../../Network/Local/Cach_Helper.dart';
import '../../../Shared/Components/Components.dart';
import '../../../Shared/Components/Constants.dart';
import '../RegisterScreen/RegisterScreen.dart';


class ShopLogin extends StatelessWidget {
  const ShopLogin({super.key});
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>() ;
    var _emailController = TextEditingController() ;
    var _passwordController = TextEditingController() ;
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginState>(
          listener: (context , state) {
            if(state is ShopLoginSuccessState){
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
                        builder: (context) => const ShopLayOut()),
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
            if(state is ShopLoginErrorState){
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
          },
          builder: (context,state){return Scaffold(
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
                        Text('LOGIN' , style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 15.0,),
                        Text('Login now to browse our hot offers' , style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),),
                        const SizedBox(height: 20.0,),
                        default_TextField(
                          titleController: _emailController,
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
                            titleController: _passwordController,
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
                                  ShopLoginCubit.get(context).hidden() ;
                                },
                                icon: Icon(ShopLoginCubit.get(context).IconPassword),
                            ),
                          submit: (value){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text
                              );
                            }
                          },
                          isShow: ShopLoginCubit.get(context).isShow,
                        ),
                        const SizedBox(height: 30.0,),
                        ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => defaulButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                      email: _emailController.text,
                                      password: _passwordController.text
                                  );
                                }
                              },
                              name: 'LOGIN',
                            ),
                            fallback: (context) => const Center(child: CircularProgressIndicator(),)
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          children: [
                            const Text('Don\'t have an account?' ),
                            defaultTextButton(
                                text: 'Register Now',
                                pressed: (){
                                  NavigateAndFinish(context, const RegisterScreen()) ;
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
          );},
      )
    );
  }
}
