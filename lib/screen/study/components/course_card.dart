import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/models/Course.dart';
import 'package:psychology_cu/screen/home/components/headline.dart';
import '../../../constants.dart';
import '../study_details_screen.dart';


//
class CourseCard extends StatelessWidget {
  const CourseCard({ required this.year, required this.courseType,});
  final String year;
  final String courseType;

  @override
  Widget build(BuildContext context) {
    var _stream = FirebaseFirestore.instance
        .collection('Study')
        .doc(year)
        .collection(courseType);

    return StreamBuilder<QuerySnapshot>(
        stream: _stream.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return snapshot.data!.size > 0 ?
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                SizedBox(height: 8),
                Headline(title: courseType),
                //
                buildCourseList(snapshot, year, courseType),
              ],
            ),
          ) :
          Center(child: Text(''));
        });
  }
}

//
ListView buildCourseList(AsyncSnapshot<dynamic> snapshot, String year, String courseType) {
  return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        physics: ClampingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        //
        itemCount: snapshot.data!.size,
        itemBuilder: (context, index) {
          //
          var document = snapshot.data!.docs[index];
          Course course = Course(
              courseCode: document.get('code'),
              courseTitle: document.get('title'),
              marks: document.get('marks'),
              credits: document.get('credits'),
              imageUrl: document.get('imageUrl'),
              category: document.get('code'),
          );


          return Card(
          elevation: 6,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudyDetailsScreen(
                            year: year,
                            courseType: courseType,
                            courseTitle: course.courseTitle!,
                            courseCode: course.courseCode!,
                          )));
            },
            child: Container(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider('${course.imageUrl}' != ''
                                  ? '${course.imageUrl}'
                                  : kNoImage),
                              fit: BoxFit.cover,
                            ),),
                      ),),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course Title',
                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Padding(
                                padding: const EdgeInsets.only(right: 72),
                                child: Text('${course.courseTitle}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // letterSpacing: 0,
                                    )),
                              ),
                            ],
                          ),

                          Divider(),

                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildInfo('Course Code', '${course.courseCode}'),
                              buildInfo('Marks', '${course.marks}'),
                              buildInfo('Credits', '${course.credits} '),
                            ],
                          ),

                          //
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    });
}

//
Column buildInfo(String title, value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(title, style: TextStyle(fontSize: 13, color: Colors.grey)),
      // SizedBox(width: 8),
      Text(
        value,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    ],
  );
}
