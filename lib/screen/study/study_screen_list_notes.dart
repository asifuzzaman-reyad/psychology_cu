import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bookmarks/study_bookmark_button.dart';
import 'components/course_category_card.dart';
import 'components/no_data_found.dart';

class StudyScreenListNotes extends StatefulWidget {
  const StudyScreenListNotes({
    key,
    required this.courseCode,
    required this.year,
    required this.courseType,
    required this.courseCategory,
    required this.subtitle,
    required this.chapterNo,
    required this.chapterTitle,
  }) : super(key: key);

  final String year;
  final String courseCode;
  final String courseType;
  final String courseCategory;
  final String subtitle;
  final String chapterNo;
  final String chapterTitle;

  @override
  _StudyCategoryScreenStateNotes createState() =>
      _StudyCategoryScreenStateNotes();
}

class _StudyCategoryScreenStateNotes extends State<StudyScreenListNotes> {
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

    //
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
    //
    CollectionReference reference = FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection(widget.courseCategory)
        .doc('Lessons')
        .collection(widget.chapterNo);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterNo + '. ' + widget.chapterTitle),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        actions: const [
          // study bookmark
          StudyBookmarkButton(),

          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async =>
              setState(() => loadCategoryScreenNotes(reference)),
          child: loadCategoryScreenNotes(reference)),
    );
  }

  //load category notes
  StreamBuilder<QuerySnapshot<Object?>> loadCategoryScreenNotes(
      CollectionReference<Object?> reference) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.orderBy('title').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Course Category Card
        return snapshot.data!.size > 0
            ? CourseCategoryCard(
                subtitle: widget.subtitle,
                snapshot: snapshot,
                ref: reference,
              )
            : const NoDataFound();
      },
    );
  }
}
