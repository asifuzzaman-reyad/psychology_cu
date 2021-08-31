import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/dashboard/dashboard_screen.dart';
import 'package:psychology_cu/screen/study/upload/api/firebase_api.dart';
import 'package:psychology_cu/widget/loading.dart';
import '../../constants.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register_screen';

  const RegisterScreen({this.batch, this.id, this.mobile, this.hall});
  final String? batch;
  final String? id;
  final String? mobile;
  final String? hall;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isObscure = true;

  bool loading = false;

  File? _imageFile;
  UploadTask? task;
  bool isTaskActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading ? Loading() : Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8),

                  Text(
                    'Register'.toUpperCase(),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 16),

                  //image pick
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: _imageFile == null
                            ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.network(kNoImagePP, fit: BoxFit.cover))
                            : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.file(_imageFile!, fit: BoxFit.cover,)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: MaterialButton(
                          onPressed: () => pickImage(),
                          child: Icon(Icons.camera),
                          shape: CircleBorder(),
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.all(10),
                          minWidth: 24,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  //email
                  TextFormField(
                    controller: _nameField,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                   textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                  ),

                  SizedBox(height: 16),

                  //email
                  TextFormField(
                    controller: _emailField,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your email';
                      } else if (!regExp.hasMatch(val)) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 16),

                  //password
                  TextFormField(
                    controller: _passwordField,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your password';
                      } else if (val.length < 8) {
                        return 'Password at least 8 character';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                          onTap: () => setState(() => _isObscure = !_isObscure),
                          child: _isObscure == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off_outlined)),
                    ),
                    obscureText: _isObscure,
                    keyboardType: TextInputType.text,
                  ),

                  SizedBox(height: 32),

                  //button
                  Container(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        if(_imageFile == null){
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(msg: 'No Image Selected');
                        }
                        //
                        else if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          register(_emailField.text, _passwordField.text);
                        }
                      },
                      child: Text('Create new account'),
                      color: Colors.black87,
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account.'),

                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }, child: Text('Login now')),
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // select image
  Future pickImage() async {
    final pickImage = await FilePicker.platform.pickFiles(type: FileType.image);

    if (pickImage == null) return;
    final path = pickImage.files.single.path;

    //
    setState(() => _imageFile = File(path));
  }

  // firebase register
  register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;
      print(user);

      if (user != null) {

        //
        uploadImageFile();

        addUsersInformation(user);

        setState(() => loading = false);
        Fluttertoast.showToast(msg: 'Registration successful');
        Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));

      } else {
        Fluttertoast.showToast(msg: 'Register failed: No user found');
        setState(() => loading = false);
      }

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() => loading = false);
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() => loading = false);
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
    } catch (e) {
      setState(() => loading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }

  //
  // upload and download url
  Future uploadImageFile() async {

    final filePath = 'Users/${widget.batch}';
    // final fileName = basename(_imageFile!.path);
    // final destination = '$filePath/$fileName';
    final destination = '$filePath/${widget.id}.jpg';

    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadedUrl = await snapshot.ref.getDownloadURL();
    print('Download-Link: $downloadedUrl');

    // cloud fire store
    addStudentInformation(downloadedUrl);
  }

  //
  addStudentInformation(String downloadedUrl) async{
    //
    Map<String, dynamic> studentInfo = {
      'batch': widget.batch,
      'id': widget.id,
      'name': _nameField.text,
      'mobile': widget.mobile,
      'hall': widget.hall,
      'imageUrl': downloadedUrl,
    };

    await FirebaseFirestore.instance.collection('Psychology')
        .doc('Students')
        .collection(widget.batch!)
        .doc(widget.id)
        .set(studentInfo)
        .whenComplete(() {
      print('add Information successfully');
    });
  }

  //
  addUsersInformation(User user)async{
    await FirebaseFirestore.instance.collection('Users')
        .doc(user.uid.toString())
        .set({'batch': widget.batch, 'id': widget.id})
        .whenComplete(() {
      print('add user successfully');
    });
  }

}

