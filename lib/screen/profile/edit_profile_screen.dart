import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychology_cu/constants.dart';
import 'package:psychology_cu/screen/study/upload/api/firebase_api.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  UploadTask? task;
  bool isTaskActive = false;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  var _selectedHall;

  var userRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());
  var studentRef =
      FirebaseFirestore.instance.collection('Psychology').doc('Students');

  // select image
  Future pickImage() async {
    final pickImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowCompression: true);

    if (pickImage == null) return;
    final path = pickImage.files.single.path;

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
    });
  }

  //
  pickNewImage() async {
    final _picker = ImagePicker();
    var pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
    );
    if (pickedFile == null) return null;

    var file = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    );
    if (file == null) return;

    setState(() {
      _imageFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var batch = snapshot.data!.get('batch').toString();
            var id = snapshot.data!.get('id').toString();

            return StreamBuilder<DocumentSnapshot>(
                stream: studentRef.collection(batch).doc(id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  //
                  _nameController.text = snapshot.data!.get('name');
                  _mobileController.text = snapshot.data!.get('mobile');
                  // _selectedHall = snapshot.data!.get('hall');

                  return Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                  child: _imageFile == null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              snapshot.data!.get('imageUrl'),
                                          fadeInDuration:
                                              Duration(milliseconds: 500),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            backgroundImage: imageProvider,
                                            radius: 100,
                                          ),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircleAvatar(
                                                  radius: 100,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/pp_placeholder.png')),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            _imageFile!,
                                            fit: BoxFit.cover,
                                          )),
                                ),

                                //
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: MaterialButton(
                                    onPressed: () => pickNewImage(),
                                    child: Icon(Icons.camera),
                                    shape: CircleBorder(),
                                    color: Colors.grey.shade300,
                                    padding: EdgeInsets.all(10),
                                    minWidth: 24,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            //name
                            TextFormField(
                              controller: _nameController,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter your Name' : null,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                            ),

                            SizedBox(height: 16),

                            //
                            TextFormField(
                              controller: _mobileController,
                              validator: (val) =>
                                  val!.length < 11 || val.length > 11
                                      ? 'Mobile Number must be 11 digit'
                                      : null,
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),

                            SizedBox(height: 16),

                            // hall
                            DropdownButtonFormField(
                              value: _selectedHall,
                              hint: Text('Choose Hall if want to change'),
                              // isExpanded: true,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              onChanged: (value) {
                                setState(() {
                                  _selectedHall = value;
                                });
                              },
                              // validator: (value) =>
                              // value == null ? "Choose your hall" : null,
                              items: kHallList.map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),

                            SizedBox(height: 16),

                            // button
                            MaterialButton(
                                onPressed: () {
                                  if (_globalKey.currentState!.validate()) {
                                    if (_imageFile != null) {
                                      uploadFile(snapshot.data!);
                                    } else {
                                      studentRef
                                          .collection(batch)
                                          .doc(id)
                                          .update({
                                        'name': _nameController.text,
                                        'mobile': _mobileController.text,
                                        'hall': _selectedHall == null
                                            ? snapshot.data!.get('hall')
                                            : _selectedHall,
                                      }).whenComplete(() {
                                        Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                            msg: 'Update successful');
                                        Navigator.pop(this.context);
                                      });
                                    }
                                  }
                                },
                                color: Colors.blue,
                                height: 48,
                                minWidth: double.infinity,
                                child: Text("Update Profile"))
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  //
  // upload and download url
  Future uploadFile(DocumentSnapshot data) async {
    String batch = data.get('batch');
    String id = data.get('id');

    final destination = 'Users/$batch/$id.jpg';
    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadedUrl = await snapshot.ref.getDownloadURL();
    print('Download-Link: $downloadedUrl');

    // cloud fire store

    studentRef
        .collection(batch)
        .doc(id)
        .update({'imageUrl': downloadedUrl}).whenComplete(() {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Update successful');
      Navigator.pop(this.context);
    });
  }
}
