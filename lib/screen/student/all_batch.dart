import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

class AllBatch extends StatefulWidget {
  const AllBatch({Key? key}) : super(key: key);

  @override
  _AllBatchState createState() => _AllBatchState();
}

class _AllBatchState extends State<AllBatch> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: batchList.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('All Student List'),
          bottom: TabBar(
            tabs: [
              Tab(text: batchList[0]),
              Tab(text: batchList[1]),
              Tab(text: batchList[2]),
              Tab(text: batchList[3]),
              Tab(text: batchList[4]),
            ],
            isScrollable: true,
          ),
        ),
        body: TabBarView(children: [
          BatchInformation(batch: batchList[0]),
          BatchInformation(batch: batchList[1]),
          BatchInformation(batch: batchList[2]),
          BatchInformation(batch: batchList[3]),
          BatchInformation(batch: batchList[4]),
        ]),
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
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _idController = TextEditingController();
  TextEditingController _sessionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.batch);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Add Student Info'),
                content: Form(
                    key: _globalKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _sessionController,
                          maxLength: 2,
                          decoration: InputDecoration(hintText: 'session'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter session';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _idController,
                          maxLength: 2,
                          decoration: InputDecoration(hintText: 'Id'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter id';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                addStudentInformation(widget.batch);
                              },
                              child: Text('Add Info')),
                        ),
                      ],
                    ))),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Psychology')
              .doc('Students')
              .collection(widget.batch)
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
                        title:
                            // data[index].get('name') == '' ? Text('Name') :
                            Text(data[index].get('name')),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text( 'ID :  '+ data[index].get('id')),
                            Text.rich(
                              TextSpan(
                                text: 'ID :  ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: data[index].get('id'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            data[index].get('hall') == ''
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
                                              color: Colors.black),
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

  //
  addStudentInformation(String batch) {
    if (_globalKey.currentState!.validate()) {
      String id = '${_sessionController.text}6080${_idController.text}';
      FirebaseFirestore.instance
          .collection('Psychology')
          .doc('Students')
          .collection(batch)
          .doc(id)
          .set(
        {
          'batch': batch,
          'name': '',
          'id': id,
          'hall': '',
          'mobile': '',
          'imageUrl': '',
        },
      ).whenComplete(() {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Upload Complete');
        _idController.clear();
      });
    }
  }
}
