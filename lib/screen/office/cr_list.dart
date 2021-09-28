import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './/screen/home/components/headline.dart';
import './/widget/custom_button.dart';

class CrList extends StatelessWidget {
  CrList({required this.year});
  final String year;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Cr')
          .where('year', isEqualTo: year)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Headline(title: year),
            SizedBox(height: 4),

            //
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                print(document);
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 3,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(8),

                      //image
                      leading: CachedNetworkImage(
                        imageUrl: document.get('imageUrl'),
                        fadeInDuration: Duration(milliseconds: 500),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 32,
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png'),
                          child: CupertinoActivityIndicator(),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                AssetImage('assets/images/pp_placeholder.png')),
                      ),

                      //
                      title: new Text(
                        document.get('name'),
                        maxLines: 1,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.orange[100],
                                ),
                                child: Text(
                                  '${document.get('batch')}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.greenAccent[100],
                                ),
                                child: Text(
                                  '${document.get('session')}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                      children: [
                        Row(
                          children: [
                            //mail
                            CustomButton(
                                type: 'mailto:',
                                link: document.get('email').toString(),
                                icon: Icons.mail,
                                color: Colors.red),

                            //facebook
                            SizedBox(width: 8),
                            CustomButton(
                                type: '',
                                link: document.get('facebook').toString(),
                                icon: Icons.facebook,
                                color: Colors.blue),

                            // call
                            SizedBox(width: 8),
                            CustomButton(
                                type: 'tel:',
                                link: document.get('mobile'),
                                icon: Icons.call,
                                color: Colors.green),
                            SizedBox(width: 8),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ],
                      childrenPadding: EdgeInsets.all(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  //
  uploadCrData() {
    FirebaseFirestore.instance.collection('Cr').doc().set({
      'name': '',
      'session': '',
      'batch': 'Batch 1',
      'year': '4th Year',
      'mobile': '',
      'email': '',
      'facebook': '',
      'imageUrl': '',
    }).whenComplete(() {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Upload successful');
    });
  }
}
