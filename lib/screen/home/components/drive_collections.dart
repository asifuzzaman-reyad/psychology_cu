import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/headline.dart';
import '../widgets/link_card.dart';

class DriveCollections extends StatelessWidget {
  const DriveCollections({Key? key}) : super(key: key);

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
