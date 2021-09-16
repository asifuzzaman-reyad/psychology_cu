import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AllBatch extends StatefulWidget {
  @override
  _AllBatchState createState() => _AllBatchState();
}

class _AllBatchState extends State<AllBatch> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kBatchList.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('All Student List'),
          bottom: TabBar(
            tabs: [
              Tab(text: kBatchList[0]),
              Tab(text: kBatchList[1]),
              Tab(text: kBatchList[2]),
              Tab(text: kBatchList[3]),
              Tab(text: kBatchList[4]),
              Tab(text: kBatchList[5]),
              Tab(text: kBatchList[6]),
              Tab(text: kBatchList[7]),
            ],
            isScrollable: true,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            BatchInformation(batch: kBatchList[0]),
            BatchInformation(batch: kBatchList[1]),
            BatchInformation(batch: kBatchList[2]),
            BatchInformation(batch: kBatchList[3]),
            BatchInformation(batch: kBatchList[4]),
            BatchInformation(batch: kBatchList[5]),
            BatchInformation(batch: kBatchList[6]),
            BatchInformation(batch: kBatchList[7]),
          ],
        ),
      ),
    );
  }
}

//
class BatchInformation extends StatefulWidget {
  const BatchInformation({required this.batch});
  final String batch;

  @override
  _BatchInformationState createState() => _BatchInformationState();
}

class _BatchInformationState extends State<BatchInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Psychology')
              .doc('Students')
              .collection(widget.batch)
              .orderBy('status')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.length == 0) {
              return Center(child: Text('No Data found'));
            }

            var data = snapshot.data!.docs;
            String studentCounter = 'Total: ' + data.length.toString();

            return Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                    child: Text(studentCounter)),
                ListView.separated(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(top: 24, bottom: 16, right: 16, left: 16),
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.all(0),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            imageUrl: data[index].get('imageUrl'),
                            fadeInDuration: Duration(milliseconds: 500),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                        'assets/images/pp_placeholder.png')),
                            errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                    'assets/images/pp_placeholder.png')),
                          ),
                        ),
                        title: Text(data[index].get('name')),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'ID :  ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: data[index].get('id'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            data[index].get('hall') == '' ||
                                    data[index].get('hall') ==
                                        'Info not available'
                                ? Text('')
                                : Text.rich(
                                    TextSpan(
                                      text: 'Hall :  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: data[index].get('hall'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        // isThreeLine: true,
                      ),
                    );
                    // return StudentCard(student: data[index]);
                  },
                ),
              ],
            );
          }),
    );
  }
}
