import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import './/constants.dart';
import './/firebase/firebase_api.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {required this.batch, required this.id, required this.snapshot});
  final String batch;
  final String id;
  final DocumentSnapshot snapshot;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  UploadTask? task;
  bool isTaskActive = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  var _selectedHall;

  @override
  void initState() {
    _selectedHall = widget.snapshot.get('hall');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.snapshot.get('name');
    _mobileController.text = widget.snapshot.get('mobile');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: Container(
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
                    GestureDetector(
                      onTap: () => pickNewImage(),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: _imageFile == null
                            ? CachedNetworkImage(
                                imageUrl: widget.snapshot.get('imageUrl'),
                                fadeInDuration: Duration(milliseconds: 500),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 100,
                                ),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    CircleAvatar(
                                        radius: 100,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png')),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: MaterialButton(
                        onPressed: () => pickNewImage(),
                        child: Icon(Icons.camera, color: Colors.black),
                        shape: CircleBorder(),
                        color: Colors.grey.shade300,
                        padding: EdgeInsets.all(12),
                        minWidth: 24,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                //name
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? 'Enter your Name' : null,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                ),

                SizedBox(height: 16),

                // mobile
                TextFormField(
                  controller: _mobileController,
                  validator: (val) => val!.length < 11 || val.length > 11
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
                  hint: Text('Change Hall Name'),
                  // isExpanded: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 12)),
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

                SizedBox(height: 24),

                // button
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    MaterialButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            if (_imageFile != null) {
                              setState(() {
                                _isLoading = true;
                              });
                              uploadFile(batch: widget.batch, id: widget.id);
                            } else {
                              setState(() {
                                _isLoading = true;
                              });

                              print(_selectedHall);
                              //
                              FirebaseFirestore.instance
                                  .collection('Psychology')
                                  .doc('Students')
                                  .collection(widget.batch)
                                  .doc(widget.id)
                                  .update({
                                'name': _nameController.text,
                                'mobile': _mobileController.text,
                                'hall': _selectedHall ??
                                    widget.snapshot.get('hall'),
                              }).whenComplete(() {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                    msg: 'Update successful');
                                Navigator.pop(this.context);
                              });
                            }
                          }
                        },
                        color: Colors.black,
                        height: 48,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        child: Text("Update Profile",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                    Visibility(
                      visible: _isLoading,
                      child: Positioned(
                        left: 32,
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // select image
  Future pickImage() async {
    final pickImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowCompression: true);

    if (pickImage == null) return;
    final path = pickImage.files.single.path;

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path!,
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

  // pick cropped file
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

  // upload and download url
  Future uploadFile({required String batch, required String id}) async {
    final destination = 'Users/$batch/$id.jpg';
    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadedUrl = await snapshot.ref.getDownloadURL();
    print('Download-Link: $downloadedUrl');

    // cloud fire store
    FirebaseFirestore.instance
        .collection('Psychology')
        .doc('Students')
        .collection(batch)
        .doc(id)
        .update({'imageUrl': downloadedUrl}).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Update successful');
      Navigator.pop(context);
    });
  }
}
