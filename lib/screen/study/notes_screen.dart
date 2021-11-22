import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../study/components/no_data_found.dart';
import '../study/study_screen_list_notes.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    key,
    required this.year,
    required this.courseType,
    required this.courseCode,
    required this.courseCategory,
    required this.subtitleType,
  }) : super(key: key);

  final String year;
  final String courseType;
  final String courseCode;
  final String courseCategory;
  final String subtitleType;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('No Internet Connection'),
          action: SnackBarAction(
            onPressed: () async {
              await AppSettings.openDeviceSettings();
            },
            label: 'Connect',
          ),
        ));
      } else {
        print('network status: $_connectionStatus');
      }
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection('Lessons');

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async => setState(() => loadNotesScreen(reference)),
          child: loadNotesScreen(reference)),
    );
  }

  //
  StreamBuilder<QuerySnapshot<Object?>> loadNotesScreen(
      CollectionReference<Map<String, dynamic>> reference) {
    return StreamBuilder<QuerySnapshot>(
        stream: reference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return snapshot.data!.size > 0
              ? Scrollbar(
                  interactive: true,
                  radius: const Radius.circular(8),
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data!.docs.map((document) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudyScreenListNotes(
                                year: widget.year,
                                courseType: widget.courseType,
                                courseCode: widget.courseCode,
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
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber.shade200,
                            ),
                            alignment: Alignment.center,
                            child: Text(document.id,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                )),
                          ),
                          title: Text(
                            '${document.get('title')}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const NoDataFound();
        });
  }
}
