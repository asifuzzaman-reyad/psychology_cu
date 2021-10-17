import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/pdf_view_screen.dart';
import 'models/courses.dart';

class CourseCategoryCard extends StatefulWidget {
  const CourseCategoryCard({
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewScreen(
                      fileUrl: courses.fileUrl,
                      title: courses.title),
                )),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(fontSize: 12),
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
                      style: TextStyle(fontSize: 12),
                    ),
                    Flexible(
                      child: Text(
                        courses.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
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
                                    fontSize: 11)),
                            Text(courses.date,
                                style: TextStyle(
                                    fontSize: 13)),
                            SizedBox(height: 8)
                          ],
                        ),

                        // buttons
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            ),
          );
        });
  }
}
