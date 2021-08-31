import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../home/components/custom_appbar.dart';
import '../home/components/custom_drawer.dart';
import '../../constants.dart';
import '../community/community_screen.dart';
import '../home/components/headline.dart';
import '../office/office_screen.dart';
import '../student/student_screen.dart';
import '../teacher/teacher_screen.dart';
import 'components/category_card.dart';
import 'components/link_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}

// header
class Header extends StatelessWidget {
  final userRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());
  final studentRef =
  FirebaseFirestore.instance.collection('Psychology').doc('Students');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: userRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return Center(child: CircularProgressIndicator());
                  return Center(child: Text(''));
                }

                var batch = snapshot.data!.get('batch').toString();
                var id = snapshot.data!.get('id').toString();

                //
                return StreamBuilder<DocumentSnapshot>(
                    stream: studentRef.collection(batch).doc(id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        // return Center(child: CircularProgressIndicator());
                        return Center(child: Text('', style: TextStyle(
                          fontSize: 24
                        ),));
                      }


                      //
                      return  Text(
                        snapshot.data!.get('name').toString().toUpperCase(),
                        // 'Explore your life'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 1,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    });
              }),
          // Text(
          //   'Hellos',
          //   // 'Explore your life'.toUpperCase(),
          //   style: TextStyle(
          //     fontSize: 32,
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 1,
          //     color: Colors.black,
          //   ),
          //   overflow: TextOverflow.ellipsis,
          // ),
          SizedBox(height: 4),
          Text(
            'Welcome to psychology family',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// categories
class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        Headline(title: 'Categories'),

        //category card grid
        GridView.count(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: .8,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          children: [
            CategoryCard(
              title: 'Teacher\ninformation',
              color: kCardColor1,
              routeName: TeacherScreen.routeName,
            ),
            CategoryCard(
              title: 'Student\ninformation',
              color: kCardColor2,
              routeName: StudentScreen.routeName,
            ),
            CategoryCard(
              title: 'CR &\nOffice staff',
              color: kCardColor3,
              routeName: OfficeScreen.routeName,
            ),
            CategoryCard(
              title: 'Student\ncommunity',
              color: kCardColor4,
              routeName: CommunityScreen.routeName,
            ),
          ],
        ),
      ],
    );
  }
}

//important links
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
              title: 'Psychology family Group',
              link: 'https://www.facebook.com/groups/1603235309944320',
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
                  padding: EdgeInsets.symmetric( horizontal: 8),
                  children: [
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

                    // psychology family
                    LinkCard(
                      title: 'Batch Google Drive',
                      link: snapshot.data!.get('drive_link'),
                      imageUrl: 'assets/logo/google_drive.png',
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
