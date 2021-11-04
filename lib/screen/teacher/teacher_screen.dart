import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../teacher/teacher_details_screen.dart';

class TeacherScreen extends StatelessWidget {
  static const routeName = 'teacher_screen';

  final ref =
      FirebaseFirestore.instance.collection('Psychology').doc('Teachers');

  TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('Teacher Information'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Present'),
              Tab(text: 'Study Leave'),
            ],
            labelPadding: EdgeInsets.all(4),
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
          ),
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
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          return snapshot.data!.size == 0
              ? const Center(child: Text('No data found'))
              : Scrollbar(
                  radius: const Radius.circular(8),
                  interactive: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (BuildContext context, int index) {
                      //
                      var teacher = data[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pushNamed(
                            context, TeacherDetailsScreen.routeName,
                            arguments: teacher),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                Hero(
                                  tag: teacher.get('name'),
                                  child: CachedNetworkImage(
                                    imageUrl: teacher.get('imageUrl'),
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 32,
                                    ),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        const CircleAvatar(
                                            radius: 32,
                                            backgroundImage: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                            child:
                                                CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                            radius: 32,
                                            backgroundImage: AssetImage(
                                                'assets/images/pp_placeholder.png')),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(teacher.get('name'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(teacher.get('post'),
                                        style: const TextStyle()),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        });
  }
}
