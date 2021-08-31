import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditPdfInformation extends StatefulWidget {
  const EditPdfInformation({
    required this.title,
    required this.subTitle,
    this.ref,
    this.documentId,
  });
  final String title;
  final String subTitle;
  final CollectionReference? ref;
  final String? documentId;

  @override
  _EditPdfInformationState createState() => _EditPdfInformationState();
}

class _EditPdfInformationState extends State<EditPdfInformation> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.title;
    _subTitleController.text = widget.subTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit File info'),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),

              SizedBox(height: 16),

              //subtitle
              TextFormField(
                controller: _subTitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Creator/Author/Year',
                ),
              ),

              SizedBox(height: 24),

              //
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    widget.ref!.doc(widget.documentId)
                        .update({
                        'title' : _titleController.text,
                        'subtitle' : _subTitleController.text,
                    }).then((value) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'Update successfully');
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
