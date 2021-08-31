import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/teacher/upload_teacher_information.dart';

import '../../constants.dart';
import '../teacher/teacher_details_screen.dart';

class TeacherScreen extends StatelessWidget {
  static const routeName = 'teacher_screen';

  final ref =
      FirebaseFirestore.instance.collection('Psychology').doc('Teachers');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Teacher Information'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Present'),
              Tab(text: 'Study Leave'),
            ],
            labelPadding: EdgeInsets.all(4),
            unselectedLabelColor: Colors.grey,
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, UploadTeacherInformation.routeName);
          },
          child: Icon(Icons.add),
        ),

        body: TabBarView(
          children: [
            // present
            buildTeacherListView('Present'),

            //study leave
            buildTeacherListView('Absent'),
          ],
        ),
      ),
    );
  }

  // teacher list view
  Widget buildTeacherListView(String status) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref.collection(status).orderBy('serial').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          return snapshot.data!.size == 0
              ? Center(child: Text('No data found'))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemBuilder: (BuildContext context, int index) {

                    //
                    var teacher = data[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pushNamed(
                          context, TeacherDetailsScreen.routeName,
                          arguments: teacher),
                      onLongPress: (){
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: Text('Delete Teacher Information!'),
                          content: Text('Be sure before delete any thing'),
                          actions : [
                            //
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('No')),

                            //
                            TextButton(onPressed: (){
                            FirebaseFirestore.instance
                                .collection("Psychology")
                                .doc('Teachers')
                                .collection(status)
                                .doc(teacher.id)
                                .delete()
                                .then((_) {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: 'Delete successfully');
                              print("delete successful!");
                              Navigator.pop(context);
                            });
                          }, child: Text('Yes')),

                          ]
                        ));

                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              // spreadRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Hero(
                              tag: teacher.get('name'),
                              child: CachedNetworkImage(
                                  imageUrl: teacher.get('imageUrl'),
                                  fadeInDuration: Duration(milliseconds: 500),
                                  imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, radius: 32,),
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircleAvatar(radius: 32,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                                  errorWidget: (context, url, error) => CircleAvatar(radius: 32,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                                ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(teacher.get('name'),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(teacher.get('post'),
                                    style: TextStyle(color: Colors.black54)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
        });
  }
}

