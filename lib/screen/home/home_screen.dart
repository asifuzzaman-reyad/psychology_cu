import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '/screen/home/header.dart';
import '../home/components/custom_drawer.dart';
import '../home/components/home_appbar.dart';
import 'components/categories.dart';
import 'components/headline.dart';
import 'components/important_links.dart';
import 'widgets/link_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(context),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header
              Header(),

              const SizedBox(height: 24),

              // categories
              Categories(),

              const SizedBox(height: 24),

              //important links
              ImportantLinks(),

              const SizedBox(height: 24),

              //collection links
              const CollectionLinks(),

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
  const CollectionLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        const Headline(title: 'Google Drive links'),

        //
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Psychology')
              .doc('Drives')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.count(
              shrinkWrap: true,
              primary: true,
              // scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: .9,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
