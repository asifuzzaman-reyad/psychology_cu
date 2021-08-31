import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/constants.dart';
import 'package:psychology_cu/widget/custom_button.dart';


class StuffList extends StatelessWidget {

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
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              print(document);
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: new ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: CachedNetworkImage(
                      imageUrl: document.get('imageUrl'),
                      fadeInDuration: Duration(milliseconds: 500),
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, radius: 32,),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircleAvatar(radius: 32,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                      errorWidget: (context, url, error) => CircleAvatar(radius: 32,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                    ),
                    title: Expanded(
                      child: new Text(
                        '${document.get('name')}',
                      ),
                    ),
                    subtitle: new Text(
                      document.get('post'),
                      style: TextStyle(color: Colors.teal),
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