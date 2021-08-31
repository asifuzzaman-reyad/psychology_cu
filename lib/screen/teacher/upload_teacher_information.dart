import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadTeacherInformation extends StatefulWidget {
  static const routeName = 'upload_teacher_information';

  @override
  _UploadTeacherInformationState createState() =>
      _UploadTeacherInformationState();
}

class _UploadTeacherInformationState extends State<UploadTeacherInformation> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameField = TextEditingController();
  TextEditingController _serialField = TextEditingController();
  TextEditingController _mobileField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _interestField = TextEditingController();
  TextEditingController _phdField = TextEditingController();
  TextEditingController _publicationField = TextEditingController();

  List postList = [
    'Professor',
    'Associated Professor',
    'Assistant Professor',
    'Lecturer'
  ];

  var _selectedPost;
  var _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Teacher Information'),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //name
                TextFormField(
                  controller: _nameField,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Name', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter something' : null,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                ),

                SizedBox(height: 16),

                // post & serial
                Row(
                  children: [
                    //Status
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField(
                        hint: Text('Status'),
                        decoration:
                        InputDecoration(border: OutlineInputBorder()),
                        validator: (val) =>
                        val == null ? 'Select status' : null,
                        value: _selectedStatus,
                        items: ['Present', 'Absent']
                            .map((item) => DropdownMenuItem(
                            value: item, child: Text(item)))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        },
                      ),
                    ),

                    SizedBox(width: 16),

                    // post
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField(
                        hint: Text('Select Post'),
                        decoration:
                        InputDecoration(border: OutlineInputBorder()),
                        validator: (val) =>
                        val == null ? 'Select post plz' : null,
                        value: _selectedPost,
                        items: postList
                            .map((item) => DropdownMenuItem(
                            value: item, child: Text(item)))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPost = newValue;
                          });
                        },
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 16),

                // mobile
                Row(
                  children: [

                    //serial
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _serialField,
                        decoration: InputDecoration(
                            labelText: 'Serial', hintText: '1', border: OutlineInputBorder()),
                        validator: (val) =>
                        val!.isEmpty ? 'Enter something' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    SizedBox(width: 16),

                    // mobile
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _mobileField,
                        decoration: InputDecoration(
                            labelText: 'Mobile', border: OutlineInputBorder()),
                        validator: (val) => val!.isEmpty ? 'Enter something' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                  ],
                ),

                //email
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailField,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter something' : null,
                  keyboardType: TextInputType.emailAddress,
                ),

                //interest
                SizedBox(height: 16),
                TextFormField(
                  controller: _interestField,
                  decoration: InputDecoration(
                      labelText: 'Interest', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter something' : null,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 10,
                ),

                //phd
                SizedBox(height: 16),
                TextFormField(
                  controller: _phdField,
                  decoration: InputDecoration(
                      labelText: 'Phd', border: OutlineInputBorder()),
                  // validator: (val) => val!.isEmpty ? 'Enter something' : null,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                ),

                //publication
                SizedBox(height: 16),
                TextFormField(
                  controller: _publicationField,
                  decoration: InputDecoration(
                      labelText: 'Publication', border: OutlineInputBorder()),
                  // validator: (val) => val!.isEmpty ? 'Enter something' : null,
                  keyboardType: TextInputType.url,
                ),

                SizedBox(height: 32),

                //button
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {

                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> teacherInfo = {
                          'name': _nameField.text,
                          'post': _selectedPost,
                          'serial': int.parse(_serialField.text.toString()),
                          'mobile': _mobileField.text,
                          'email': _emailField.text,
                          'interest': _interestField.text,
                          'phd': _phdField.text,
                          'publication': _publicationField.text,
                          'imageUrl': '',
                        };
                        uploadTeacherInfo(teacherInfo);
                      }
                    },
                    child: Text('Upload'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  uploadTeacherInfo(Map<String, dynamic> teacherInfo) {
    FirebaseFirestore.instance
        .collection('Psychology')
        .doc('Teachers')
        .collection(_selectedStatus)
        .doc()
        .set(teacherInfo)
        .whenComplete(() {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Upload Successful');
    });
  }
}
