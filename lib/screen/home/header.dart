import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: CircularProgressIndicator());
                    return Center(
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  }

                  //
                  return Text(
                    snapshot.data!.get('name').toString().toUpperCase(),
                    // 'Explore your life'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              );
            },
          ),
          SizedBox(height: 4),
          Text(
            'Welcome to psychology family',
            style: TextStyle(fontSize: 16,
              // color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}