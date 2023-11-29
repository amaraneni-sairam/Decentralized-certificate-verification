import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blockchain/presentation/widgets/mybutton.dart';
import 'package:blockchain/presentation/widgets/mysnackbar.dart';
import 'package:blockchain/presentation/widgets/mytextfield.dart';
import 'package:blockchain/shared/styles/colors.dart';
import 'package:blockchain/shared/validators.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:blockchain/globals.dart' as globals;

class uploadPage extends StatefulWidget {
  const uploadPage({Key? key}) : super(key: key);

  @override
  State<uploadPage> createState() => _uploadState();
}

class _uploadState extends State<uploadPage> {
  CollectionReference certificates =
      FirebaseFirestore.instance.collection('certificates');
  late TextEditingController _uniqueIdController;
  late TextEditingController _typecontroller;
  final _formKey = GlobalKey<FormState>();
  String? cnum;
  String? ctype;
  String? clink;
  @override
  void initState() {
    super.initState();
    _uniqueIdController = TextEditingController();
    _typecontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _uniqueIdController.dispose();
    _typecontroller.dispose();
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
                      'Upload !',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 20.sp,
                            letterSpacing: 2,
                          ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MyTextfield(
                      hint: 'uniqueId No. of Student',
                      icon: Icons.text_fields,
                      keyboardtype: TextInputType.text,
                      validator: (value) {
                        cnum = value;
                      },
                      textEditingController: _uniqueIdController,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    MyTextfield(
                      hint: 'Type of Certificate',
                      icon: Icons.credit_card_outlined,
                      keyboardtype: TextInputType.text,
                      validator: (value) {
                        ctype = value;
                      },
                      textEditingController: _typecontroller,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        QuerySnapshot uniqueId = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .where("roll", isEqualTo: _uniqueIdController.text)
                            .get();
                        if (uniqueId.docs.isNotEmpty) {
                          await ImagePickerService.pickImage(context);
                          await certificates
                              .add({
                                'num': cnum, // John Doe
                                'type': ctype, // Stokes and Sons
                                'link': "https://ipfs.io/ipfs/" +
                                    globals.link.toString() // 42
                              })
                              .then((value) => print("Certificate Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                          MySnackBar.error(
                              message: 'Certificate Added Successfully',
                              color: Colors.green,
                              context: context);
                        } else {
                          MySnackBar.error(
                              message: 'Entered uniqueId Number does not Exist',
                              color: Colors.red,
                              context: context);

                          return;
                        }
                      },
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Upload Image',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand-Bold'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));

    return Container();
  }
}

class ImagePickerService {
//PICKER
  static Future<XFile?> pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      //Nothing picked
      if (image == null) {
        Fluttertoast.showToast(
          msg: 'No Image Selected',
        );
        return null;
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => ProgressDialog(
            status: 'Uploading to IPFS',
          ),
        );

        // upload image to ipfs
        await FlutterIpfs()
            .uploadToIpfs(image.path)
            .then((value) => {debugPrint(value), globals.link = value});

        // Popping out the dialog box
        Navigator.pop(context);

        //Return Path
        return image;
      }
    } catch (e) {
      debugPrint('Error at image picker: $e');
      SnackBar(
        content: Text(
          'Error at image picker: $e',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      );
      return null;
    }
  }
}
