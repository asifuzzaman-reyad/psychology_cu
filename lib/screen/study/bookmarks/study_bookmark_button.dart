import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psy_assistant/screen/study/components/pdf_view_screen.dart';

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
            return Center(child: Container(width: 30));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(width: 30));
          }

          return snapshot.data!.size == 0
              ? Container()
              : InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudyBookmarkScreen()));
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 30),
                    margin: const EdgeInsets.fromLTRB(8, 13, 8, 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.orange),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '${snapshot.data!.size}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
        });
  }
}

// bookmark screen
class StudyBookmarkScreen extends StatefulWidget {
  const StudyBookmarkScreen({Key? key}) : super(key: key);

  @override
  State<StudyBookmarkScreen> createState() => _StudyBookmarkScreenState();
}

class _StudyBookmarkScreenState extends State<StudyBookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4))),
          title: const Text('Bookmarks'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Study_Bookmarks')
                .doc('Users')
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.size == 0) {
                return const Center(child: Text('No bookmarks found'));
              }

              return GridView.builder(
                itemCount: snapshot.data!.size,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data!.docs[index];

                  //card
                  return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewScreen(
                                  title: data.get('title').toString(),
                                  fileUrl: data.get('fileUrl'))));
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Tooltip(
                            message: 'Delete Bookmark',
                            child: InkWell(
                                borderRadius: BorderRadius.circular(32),
                                onTap: () => FirebaseFirestore.instance
                                        .collection('Study_Bookmarks')
                                        .doc('Users')
                                        .collection(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .doc(data.id.toString())
                                        .delete()
                                        .whenComplete(() {
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                          msg: 'Delete bookmark');
                                    }),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.clear))),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              child: Text(
                                data.get('title'),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
