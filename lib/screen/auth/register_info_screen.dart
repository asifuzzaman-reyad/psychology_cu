import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screen/auth/login_screen.dart';
import '/screen/auth/register_screen.dart';
import '/widgets/custom_button.dart';
import './/constants.dart';

class RegisterInfoScreen extends StatefulWidget {
  static const routeName = 'register_info_screen';

  const RegisterInfoScreen({Key? key}) : super(key: key);
  @override
  _RegisterInfoScreenState createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idField = TextEditingController();
  final TextEditingController _verifyField = TextEditingController();
  final TextEditingController _mobileField = TextEditingController();

  String? _selectedBatch;
  String? _selectedHall;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Help center'),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.clear),
                              )
                            ],
                          ),
                          titlePadding: const EdgeInsets.only(left: 16),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                  'Like our page and send a message with your Name, Batch and Student id. We will send code as soon as possible.'),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                  onPressed: () async {
                                    await canLaunch(kFbGroup)
                                        ? await launch(kFbGroup)
                                        : throw 'Could not launch $kFbGroup';
                                  },
                                  icon: const Icon(Icons.facebook,
                                      color: Colors.blue),
                                  label: const Text('Get Code with Facebook')),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          height: 1, color: Colors.grey)),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('OR'),
                                  ),
                                  Expanded(
                                      child: Container(
                                          height: 1, color: Colors.grey)),
                                ],
                              ),
                              const Text('Contact with Developer'),
                              const SizedBox(height: 16),
                              Container(
                                color: Colors.transparent,
                                // width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    //call
                                    CustomButton(
                                        type: 'tel:',
                                        link: kDeveloperMobile,
                                        icon: Icons.call,
                                        color: Colors.green),

                                    SizedBox(width: 8),

                                    //mail
                                    CustomButton(
                                        type: 'mailto:',
                                        link: kDeveloperEmail,
                                        icon: Icons.mail,
                                        color: Colors.red),

                                    SizedBox(width: 8),

                                    //facebook
                                    CustomButton(
                                        type: '',
                                        link: kDeveloperFb,
                                        icon: Icons.facebook,
                                        color: Colors.blue),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ));
              },
              label: const Text('Need verify code'),
              icon: const Icon(Icons.help),
            )
          : null,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),

                  Text(
                    'Register'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Verify your identity ',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 32),

                  // batch and id
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedBatch,
                          hint: const Text('Choose Batch'),
                          // isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 8),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedBatch = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Choose your batch" : null,
                          items: kBatchList.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _idField,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter student id';
                            } else if (value.length < 8 || value.length > 8) {
                              return 'Student id at least 8 digits';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Student Id',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //verify
                  TextFormField(
                    controller: _verifyField,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter verification code';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Student Verification Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // mobile
                  TextFormField(
                    controller: _mobileField,
                    validator: (value) {
                      if (value == null) {
                        return 'Enter Mobile Number';
                      } else if (value.length < 11 || value.length > 11) {
                        return 'Mobile Number at least 11 digits';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // hall
                  DropdownButtonFormField(
                    value: _selectedHall,
                    hint: const Text('Choose Hall'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHall = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Choose your hall" : null,
                    items: kHallList.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // button
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      //button
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            //
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              FirebaseFirestore.instance
                                  .collection('Psychology')
                                  .doc('Verify')
                                  .collection(_selectedBatch!)
                                  .doc(_idField.text)
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  print('id found: ' + documentSnapshot.id);

                                  //
                                  var getToken = documentSnapshot.get('token');

                                  if (getToken == _verifyField.text) {
                                    Fluttertoast.showToast(
                                        msg: "Verification Code Match");

                                    //
                                    setState(() => _isLoading = false);
                                    //
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen(
                                                  batch: _selectedBatch,
                                                  id: _idField.text,
                                                  mobile: _mobileField.text,
                                                  hall: _selectedHall,
                                                )));
                                  } else if (getToken == 'used') {
                                    Fluttertoast.showToast(
                                        msg: "Verification code already used");
                                    //
                                    setState(() => _isLoading = false);
                                  } else {
                                    Fluttertoast.cancel();
                                    Fluttertoast.showToast(
                                        msg:
                                            "Wrong verify code. Enter correct one");
                                    setState(() => _isLoading = false);
                                  }
                                } else {
                                  // print('Document does not exist on the database');
                                  Fluttertoast.cancel();
                                  Fluttertoast.showToast(
                                      msg: "Student Id not found in Database");
                                  setState(() => _isLoading = false);
                                }
                              });
                            }
                          },
                          child: const Text('Next'),
                          color: Colors.black87,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // loading
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Visibility(
                            visible: _isLoading,
                            child: const CircularProgressIndicator(
                              color: Colors.red,
                            )),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account.'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Login Now',
                              style: TextStyle(color: Colors.blue))),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
