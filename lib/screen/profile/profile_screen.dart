import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/auth/login_screen.dart';
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
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: Colors.pink[100],
                padding: EdgeInsets.only(right: 6, left: 16),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('sign out'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: Text('Are you sure to sign out?'),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'.toUpperCase())),
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Fluttertoast.showToast(
                                            msg: 'Signing Out...');
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            LoginScreen.routeName,
                                            ((Route<dynamic> route) => false));
                                      },
                                      child: Text('Sign Out'.toUpperCase())),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ));
                },
                child: Row(
                  children: [
                    Text('Sign Out'),
                    SizedBox(width: 10),
                    Icon(
                      Icons.logout_outlined,
                      size: 21,
                    ),
                  ],
                )),
          ),
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

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    //
                    return Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // header
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //image
                                CachedNetworkImage(
                                  imageUrl: snapshot.data!.get('imageUrl'),
                                  fadeInDuration: Duration(milliseconds: 500),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 100,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                        'assets/images/pp_placeholder.png'),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          radius: 100,
                                          backgroundImage: AssetImage(
                                              'assets/images/pp_placeholder.png')),
                                ),

                                SizedBox(height: 8),

                                //name
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    //batch
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        snapshot.data!.get('batch'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),

                                    // session
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${int.parse(snapshot.data!.get('id').toString().substring(0, 2)) - 1}'
                                        ' - ${snapshot.data!.get('id').toString().substring(0, 2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          //information section
                          Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 20,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 56),
                                  Container(
                                    height: 8,
                                    width: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),

                              //
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.only(right: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 24, 16, 24),
                                    child: Row(
                                      children: [
                                        // information
                                        RotatedBox(
                                          quarterTurns: -45,
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Information'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 8),

                                        // mobile, email, hall
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mobile No',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.get('mobile'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Email Address',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Hall Name',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.get('hall'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(16),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                            batch: batch,
                                            id: id,
                                            snapshot: snapshot.data!)));
                              },
                              label: Text('Edit Profile'),
                              icon: Icon(Icons.edit),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // sign out
    );
  }
}
