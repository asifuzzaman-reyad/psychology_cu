import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/study/study_category_screen.dart';

import 'notes_screen.dart';

class StudyDetailsScreen extends StatefulWidget {
  const StudyDetailsScreen({
    required this.year,
    required this.courseType,
    required this.courseTitle,
    required this.courseCode,
  });

  final String year;
  final String courseType;
  final String courseTitle;
  final String courseCode;

  @override
  _StudyDetailsScreenState createState() => _StudyDetailsScreenState();
}

//
class _StudyDetailsScreenState extends State<StudyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.courseTitle} (${widget.courseCode})'),
          // '${widget.courseCode} (${widget.courseTitle})'),
          titleSpacing: 0,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Notes'),
              Tab(text: 'Books'),
              Tab(text: 'Questions'),
              Tab(text: 'Syllabus'),
            ],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
          ),
        ),

        //
        body: TabBarView(
          children: [
            NotesScreen(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Notes',
              subtitle: 'Creator',
            ),
            StudyCategoryScreen(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Books',
              subtitle: 'Author',
            ),
            StudyCategoryScreen(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Questions',
              subtitle: 'Year',
            ),
            StudyCategoryScreen(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Syllabus',
              subtitle: 'Year',
            ),
          ],
        ),
      ),
    );
  }
}
