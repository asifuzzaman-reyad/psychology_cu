import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:psy_assistant/admob/ad_state.dart';
import 'package:psy_assistant/admob/my_banner_ad.dart';

import '/constants.dart';
import 'components/course_card.dart';

class StudyScreen extends StatefulWidget {
  static const routeName = 'study_screen';

  const StudyScreen({Key? key}) : super(key: key);

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // banner init
  late BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

  //var
  String batch = '';
  String year = '';

  String? selectedYear;
  String yearHint = 'Year';

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

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
    return Scrollbar(
      interactive: true,
      radius: const Radius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //major course
            CourseCard(year: selectedYear ?? year, courseType: 'Major Course'),

            //banner ad
            MyBannerAd(banner: banner, enableMargin: true),

            // related course
            CourseCard(
                year: selectedYear ?? year, courseType: 'Related Course'),
          ]),
        ),
      ),
    );
  }
}
