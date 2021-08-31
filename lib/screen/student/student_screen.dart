import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/student/all_batch.dart';

class StudentScreen extends StatelessWidget {
  static const routeName = 'student_screen';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
        // centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllBatch()));
                },
                child: Text('All Batch')),
          )
        ],
      ),


      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Psychology')
                  .doc('Students')
                  .collection(snapshot.data!.get('batch')).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;

                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 16),
                  itemBuilder: (BuildContext context, int index) {
                    // return Text(data[index].get('name'));
                    return StudentCard(student: data[index]);
                  },
                );
              });
        },
      ),
    );
  }
}

// student card
class StudentCard extends StatelessWidget {
  StudentCard({required this.student});
  final QueryDocumentSnapshot student;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                  spreadRadius: .2,
                  offset: Offset(2, 3))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //info
            Expanded(
              flex: 5,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    // 'Azizul Hakim Sojol',
                    student.get('name'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Student ID', style: TextStyle(fontSize: 12)),
                  Text(
                    student.get('id'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  if(student.get('hall') != '' )
                  Text('Hall', style: TextStyle(fontSize: 12)),
                  Text(
                    student.get('hall'),
                    // 'Student All  name place holder holderholderholderholderholder',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8),
            //image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: student.get('imageUrl'),
                  fadeInDuration: Duration(milliseconds: 500),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      ClipRRect(borderRadius:BorderRadius.circular(8) ,child: Image.asset('assets/images/pp_placeholder.png')),
                  errorWidget: (context, url, error) => ClipRRect(borderRadius:BorderRadius.circular(8) ,child: Image.asset('assets/images/pp_placeholder.png')),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // call and message button
  // Row buildRow() {
  //   return Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: Colors.green,
  //                       // shape: BoxShape.circle,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Icon(
  //                       Icons.call,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   SizedBox(width: 8),
  //                   Container(
  //                     padding: EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: Colors.indigoAccent,
  //                       // shape: BoxShape.circle,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Icon(
  //                       Icons.message,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               );
  // }
}
