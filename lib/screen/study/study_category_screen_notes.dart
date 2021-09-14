import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'course_category_card.dart';

class StudyCategoryScreenNotes extends StatefulWidget {
  const StudyCategoryScreenNotes({
    required this.courseCode,
    required this.year,
    required this.courseType,
    required this.courseCategory,
    required this.subtitle,
    required this.chapterNo,
    required this.chapterTitle,
  });

  final String year;
  final String courseCode;
  final String courseType;
  final String courseCategory;
  final String subtitle;
  final String chapterNo;
  final String chapterTitle;

  @override
  _StudyCategoryScreenStateNotes createState() =>
      _StudyCategoryScreenStateNotes();
}

class _StudyCategoryScreenStateNotes extends State<StudyCategoryScreenNotes> {
  //
  @override
  Widget build(BuildContext context) {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection(widget.courseCategory)
        .doc('Lessons')
        .collection(widget.chapterNo);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterNo + '. ' + widget.chapterTitle),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reference.orderBy('title').snapshots(),
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
                  subtitle: widget.subtitle,
                  snapshot: snapshot,
                  ref: reference,
                )
              : Center(child: Text('No Data found'));
        },
      ),
    );
  }
}
