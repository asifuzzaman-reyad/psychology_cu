import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/auth/login_screen.dart';
import 'package:psychology_cu/screen/auth/register_info_screen.dart';
import 'package:psychology_cu/screen/home/components/headline.dart';
import 'package:psychology_cu/screen/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());
  var studentRef =
      FirebaseFirestore.instance.collection('Psychology').doc('Students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()));
              },
              icon: Icon(Icons.edit)),
          SizedBox(width: 12)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: userRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                          return Center(child: CircularProgressIndicator());
                        }

                        //
                        return Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              // header
                              Container(
                                padding: EdgeInsets.all(16),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    //image
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data!.get('imageUrl'),
                                      fadeInDuration: Duration(milliseconds: 500),
                                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, radius: 100,),
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircleAvatar(radius: 100,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),

                                    //name
                                    SizedBox(height: 8),
                                    Text(
                                      snapshot.data!.get('name'),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 2),

                                    //id
                                    Text(
                                      'ID: ' + snapshot.data!.get('id'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    // session and batch
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                                snapshot.data!.get('batch'))),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.amberAccent,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                              '${int.parse(snapshot.data!.get('id').toString().substring(0, 2)) - 1}'
                                              ' - ${snapshot.data!.get('id').toString().substring(0, 2)}'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //information
                              SizedBox(height: 8),
                              Headline(title: 'Information'),
                              SizedBox(height: 8),

                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mobile',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      snapshot.data!.get('mobile'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      FirebaseAuth.instance.currentUser!.email
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Hall',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      snapshot.data!.get('hall'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //information
                              SizedBox(height: 8),

                              //
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                    leading: Icon(Icons.settings),
                                    title: Headline(title: 'Settings'),
                                    children: [
                                      Container(
                                        // color: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () async {
                                                await FirebaseAuth.instance.signOut();
                                                print('Sign Out');
                                                Fluttertoast.showToast(msg: 'Sign out');
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              },
                                              tileColor: Colors.white,
                                              leading: Icon(Icons.exit_to_app),
                                              title: Text('Sign Out'),
                                            ),
                                            SizedBox(height: 2),
                                            ListTile(
                                              onTap: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Are you sure?'),
                                                      content: Text(
                                                          'Delete your account permanently'),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  var user =
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser;
                                                                  //delete user
                                                                  await user!
                                                                      .delete();
                                                                  print(
                                                                      'Delete user from auth list');

                                                                  // delete data
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                      'Users')
                                                                      .doc(user.uid
                                                                      .toString())
                                                                      .delete();
                                                                  print(
                                                                      'Delete user info from database');

                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                              RegisterInfoScreen()));
                                                                },
                                                                child: Text('Yes')),
                                                            // SizedBox(width: 8),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text('No')),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                              },
                                              tileColor: Colors.white,
                                              leading: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              title: Text(
                                                'Delete Account',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                ),
                              ),

                            ],
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
