import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/study/upload/api/firebase_api.dart';

import '../../../../constants.dart';

class UploadCourseScreen extends StatefulWidget {
  UploadCourseScreen({required this.year});
  final String year;

  @override
  _UploadCourseScreenState createState() => _UploadCourseScreenState();
}

class _UploadCourseScreenState extends State<UploadCourseScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _codeController = TextEditingController();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _marksController = TextEditingController();
  TextEditingController _creditsController = TextEditingController();

  var selectedCourseType;

  File? _imageFile;
  UploadTask? task;

  bool _isLoading = false;

  // select image
  Future pickImage() async {
    final pickImage = await FilePicker.platform.pickFiles(type: FileType.image);

    if (pickImage == null) return;
    final path = pickImage.files.single.path;

    //
    setState(() => _imageFile = File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Course Information'),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),

      //
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  link tree
                  Row(
                    children: [
                      Icon(Icons.account_tree_outlined,
                          size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                          '${widget.year} > Course Information'),
                    ],
                  ),

                  SizedBox(height: 16),

                  //image
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.pink.shade100,
                        child: _imageFile == null ? Image.network(kNoImagePP) : Image.file(_imageFile!, fit: BoxFit.fill,),
                      ),

                      SizedBox(width: 16),
                      //
                      ElevatedButton(onPressed: (){pickImage();}, child: Text('Choose Image'))
                    ],
                  ),

                  SizedBox(height: 16),

                  //
                  Row(
                    children: [
                      // course type
                      Expanded(
                          child: // dropdown
                          DropdownButtonFormField(
                            hint: Text('Course Type'),
                            value: selectedCourseType,
                            validator: (val) => val == null ? 'Enter Course Type' : null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                              border: OutlineInputBorder()
                            ),
                            items: ['Major Course', 'Related Course']
                                .map(
                                  (String item) => DropdownMenuItem<String>(
                                  child: Text(item), value: item),
                            )
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCourseType = newValue;
                              });
                            },
                          )),

                      SizedBox(width: 16),

                      // course code
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          validator: (val) => val!.isEmpty ? 'Enter Course Code' : null,
                          decoration: InputDecoration(
                            labelText: 'Course Code ',
                            hintText: '101',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // course title
                  TextFormField(
                    controller: _titleController,
                    validator: (val) => val!.isEmpty ? 'Enter course title' : null,
                    decoration: InputDecoration(
                      labelText: 'Course Title ',
                      hintText: 'General Psychology',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),

                  SizedBox(height: 16),

                  // credits & marks
                  Row(
                    children: [

                      // marks
                      Expanded(
                        child: TextFormField(
                          controller: _marksController,
                          validator: (val) => val!.isEmpty ? 'Enter Marks' : null,
                          decoration: InputDecoration(
                            labelText: 'Marks ',
                            hintText: '100',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),

                      SizedBox(width: 16),

                      // credits
                      Expanded(
                        child: TextFormField(
                          controller: _creditsController,
                          validator: (val) => val!.isEmpty ? 'Enter Credits' : null,
                          decoration: InputDecoration(
                            labelText: 'Credits ',
                            hintText: '4',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // button
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                      width: double.infinity,
                        height: 48,
                        child: MaterialButton(
                            onPressed: () {

                              if(_imageFile == null){
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(msg: 'No Image found!');
                              }
                              else if(_globalKey.currentState!.validate()){
                                setState(() => _isLoading = true);
                                uploadFile();
                              }

                            },
                            color: Colors.blue,
                            child: Text('Upload')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            )),
      ),
    );
  }

  //
  // upload and download url
  Future uploadFile() async {

    final filePath = 'Study/${widget.year}/Psy ${_codeController.text}/cover';

    // final fileName = basename(_imageFile!.path);
    // final destination = '$filePath/$fileName';
    final destination = '$filePath/${_codeController.text}_cover.jpg';

    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadedUrl = await snapshot.ref.getDownloadURL();
    print('Download-Link: $downloadedUrl');

    // cloud fire store
    uploadCourseData(downloadedUrl);
  }

  //
  uploadCourseData(String downloadedUrl){
    Map<String, dynamic> map = {
      'title': _titleController.text.toString(),
      'code': 'Psy ' + _codeController.text.toString(),
      'marks': _marksController.text.toString(),
      'credits': _creditsController.text.toString(),
      'imageUrl': downloadedUrl,
    };

    FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(selectedCourseType.toString())
        .doc('Psy ' + _codeController.text.toString())
        .set(map).whenComplete((){
      setState(() => _isLoading = false);
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "Course information Upload successfully");

      _codeController.clear();
      _titleController.clear();
      _marksController.clear();
      _creditsController.clear();
      setState(() {
        selectedCourseType = null;
      _imageFile = null;
      });
    });
  }
}
