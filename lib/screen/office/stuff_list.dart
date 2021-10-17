import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/widgets/custom_button.dart';

class StuffList extends StatelessWidget {
  const StuffList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Stuff')
            .orderBy('serial')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              print(document);
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: CachedNetworkImage(
                      imageUrl: document.get('imageUrl'),
                      fadeInDuration: const Duration(milliseconds: 500),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 32,
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            AssetImage('assets/images/pp_placeholder.png'),
                        child: CupertinoActivityIndicator(),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png')),
                    ),
                    title: Text(
                      '${document.get('name')}',
                    ),
                    subtitle: Text(
                      document.get('post'),
                      style: const TextStyle(color: Colors.teal),
                    ),
                    trailing: CustomButton(
                      type: 'tel:',
                      link: '${document.get('mobile')}',
                      icon: Icons.call,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
