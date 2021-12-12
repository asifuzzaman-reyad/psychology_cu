// bookmark screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psy_assistant/screen/study/components/pdf_view_screen.dart';

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

          return ListView.separated(
            itemCount: snapshot.data!.size,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data!.docs[index];

              //card
              return Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfViewScreen(
                                title: data.get('title').toString(),
                                fileUrl: data.get('fileUrl'))));
                  },
                  minLeadingWidth: 32,
                  leading: RotatedBox(
                    quarterTurns: -45,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 2),
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          )),
                      child: Text('${data.get('courseCode')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2),
                    ),
                  ),
                  title: Text(data.get('title')),
                  subtitle: Text('~ ' + data.get('subtitle')),
                  trailing: IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Study_Bookmarks')
                            .doc('Users')
                            .collection(FirebaseAuth.instance.currentUser!.uid)
                            .doc(data.id.toString())
                            .delete()
                            .whenComplete(() {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(msg: 'Delete bookmark');
                        });
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8),
          );
        },
      ),
    );
  }
}
