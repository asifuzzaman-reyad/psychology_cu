import 'package:flutter/material.dart';

import '/screen/study/study_screen_list.dart';
import 'bookmarks/study_bookmark_button.dart';
import 'notes_screen.dart';

class StudyScreenDetails extends StatefulWidget {
  const StudyScreenDetails({
    key,
    required this.year,
    required this.courseType,
    required this.courseTitle,
    required this.courseCode,
  }) : super(key: key);

  final String year;
  final String courseType;
  final String courseTitle;
  final String courseCode;

  @override
  _StudyScreenDetailsState createState() => _StudyScreenDetailsState();
}

//
class _StudyScreenDetailsState extends State<StudyScreenDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.courseTitle} (${widget.courseCode})'),
          // title: Text('(${widget.courseCode}) ${widget.courseTitle}'),
          titleSpacing: 0,
          centerTitle: true,
          actions: const [
            // study bookmark
            StudyBookmarkButton(),

            SizedBox(width: 8),
          ],

          // tab
          bottom: const TabBar(
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
              subtitleType: 'Creator',
            ),
            StudyScreenList(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Books',
              subtitleType: 'Author',
            ),
            StudyScreenList(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Questions',
              subtitleType: 'Year',
            ),
            StudyScreenList(
              year: widget.year,
              courseType: widget.courseType,
              courseCode: widget.courseCode,
              courseCategory: 'Syllabus',
              subtitleType: 'Year',
            ),
          ],
        ),
      ),
    );
  }
}
