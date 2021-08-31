import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/study/upload/models/courses.dart';
import 'package:psychology_cu/screen/study/upload/screen/upload_course_screen.dart';
import 'api/firebase_api.dart';

class UploadFileScreen extends StatefulWidget {

  @override
  _UploadFileScreenState createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  List<String> courseType = ['Major Course', 'Related Course'];
  List<String> courseCategory = ['Notes', 'Books', 'Questions', 'Syllabus'];

  String? selectedYear ;
  String? selectedCourseType;
  String? selectedCourseCode;
  String? selectedCourseCategory;
  String? selectedLessons;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();

  UploadTask? task;
  bool isTaskActive = false;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Screen'),
      ),
      body: uploadBody(fileName),
    );
  }

  // body
  Widget uploadBody(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // year & type
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //year
                  Expanded(
                    child: DropdownButtonFormField(
                      validator: (val) => val == null ? 'Choose year' : null ,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: Text('Year '),
                      value: selectedYear,
                      items: ['1st Year', '2nd Year']
                          .map(
                            (String item) =>
                                DropdownMenuItem(child: Text(item), value: item),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCourseType = null;
                          selectedCourseCode = null;
                          selectedCourseCategory = null;
                          selectedLessons = null;

                          //
                          selectedYear = newValue;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 16),

                  //course type
                  Expanded(
                    child: selectedYear == null
                        ? Text('')
                        : DropdownButtonFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                      validator: (val) => val == null ? 'Choose Type' : null ,
                      hint: Text('Course Type'),
                            value: selectedCourseType,
                            items: courseType
                                .map((String item) => DropdownMenuItem(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCourseCode = null;
                                selectedCourseCategory = null;
                                selectedLessons = null;

                                //
                                selectedCourseType = newValue;
                                print(newValue);
                              });
                            },
                          ),
                  ),
                ],
              ),

              SizedBox(height: selectedCourseType != null ? 16 : 0),

              // code & category
              Row(
                children: [
                  //code
                  Expanded(
                      child: selectedCourseType != null
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Study')
                                  .doc(selectedYear)
                                  .collection(selectedCourseType!)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  Center(child: Text('SomeThing Wrong'));
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  Center(child: CircularProgressIndicator());

                                return DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  validator: (val) => val == null ? 'Choose code' : null ,
                                  hint: Text('Course Code'),
                                  value: selectedCourseCode,
                                  items: snapshot.data!.docs
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                            child: Text(item.id.toString()),
                                            value: item.id.toString()),
                                      )
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCourseCategory = null;
                                      selectedLessons = null;

                                      //
                                      selectedCourseCode = newValue;
                                      print(newValue);
                                    });
                                  },
                                );
                              })
                          : Text('')),

                  SizedBox(width: 16),

                  // category
                  Expanded(
                      child: selectedCourseCode == null
                          ? Text('')
                          : DropdownButtonFormField(
                        validator: (val) => val == null ? 'Choose Category' : null ,
                        decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              hint: Text('Category'),
                              value: selectedCourseCategory,
                              items: courseCategory
                                  .map(
                                    (String item) => DropdownMenuItem<String>(
                                        child: Text(item), value: item),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCourseCategory = null;
                                  selectedCourseCategory = newValue;
                                  print(newValue);
                                  //
                                });
                              },
                            )),
                ],
              ),

              SizedBox(height: selectedCourseCategory != null ? 16 : 0),

              // lessons
              selectedCourseCategory != "Notes"
                  ? Text('')
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Study')
                          .doc(selectedYear)
                          .collection(selectedCourseType!)
                          .doc(selectedCourseCode)
                          .collection('Lessons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField(
                          decoration:
                              InputDecoration(border: OutlineInputBorder(),),
                          hint: Text('Choose Lesson'),
                          value: selectedLessons,
                          items: snapshot.data!.docs
                              .map(
                                (item) => DropdownMenuItem(
                                  child: Text(
                                    item.id.toString() +
                                        '. ' +
                                        item.get('title').toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(),
                                  ),
                                  value: item.id.toString() +
                                      '. ' +
                                      item.get('title').toString(),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLessons = newValue;
                              print(newValue);
                            });
                          },
                        );
                      }),

              SizedBox(height: selectedCourseCategory != null ? 16 : 0),

              // file
              Column(
                children: [

                  //select file
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      horizontalTitleGap: 0,
                      minVerticalPadding: 0,
                      leading:
                      Icon(Icons.insert_drive_file_rounded, size: 32),
                      title: Text(
                        fileName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          onPressed: selectFile,
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //
                  SizedBox(height: 16),

                  // title
                  TextFormField(
                    controller: _titleController,
                    validator: (val) => val!.isEmpty ? 'Enter title' : null,
                    decoration: InputDecoration(
                      labelText: 'Title ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  SizedBox(height: 16),

                  //
                  TextFormField(
                    controller: _subTitleController,
                    validator: (val) => val!.isEmpty ? 'Enter something' : null,
                    decoration: InputDecoration(
                      labelText: 'Creator/Author/Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: (){

                        if(_globalKey.currentState!.validate()){
                          customDialog(this.context);
                          uploadFile();
                        }
                      },
                      label: Text('Upload File'),
                      icon: Icon(Icons.cloud_upload_outlined),

                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //
  customDialog(BuildContext context){
    showDialog(context: context, builder: (context)=>
        Dialog(
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children:[
            SpinKitFadingCircle(
            color: Colors.black,
            size: 32
          ),
            SizedBox(width: 16),

            StreamBuilder<TaskSnapshot>(
              stream: task!.snapshotEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!;
                  final progress = snap.bytesTransferred / snap.totalBytes;
                  final percentage = (progress * 100).toStringAsFixed(0);

                  return Text(
                    'Uploading $percentage %',
                    style: TextStyle(fontSize: 16),
                  );
                } else {
                  return Text('');
                }
              },
            )

          ],
        ),
      ),
    ));
  }

  // select pdf
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    //
    setState(() {
      file = File(path);
      //
      // final fileName = basename(file!.path);
      // titleController.text = fileName;
    });
  }

  // upload and download url
  Future uploadFile() async {
    if (file == null) return;

    //
    final filePath =
        'Study/$selectedYear/$selectedCourseCode/$selectedCourseCategory';

    final fileName = basename(file!.path);
    final destination = '$filePath/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadedUrl = await snapshot.ref.getDownloadURL();
    String fileUrl = downloadedUrl;
    print('Download-Link: $fileUrl');

    // cloud fire store
    uploadCourseData(context, selectedYear!, fileUrl);

    //
    Navigator.pop(this.context);
  }

  // upload course
  Future uploadCourseData(context, String year, fileUrl) {
    final firebaseRef = FirebaseFirestore.instance
        .collection('Study')
        .doc(year)
        .collection(selectedCourseType.toString())
        .doc(selectedCourseCode.toString())
        .collection(selectedCourseCategory.toString());

    Courses courses = Courses(
        title: _titleController.text,
        subtitle: _subTitleController.text,
        date: uploadTime(),
        fileUrl: fileUrl);

    if (selectedCourseCategory == 'Notes') {
      var lessonNo = selectedLessons.toString().substring(0, 2);
      return firebaseRef
          .doc('Lessons')
          .collection(lessonNo)
          .doc()
          .set(courses.toJson());
    } else {
      return firebaseRef.doc().set(courses.toJson());
    }
  }

  // time
  String uploadTime() {
    DateTime now = DateTime.now();
    String time = DateFormat('dd MMM, yyyy').format(now);
    return time;
  }
}
