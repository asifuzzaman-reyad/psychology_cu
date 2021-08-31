import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:psychology_cu/screen/study/study_category_screen_notes.dart';
import 'package:psychology_cu/screen/study/upload/screen/upload_chapter_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({
    required this.year,
    required this.courseType,
    required this.courseCode,
    required this.courseCategory,
    required this.subtitle,
  });
  final String year;
  final String courseType;
  final String courseCode;
  final String courseCategory;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance
        .collection('Study')
        .doc(year)
        .collection(courseType)
        .doc(courseCode)
        .collection('Lessons');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          //
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadChapterScreen(
                  year: year,
                  courseType: courseType,
                  courseCode : courseCode,
                  courseCategory : courseCategory
              )));
        },
        child: Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: reference.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return snapshot.data!.size > 0
                ?  ListView(
              padding: EdgeInsets.all(8),
                    children: snapshot.data!.docs.map((document) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudyCategoryScreenNotes(
                                year: year,
                                courseType: courseType,
                                courseCode: courseCode,
                                courseCategory: 'Notes',
                                subtitle: 'Creator',
                                chapterNo: document.id.toString(),
                                chapterTitle: document.get('title').toString(),
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.all(12),
                          leading: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber.shade200,
                            ),
                            alignment: Alignment.center,
                            child: Text('${document.id}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                )),
                          ),
                          title: Text(
                            '${document.get('title')}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ) :
            Center(child: Text('No Data found'));
          }),
    );
  }
}
