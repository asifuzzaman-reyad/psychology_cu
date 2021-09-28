import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '/screen/home/categories.dart';
import '/screen/home/header.dart';
import '/screen/home/important_links.dart';
import '../home/components/custom_appbar.dart';
import '../home/components/custom_drawer.dart';
import 'components/headline.dart';
import 'components/link_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header
              Header(),

              SizedBox(height: 24),

              // categories
              Categories(),

              SizedBox(height: 24),

              //important links
              ImportantLinks(),

              SizedBox(height: 24),

              //collection links
              CollectionLinks(),

              // collections
            ],
          ),
        ),
      ),
    );
  }
}

// collection links
class CollectionLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        Headline(title: 'Google Drive links'),

        //
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Psychology')
              .doc('Drives')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return GridView.count(
              shrinkWrap: true,
              primary: true,
              // scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: .9,
              crossAxisSpacing: 8,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: [

                // drive link
                LinkCard(
                  title: '1st Year',
                  link: snapshot.data!.get('1st year'),
                  imageUrl: 'assets/logo/google_drive.png',
                  enableBorder: true,
                ),
                LinkCard(
                  title: '2nd Year',
                  link: snapshot.data!.get('2nd year'),
                  imageUrl: 'assets/logo/google_drive.png',
                  enableBorder: true,
                ),
                LinkCard(
                  title: '3rd Year',
                  link: snapshot.data!.get('3rd year'),
                  imageUrl: 'assets/logo/google_drive.png',
                  enableBorder: true,
                ),
                LinkCard(
                  title: '4th Year',
                  link: snapshot.data!.get('4th year'),
                  imageUrl: 'assets/logo/google_drive.png',
                  enableBorder: true,
                ),

              ],
            );
          },
        ),
      ],
    );
  }
}


