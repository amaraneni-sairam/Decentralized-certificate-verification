import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:blockchain_certify/bloc/auth/authentication_cubit.dart';
import 'package:blockchain_certify/bloc/connectivity/connectivity_cubit.dart';
import 'package:blockchain_certify/presentation/widgets/mybutton.dart';
import 'package:blockchain_certify/presentation/widgets/myindicator.dart';
import 'package:blockchain_certify/presentation/widgets/mysnackbar.dart';
import 'package:blockchain_certify/presentation/widgets/mytextfield.dart';
import 'package:blockchain_certify/shared/constants/assets_path.dart';
import 'package:blockchain_certify/shared/constants/strings.dart';
import 'package:blockchain_certify/shared/styles/colors.dart';
import 'package:blockchain_certify/shared/validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namecontroller;
  late TextEditingController _rollcontroller;
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;

  @override
  void initState() {
    super.initState();
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _rollcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _rollcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authcubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        backgroundColor: Appcolors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Appcolors.black,
            size: 30,
          ),
        ),
      ),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationErrortate) {
            // Showing the error message if the user has entered invalid credentials
            MySnackBar.error(
                message: state.error.toString(),
                color: Colors.red,
                context: context);
          }

          if (state is AuthenticationSuccessState) {
            Navigator.pushReplacementNamed(context, homepage);
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoadingState) {
            return const MyCircularIndicator();
          }
          if (state is! AuthenticationSuccessState) {
            return SafeArea(
                child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: BounceInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heey !',
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 20.sp,
                                    letterSpacing: 2,
                                  ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          'Create a New Account !',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  fontSize: 12.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        MyTextfield(
                          hint: 'Full Name',
                          icon: Icons.person,
                          keyboardtype: TextInputType.name,
                          validator: (value) {
                            return value!.length < 3 ? 'Unvalid Name' : null;
                          },
                          textEditingController: _namecontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Student Unique Id.',
                          icon: Icons.person,
                          keyboardtype: TextInputType.name,
                          validator: (value) {
                            return value!.length < 12
                                ? 'Unvalid aadhar num'
                                : null;
                          },
                          textEditingController: _rollcontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Email Address',
                          icon: Icons.email,
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            return !Validators.isValidEmail(value!)
                                ? 'Enter a valid email'
                                : null;
                          },
                          textEditingController: _emailcontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Password',
                          icon: Icons.password,
                          obscure: true,
                          keyboardtype: TextInputType.text,
                          validator: (value) {
                            return value!.length < 6
                                ? "Enter min. 6 characters"
                                : null;
                          },
                          textEditingController: _passwordcontroller,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        MyButton(
                            color: Colors.deepPurple,
                            width: 80.w,
                            title: 'Sign Up',
                            func: () async {
                              QuerySnapshot aadhar = await FirebaseFirestore
                                  .instance
                                  .collection('valids')
                                  .where("num", isEqualTo: _rollcontroller.text)
                                  .get();
                              if (aadhar.docs.isNotEmpty) {
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where("roll",
                                        isEqualTo: _rollcontroller.text)
                                    .get();

                                if (snap.docs.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "User with entered aadhar already exists")));
                                  return;
                                } else {
                                  debugPrint("no dataaaaaaa");
                                  if (connectivitycubit.state
                                      is ConnectivityOnlineState) {
                                    _signupewithemailandpass(
                                        context, authcubit);
                                  } else {
                                    MySnackBar.error(
                                        message:
                                            'Please Check Your Internet Conection',
                                        color: Colors.red,
                                        context: context);
                                  }
                                }
                              } else {
                                MySnackBar.error(
                                    message: 'Please Enter Valid Aadhar Number',
                                    color: Colors.red,
                                    context: context);
                              }
                            }),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an Account ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, loginpage);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 9.sp,
                                      color: Colors.deepPurple,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          }
          return Container();
        },
      ),
    );
  }

  Container _myDivider() {
    return Container(
      width: 27.w,
      height: 0.2.h,
      color: Appcolors.black,
    );
  }

  void _signupewithemailandpass(context, AuthenticationCubit cubit) {
    if (_formKey.currentState!.validate()) {
      cubit.register(
          fullname: _namecontroller.text,
          email: _emailcontroller.text,
          password: _passwordcontroller.text,
          roll: _rollcontroller.text);
    }
  }
}