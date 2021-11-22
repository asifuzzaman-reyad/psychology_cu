import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
            return Center(child: const Text(''));
          }

          String currentBatch = snapshot.data!.get('batch').toString();
          print('notice for : ' + currentBatch);

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Notice')
                  .doc(currentBatch)
                  .collection('Cr')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;
                return snapshot.data!.size == 0
                    ? const Center(child: Text('No notice found'))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (BuildContext context, int index) {
//
                          var notice = data[index];
                          return Card(
                            margin: EdgeInsets.zero,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //header
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: notice.get('crImage'),
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          backgroundImage: imageProvider,
                                          radius: 22,
                                        ),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            const CircleAvatar(
                                                radius: 22,
                                                child:
                                                    CupertinoActivityIndicator(),
                                                backgroundImage: AssetImage(
                                                    'assets/images/pp_placeholder.png')),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(notice.get('crName'),
                                              style: const TextStyle(
                                                  // color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.schedule,
                                                  // color: Colors.black45,
                                                  size: 16),
                                              const SizedBox(width: 3),
                                              Text(notice.get('time'),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      // color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                //message
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 12),
                                  child: Text(notice.get('message')),
                                ),
                              ],
                            ),
                          );
                        },
                      );
              });
        },
      ),
    );
  }
}
