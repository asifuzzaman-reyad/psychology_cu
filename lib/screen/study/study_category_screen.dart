import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/study/upload/screen/upload_pdf_screen.dart';

import 'course_category_card.dart';


class StudyCategoryScreen extends StatefulWidget {
  const StudyCategoryScreen({
    required this.courseCode,
    required this.year,
    required this.courseType,
    required this.courseCategory,
    required this.subtitle,
  });

  final String year;
  final String courseCode;
  final String courseType;
  final String courseCategory;
  final String subtitle;

  @override
  _StudyCategoryScreenState createState() => _StudyCategoryScreenState();
}

class _StudyCategoryScreenState extends State<StudyCategoryScreen> {

  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection(widget.courseCategory);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadPdfScreen(
                year: widget.year,
                courseType: widget.courseType,
                courseCode : widget.courseCode,
                courseCategory : widget.courseCategory
              )));
        },
        child: Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Course Category Card
          return snapshot.data!.size > 0
              ? CourseCategoryCard(
                  subtitle: widget.subtitle, snapshot: snapshot, ref: reference)
              : Center(child: Text('No Data found'));
        },
      ),
    );
  }
}




