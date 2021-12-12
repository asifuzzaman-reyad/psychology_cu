import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screen/study/bookmarks/study_bookmark_screen.dart';

class StudyBookmarkButton extends StatelessWidget {
  const StudyBookmarkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Study_Bookmarks')
            .doc('Users')
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Container(width: 32));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(width: 32));
          }

          return snapshot.data!.size == 0
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudyBookmarkScreen()));
                          },
                          icon: const Icon(
                            Icons.rounded_corner,
                            size: 32,
                          )),
                      Text(
                        '${snapshot.data!.size}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
        });
  }
}
