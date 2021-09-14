import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/auth/login_screen.dart';
import 'package:psychology_cu/screen/auth/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class RegisterInfoScreen extends StatefulWidget {
  static const routeName = 'register_info_screen';
  @override
  _RegisterInfoScreenState createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _idField = TextEditingController();
  TextEditingController _verifyField = TextEditingController();
  TextEditingController _mobileField = TextEditingController();

  var _selectedBatch;
  var _selectedHall;

  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
  final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;

    return Scaffold(
      floatingActionButton: showFab ? FloatingActionButton.extended(
        onPressed: () async {
          await canLaunch(kFbGroup)
              ? await launch(kFbGroup)
              : throw 'Could not launch $kFbGroup';
        },
        label: Text('Need verify code'),
        icon: Icon(Icons.help),
      ) : null,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),

                  Text(
                    'Register'.toUpperCase(),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Verify your identity ',
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(height: 32),

                  // batch and id
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedBatch,
                          hint: Text('Choose Batch'),
                          // isExpanded: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 8),
                          ),
                          onChanged: (value) {
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
                      SizedBox(width: 16),
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
                          decoration: InputDecoration(
                            hintText: 'Student Id',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  //verify
                  TextFormField(
                    controller: _verifyField,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter verification code';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Student Verification Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 16),

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
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 16),

                  // hall
                  DropdownButtonFormField(
                    value: _selectedHall,
                    hint: Text('Choose Hall'),
                    // isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    ),
                    onChanged: (value) {
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

                  SizedBox(height: 32),

                  // button
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      //button
                      Container(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            //
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              FirebaseFirestore.instance
                                  .collection('Psychology')
                                  .doc('Verify')
                                  .collection(_selectedBatch)
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
                                  print(
                                      'Document does not exist on the database');
                                  Fluttertoast.cancel();
                                  Fluttertoast.showToast(
                                      msg: "Student Id not found in Database");
                                  setState(() => _isLoading = false);
                                }
                              });
                            }
                          },
                          child: Text('Next'),
                          color: Colors.black87,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
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
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            )),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account.'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text('Login Now')),
                    ],
                  ),

                  SizedBox(height: 8),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
