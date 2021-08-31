import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/constants.dart';

class UploadChapterScreen extends StatefulWidget {
  const UploadChapterScreen({
    required this.year,
    required this.courseType,
    required this.courseCode,
    required this.courseCategory,
  });
  final String year;
  final String courseType;
  final String courseCode;
  final String courseCategory;

  @override
  _UploadChapterScreenState createState() => _UploadChapterScreenState();
}

class _UploadChapterScreenState extends State<UploadChapterScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _chapterTitleController = TextEditingController();

  var _selectedChapterNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Chapter'),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //  link tree
                  Row(
                    children: [
                      Icon(Icons.account_tree_outlined,
                          size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                          '${widget.year} > ${widget.courseType} > ${widget.courseCode} > ${widget.courseCategory}'),
                    ],
                  ),

                  SizedBox(height: 16),

                  //  lesson no
                  TextFormField(
                    autofocus: true,
                    controller: _chapterTitleController,
                    validator: (val) =>
                    val!.isEmpty ? 'Enter Chapter Name' : null,
                    decoration: InputDecoration(
                      labelText: 'Chapter Name',
                      hintText: 'Introduction',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines : 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  SizedBox(height: 16),

                  //no
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: DropdownButtonFormField(
                      hint: Text('Chapter No'),
                      value: _selectedChapterNo,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      validator: (val) =>
                      val== null ? 'No' : null,
                      items: kLessonNoList
                          .map((item) =>
                          DropdownMenuItem(child: Text(item), value: item))
                          .toList(),
                      onChanged: (newValue){
                        setState(() {
                          _selectedChapterNo = newValue;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 24),

                  // button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                        onPressed: () {

                          if (_globalKey.currentState!.validate()) {
                            var ref = FirebaseFirestore.instance
                                .collection('Study')
                                .doc(widget.year)
                                .collection(widget.courseType)
                                .doc(widget.courseCode)
                                .collection('Lessons')
                                .doc(_selectedChapterNo)
                                .set({'title': _chapterTitleController.text});

                            //
                            ref.whenComplete(() {
                              setState(() {
                              _chapterTitleController.clear();
                              _selectedChapterNo = null;

                              });
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: 'Upload Complete');
                            });
                          }
                        },
                        child: Text('Upload')),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
