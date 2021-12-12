import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:psy_assistant/admob/ad_state.dart';
import 'package:psy_assistant/admob/my_banner_ad.dart';

import '/screen/profile/edit_profile_screen.dart';
import '/screen/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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

  // firebase user
  var userRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());

  // firebase
  var studentRef =
      FirebaseFirestore.instance.collection('Psychology').doc('Students');

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
          profileSignOutButton(context),
        ],
      ),

      // profile body
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var batch = snapshot.data!.get('batch').toString();
          var id = snapshot.data!.get('id').toString();

          //
          return StreamBuilder<DocumentSnapshot>(
            stream: studentRef.collection(batch).doc(id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              //
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //image
                          CachedNetworkImage(
                            imageUrl: snapshot.data!.get('imageUrl'),
                            fadeInDuration: const Duration(milliseconds: 500),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 100,
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage(
                                  'assets/images/pp_placeholder.png'),
                              child: CupertinoActivityIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                        'assets/images/pp_placeholder.png')),
                          ),

                          const SizedBox(height: 8),

                          //name
                          Text(
                            snapshot.data!.get('name'),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 2),

                          //id
                          Text(
                            'ID: ' + snapshot.data!.get('id'),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          // session and batch
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //batch
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  snapshot.data!.get('batch'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // session
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${int.parse(snapshot.data!.get('id').toString().substring(0, 2)) - 1}'
                                  ' - ${snapshot.data!.get('id').toString().substring(0, 2)}',
                                  style: const TextStyle(
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

                    //banner ad
                    MyBannerAd(banner: banner),

                    const SizedBox(height: 8),

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
                            const SizedBox(height: 56),
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
                            margin: const EdgeInsets.only(right: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 24, 16, 24),
                              child: Row(
                                children: [
                                  // information
                                  RotatedBox(
                                    quarterTurns: -45,
                                    child: Container(
                                      color: Colors.grey.shade300,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Information'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // mobile, email, hall
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Mobile No',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.get('mobile'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Email Address',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        FirebaseAuth.instance.currentUser!.email
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Hall Name',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.get('hall'),
                                        style: const TextStyle(
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

                    const SizedBox(height: 16),

                    //edit profile button
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(16),
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
                        label: const Text('Edit Profile'),
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // sign out
    );
  }

  //sign out button
  Widget profileSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.pink[100],
          padding: const EdgeInsets.only(right: 6, left: 16),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('sign out'.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      content: const Text('Are you sure to sign out?'),
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
                                  Fluttertoast.showToast(msg: 'Signing Out...');
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      // LoginScreen.routeName,
                                      WelcomeScreen.routeName,
                                      ((Route<dynamic> route) => false));
                                },
                                child: Text('Sign Out'.toUpperCase())),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ));
          },
          child: Row(
            children: const [
              Text(
                'Sign Out',
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.logout_outlined,
                size: 21,
                color: Colors.black87,
              ),
            ],
          )),
    );
  }
}
