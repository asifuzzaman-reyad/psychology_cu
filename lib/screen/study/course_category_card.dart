import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/study/upload/screen/edit_pdf_information.dart';
import 'package:psychology_cu/screen/study/upload/models/courses.dart';

import 'components/pdf_view_screen.dart';

class CourseCategoryCard extends StatefulWidget {
  CourseCategoryCard({
    required this.subtitle,
    required this.snapshot,
    this.ref,
  });

  final String subtitle;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final CollectionReference? ref;

  @override
  _CourseCategoryCardState createState() => _CourseCategoryCardState();
}

class _CourseCategoryCardState extends State<CourseCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        //
        itemCount: widget.snapshot.data!.size,
        itemBuilder: (context, index) {
          //
          var document = widget.snapshot.data!.docs[index];
          Courses courses = Courses(
              title: document.get('title'),
              subtitle: document.get('subtitle'),
              date: document.get('date'),
              fileUrl: document.get('fileUrl'));

          return GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: Text('Manage File'),
                          content:
                              Text('Be sure before delete or edit any file'),
                          actions: [

                            //cancel
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),

                            // delete
                            TextButton(
                                onPressed: () {
                                  widget.ref!
                                      .doc(document.id)
                                      .delete()
                                      .then((_) {
                                    Fluttertoast.cancel();
                                    Fluttertoast.showToast(
                                        msg: 'Delete successfully');
                                    print("delete successful!");
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('Delete')),

                            //
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPdfInformation(
                                                title: courses.title,
                                                subTitle: courses.subtitle,
                                                ref: widget.ref,
                                                documentId:document.id
                                              )));
                                },
                                child: Text('Edit')),
                          ]));
            },
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  Flexible(
                    child: Text(
                      courses.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  Flexible(
                    child: Text(
                      courses.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  //
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
// time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload Date',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black38)),
                          Text(courses.date,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87)),
                          SizedBox(height: 8)
                        ],
                      ),

                      // buttons
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //
                          MaterialButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewScreen(
                                      fileUrl: courses.fileUrl,
                                      title: courses.title),
                                )),
                            child: Text(
                              'Read',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.green,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
