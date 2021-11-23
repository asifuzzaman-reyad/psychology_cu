import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/courses.dart';
import 'pdf_view_screen.dart';

class CourseCategoryCard extends StatefulWidget {
  const CourseCategoryCard({
    key,
    required this.subtitle,
    required this.snapshot,
    this.ref,
  }) : super(key: key);

  final String subtitle;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final CollectionReference? ref;

  @override
  _CourseCategoryCardState createState() => _CourseCategoryCardState();
}

class _CourseCategoryCardState extends State<CourseCategoryCard> {
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///sending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
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

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  //bookmark icon
                  Tooltip(
                    message: 'Bookmark',
                    child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () async {
                          var userId = FirebaseAuth.instance.currentUser!.uid;
                          FirebaseFirestore.instance
                              .collection("Study_Bookmarks")
                              .doc("Users")
                              .collection(userId)
                              .doc(document.id)
                              .set({
                            'title': courses.title,
                            'fileUrl': courses.fileUrl,
                          }).whenComplete(() {
                            //
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: 'Add to bookmark');
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.bookmarks))),
                  ),

                  //
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(fontSize: 12),
                        ),
                        Flexible(
                          child: Text(
                            courses.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Flexible(
                          child: Text(
                            courses.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        //
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
// time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Upload Date',
                                    style: TextStyle(fontSize: 11)),
                                Text(courses.date,
                                    style: const TextStyle(fontSize: 13)),
                                const SizedBox(height: 8)
                              ],
                            ),

                            // buttons
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // download button
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                  onPressed: () async {
                                    fileDownload(document);
                                  },
                                  child: const Text(
                                    'Download',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  color: Colors.amberAccent,
                                ),

                                const SizedBox(width: 8),
                                // read button
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewScreen(
                                            fileUrl: courses.fileUrl,
                                            title: courses.title),
                                      )),
                                  child: const Text(
                                    'Read',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
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
                ],
              ),
            );
          }),
    );
  }

  // file download to folder
  fileDownload(QueryDocumentSnapshot document) async {
    final storage = await Permission.storage.request();

    if (storage.isGranted) {
      Fluttertoast.showToast(msg: 'Downloading...');

      // create folder on device
      Directory newDirectory = await Directory('/storage/emulated/0/Download')
          .create(recursive: true);

      // download file
      await FlutterDownloader.enqueue(
        url: document.get('fileUrl').toString(),
        savedDir: newDirectory.path,
        fileName:
            document.get('title') + '_' + document.get('subtitle') + '.pdf',
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
      print('File save on $newDirectory');
    } else {
      print("Permission denied");
    }
  }

  //
  openFile({required String url, required String fileName}) async {
    // download file
    final file = await downloadFile(url, fileName);

    //
    if (file == null) return;
    print('path:  ${file.path}');
    OpenFile.open(file.path);
  }

  //
  Future<File?> downloadFile(String url, String fileName) async {
    // file location
    // final appStorage = await getApplicationDocumentsDirectory();
    final appStorage = await Directory('/storage/emulated/0/PsyAssistant')
        .create(recursive: true);
    final file = File('${appStorage.path}/$fileName');

    // download file
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      // store on file system
      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();

      return file;
    } catch (e) {
      print('dio error: $e');
      return null;
    }
  }
}
