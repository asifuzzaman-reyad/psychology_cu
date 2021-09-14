import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/headline.dart';
import 'components/link_card.dart';

class ImportantLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        Headline(title: 'Important links'),

        //category card grid
        GridView.count(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          children: [
            //cu.com
            LinkCard(
              title: 'University of chittagong',
              link: 'https://cu.ac.bd/',
              imageUrl: 'assets/logo/cu_logo.png',
            ),

            //psycu.net
            LinkCard(
              title: 'Department of psychology',
              color: Colors.orange,
              link: 'https://www.psycu.net',
              imageUrl: 'assets/logo/psy_cu.png',
            ),

            // psychology family
            LinkCard(
              title: 'Department of Psychology, CU',
              link: 'https://www.facebook.com/groups/psycu',
              imageUrl: 'assets/logo/facebook.png',
            ),
          ],
        ),

        //
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Batch')
                  .doc(snapshot.data!.get('batch'))
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
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  children: [

                    // psychology family
                    LinkCard(
                      title: 'Psychology family, CU Group',
                      link: snapshot.data!.get('family_group'),
                      imageUrl: 'assets/logo/facebook.png',
                    ),

                    //batch fb
                    LinkCard(
                      title: 'Batch Facebook Group',
                      link: snapshot.data!.get('fb_group'),
                      imageUrl: 'assets/logo/facebook.png',
                    ),

                    //psycu.net
                    LinkCard(
                      title: 'Batch WhatsApp Group',
                      link: snapshot.data!.get('wa_group'),
                      imageUrl: 'assets/logo/whatsapp.png',
                    ),


                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
