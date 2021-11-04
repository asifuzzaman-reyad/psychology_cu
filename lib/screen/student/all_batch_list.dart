import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import 'widgets/batch_student_card.dart';

class AllBatchList extends StatefulWidget {
  const AllBatchList({Key? key}) : super(key: key);

  @override
  _AllBatchListState createState() => _AllBatchListState();
}

class _AllBatchListState extends State<AllBatchList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kBatchList.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('All Student List'),
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
  final String batch;

  const BatchInformation({Key? key, required this.batch}) : super(key: key);

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
              return const Center(child: Text('Something wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Data found'));
            }

            var data = snapshot.data!.docs;
            String studentCounter = 'Total Student: ' + data.length.toString();

            return Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                    margin: const EdgeInsets.only(top: 4, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(32)),
                    child: Text(
                      studentCounter,
                      style: const TextStyle(fontSize: 15),
                    )),
                Scrollbar(
                  radius: const Radius.circular(8),
                  interactive: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 16, right: 16, left: 16),
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      return BatchStudentCard(data: data[index]);
                      // return StudentCard(student: data[index]);
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
