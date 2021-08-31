import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/study/upload/models/courses.dart';
import '../api/firebase_api.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({
    required this.courseCode,
    required this.year,
    required this.courseType,
    required this.courseCategory,
    this.chapterNo,
  });

  final String year;
  final String courseCode;
  final String courseType;
  final String courseCategory;
  final String? chapterNo;

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
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
        title: Text('Upload ${widget.courseCategory} '),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
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

              //  link tree
              Row(
                children: [
                  Icon(Icons.account_tree_outlined,
                      size: 20, color: Colors.grey),
                  SizedBox(width: 4),

                  //
                  widget.chapterNo == null ?
                  Text(
                      '${widget.year} > ${widget.courseType} > ${widget.courseCode} > ${widget.courseCategory}')
                  : Text(
                      '${widget.year} > ${widget.courseType} > ${widget.courseCode} > ${widget.courseCategory} > ${widget.chapterNo}')
                  ,
                ],
              ),

              SizedBox(height: 16),

              // file picker
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
                  leading: Icon(Icons.insert_drive_file_rounded, size: 32),
                  title: Text(
                    fileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  labelText: widget.courseCategory == 'Notes'
                      ? 'Creator'
                      : widget.courseCategory == 'Books'
                          ? 'Author'
                          : 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),

              SizedBox(height: 24),

              // button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (file == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'No File Selected !');
                    } else if (_globalKey.currentState!.validate()) {
                      customDialog(this.context);
                      uploadFile();
                    }
                  },
                  label: Text('Upload File'),
                  icon: Icon(Icons.cloud_upload_outlined),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // select pdf
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['pdf']);

    if (result == null) return;
    final path = result.files.single.path;

    //
    setState(() {
      file = File(path);
    });
  }

  // upload and download url
  Future uploadFile() async {
    final filePath =
        'Study/${widget.year}/${widget.courseCode}/${widget.courseCategory}';

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
    uploadCourseData(context, fileUrl);
  }

  // upload course
  Future uploadCourseData(context, fileUrl) {
    final firebaseRef = FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection(widget.courseCategory);

    Courses courses = Courses(
        title: _titleController.text,
        subtitle: _subTitleController.text,
        date: uploadTime(),
        fileUrl: fileUrl);

    if (widget.courseCategory == 'Notes') {
      return firebaseRef
          .doc('Lessons')
          .collection(widget.chapterNo!)
          .doc()
          .set(courses.toJson()).whenComplete((){
        Navigator.pop(this.context);
        Navigator.pop(this.context);
      });
    } else {
      return firebaseRef.doc().set(courses.toJson()).whenComplete(() {
        Navigator.pop(this.context);
        Navigator.pop(this.context);
      });
    }
  }

  // time
  String uploadTime() {
    DateTime now = DateTime.now();
    String time = DateFormat('dd MMM, yyyy').format(now);
    return time;
  }

  // custom dialog
  customDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            children: [
              SpinKitFadingCircle(color: Colors.black, size: 32),
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
      ),
    );
  }
}
