import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/widgets/mybutton.dart';
import 'package:todo_app/presentation/widgets/mysnackbar.dart';
import 'package:todo_app/presentation/widgets/mytextfield.dart';
import 'package:todo_app/shared/constants/strings.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/shared/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

class forgorPage extends StatefulWidget {
  const forgorPage({Key? key}) : super(key: key);

  @override
  State<forgorPage> createState() => _forgorPageState();
}

class _forgorPageState extends State<forgorPage> {
  late TextEditingController _emailcontroller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _emailcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Form(
            key: _formKey,
            child: BounceInDown(
              duration: const Duration(milliseconds: 1500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 20.sp,
                          letterSpacing: 2,
                        ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    'Please Enter Email to reset your Password !',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 12.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
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
                    height: 4.h,
                  ),
                  MyButton(
                    color: Colors.deepPurple,
                    width: 80.w,
                    title: 'Reset',
                    func: () async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: _emailcontroller.text)
                            .then((value) => {
                                  MySnackBar.error(
                                      message: 'Email Sent',
                                      color: Colors.green,
                                      context: context),
                                });
                      } catch (e) {
                        debugPrint(e.toString());
                        MySnackBar.error(
                            message: e.toString(),
                            color: Colors.red,
                            context: context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
