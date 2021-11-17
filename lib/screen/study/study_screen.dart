import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import 'components/course_card.dart';

class StudyScreen extends StatefulWidget {
  static const routeName = 'study_screen';

  const StudyScreen({Key? key}) : super(key: key);

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  String batch = '';
  String year = '';

  String? selectedYear;
  String yearHint = 'Year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: false,
        elevation: 0,
        title: const Text(
          "Study",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Card(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            color: Colors.pink[100],
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  hint: Text(yearHint),
                  value: selectedYear,
                  items: kYearList
                      .map((String item) =>
                          DropdownMenuItem(child: Text(item), value: item))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedYear = value!;
                      // print(value);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      //

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // get batch
          var userBatch = snapshot.data!.get('batch');
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Batch')
                .doc(userBatch)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // course category
              var year = snapshot.data!.get('year');
              return courseCategory(year);
            },
          );
        },
      ),
    );
  }

  // courseCategory
  Widget courseCategory(year) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //major course
          CourseCard(year: selectedYear ?? year, courseType: 'Major Course'),

          // related course
          CourseCard(year: selectedYear ?? year, courseType: 'Related Course'),
        ]),
      ),
    );
  }
}
